import sys

extra_checks = False

# model is a file with the output of the patch prediction code
# File format:
# patch_x patch_y prediction_value
def read_patch_file(model, threshold=0):
    positive_patches = set()
    inf = open(model, "r")
    for line in inf:
        line = line[:-1].split(" ")
        value = float(line[2])
        if value == 0:
            continue
        if threshold != 0 and value < threshold:
            continue
        positive_patches.add((line[0], line[1]))
    inf.close()
    return positive_patches

# compute the dice coeficient
def test_correcness(model1, model2, thresholds=[0, 0]):
    patch_list1 = read_patch_file(model1, threshold=thresholds[0])
    patch_list2 = read_patch_file(model2, threshold=thresholds[1])

    dice_coef = 2 * len(set.union(patch_list1, patch_list2)) / (len(patch_list1) + len(patch_list2))
    print("Dice coeficient:", dice_coef)

    #if extra_checks:
    return dice_coef
    
if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python %s file_model1 file_model2 [threshold1 threshold2]" %(sys.argv[0]))
        exit(1)

    model1 = sys.argv[1]
    model2 = sys.argv[2]

    th1 = 0
    th2 = 0
    if len(sys.argv) > 3:
        th1 = float(sys.argv[3])
        th2 = float(sys.argv[3])
    if len(sys.argv) > 4:
        th2 = float(sys.argv[4])

    ret = test_correcness(model1, model2, thresholds=[th1, th2])
    print("DONE")
 
