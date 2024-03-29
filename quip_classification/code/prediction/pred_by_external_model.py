import getopt
import sys
import os
import numpy as np
from PIL import Image
import time

from external_model_pytorch import load_external_model, pred_by_external_model
from external_model_pytorch import restart_external_model

from PIL import ImageFile
NOADIOS = False
try:
    import adios2
except ImportError:
    NOADIOS = True

ImageFile.LOAD_TRUNCATED_IMAGES = True

APS = 100
adios_extension = ".bp"
#adios_engine = "sst"
adios_engine = "BPFile"

TileFolder = sys.argv[1].replace('svs/','patches/')
BPFileName = sys.argv[1].replace('svs/','patches/') + adios_extension
CNNModel = sys.argv[2]

heat_map_out = sys.argv[3]

BatchSize = int(sys.argv[4])  # shahira: Batch size argument
print('BatchSize = ', BatchSize)
print("SST file = ", BPFileName)

def whiteness(png):
    wh = (np.std(png[:, :, 0].flatten()) + np.std(png[:, :, 1].flatten()) + np.std(png[:, :, 2].flatten())) / 3.0
    return wh


def load_data(todo_list, rind, fh):

    X = np.zeros(shape=(BatchSize * 40, 3, APS, APS), dtype=np.float32)
    inds = np.zeros(shape=(BatchSize * 40,), dtype=np.int32)
    coor = np.zeros(shape=(20000000, 2), dtype=np.int32)

    xind = 0
    lind = 0
    cind = 0
    iotime = 0
    finished = True
    for fstep in fh:
        step = fstep.current_step()
        print("Looking at step ", step, len(fstep.available_variables()))
        step_vars = fstep.available_variables()
        for fn in step_vars:
            if fn in todo_list:
                continue
            todo_list.append(fn)
            lind += 1
            if len(fn.split('_')) < 4:
               continue

            x_off = float(fn.split('_')[0])
            y_off = float(fn.split('_')[1])
            svs_pw = float(fn.split('_')[2])
            png_pw = float(fn.split('_')[3].split('.png')[0])
            var = step_vars[fn]
            nx = int(var["Shape"].split(",")[0].strip())
            ny = int(var["Shape"].split(",")[1].strip())
            print("processing : {} nx = {}  ny = {}".format(fn, nx, ny))
            start = [0, 0, 0]
            count = [nx, ny, 3]
            t0 = time.perf_counter()
            image = fstep.read(fn, start, count)
            iotime = iotime + time.perf_counter() - t0
            png = np.array(image)
            for x in range(0, png.shape[1], APS):
                if x + APS > png.shape[1]:
                    continue
                for y in range(0, png.shape[0], APS):
                    if y + APS > png.shape[0]:
                        continue

                    if (whiteness(png[y:y + APS, x:x + APS, :]) >= 12):
                        X[xind, :, :, :] = png[y:y + APS, x:x + APS, :].transpose()
                        inds[xind] = rind
                        xind += 1

                    coor[cind, 0] = np.int32(x_off + (x + APS / 2) * svs_pw / png_pw)
                    coor[cind, 1] = np.int32(y_off + (y + APS / 2) * svs_pw / png_pw)
                    cind += 1
                    rind += 1
            if xind >= BatchSize:
                finished = False
                break
        if not finished:
            break

    X = X[0:xind]
    inds = inds[0:xind]
    coor = coor[0:cind]
    print("IOTime = {} sec for {} files out of {} {}".format(iotime, lind, len(todo_list), TileFolder))

    return todo_list, X, inds, coor, rind, finished


def val_fn_epoch_on_disk(classn, model, fh):
    all_or = np.zeros(shape=(20000000, classn), dtype=np.float32)
    all_inds = np.zeros(shape=(20000000,), dtype=np.int32)
    all_coor = np.zeros(shape=(20000000, 2), dtype=np.int32)
    rind = 0
    n1 = 0
    n2 = 0
    n3 = 0
    # shahira: Handling tensorflow memory exhaust issue on large slides
    reset_limit = 100
    cur_indx = 0
    iotime = 0
    predtime = 0
    finished = False
    todo_list = list()
    #for fstep in fh:
    #    step = fstep.current_step()
    #    print("Looking at step ", step)
    if True:
        # inspect variables in current step
        while not finished:
            t0 = time.perf_counter()
            todo_list, inputs, inds, coor, rind, finished = load_data(todo_list, rind, fh)
            iotime = iotime + time.perf_counter() - t0
            print("todo list: ", len(todo_list))
            if len(inputs) == 0:
                break

            t0 = time.perf_counter()
            output = pred_by_external_model(model, inputs)
            predtime = predtime + time.perf_counter() - t0

            all_or[n1:n1 + len(output)] = output
            all_inds[n2:n2 + len(inds)] = inds
            all_coor[n3:n3 + len(coor)] = coor
            n1 += len(output)
            n2 += len(inds)
            n3 += len(coor)

            cur_indx += 1
            if (cur_indx > reset_limit):
                cur_indx = 0
                # restarting the model in case of memory exhaust problems
                restart_external_model(model)

    n_files = len(todo_list)
    print("BatchTime = {} sec for {} files {}".format(iotime, n_files, TileFolder))
    print("PredTime = {} sec for {} files {}".format(predtime, n_files, TileFolder))
    all_or = all_or[:n1]
    all_inds = all_inds[:n2]
    all_coor = all_coor[:n3]
    return all_or, all_inds, all_coor


def split_validation(classn, input_type):
    print("Load external model")
    model = load_external_model(CNNModel)

    with adios2.open(BPFileName, "r", engine_type=adios_engine) as fh:
        print("Start reading from", BPFileName)
        # Testing
        Or, inds, coor = val_fn_epoch_on_disk(classn, model, fh)
        Or_all = np.zeros(shape=(coor.shape[0],), dtype=np.float32)
        Or_all[inds] = Or[:, 0]

    os.mkdir(TileFolder)
    fid = open(TileFolder + '/' + heat_map_out, 'w')
    for idx in range(0, Or_all.shape[0]):
        fid.write('{} {} {}\n'.format(coor[idx][0], coor[idx][1], Or_all[idx]))
    fid.close()

    return


def main(input_type):
    print("[debug] Path exists", BPFileName);
    #if not os.path.exists(BPFileName):
    #    exit(0)
    t0 = time.perf_counter()
    classes = ['Lymphocytes']
    classn = len(classes)
    sys.setrecursionlimit(10000)

    split_validation(classn, input_type)
    print('DONE in {} sec {}'.format(time.perf_counter() -t0, TileFolder))

def printUsage():
    print("Options: --input=adios ")
    return

if __name__ == "__main__":
    INPUT_TYPE = None
    print("START")
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hi:", ["help", "input"])
    except getopt.GetoptError:
        printUsage()
        sys.exit(2)
    for opt, arg in opts:
        if opt == "-h":
            printUsage()
            sys.exit()
        elif opt in ("-i", "--input"):
            INPUT_TYPE = arg
            if INPUT_TYPE == "adios" and NOADIOS:
                print("Cannot import required ADIOS library", file=sys.stderr)
                sys.exit(1)

    main("adios")
