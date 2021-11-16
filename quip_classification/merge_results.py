import os
import sys
import json

# file formats:
# IOTileTime = 5.556636287365109 sec /path/file.svs
# DONE in 257.6040445910767 sec /path/file.svs
def add_to_results(results, line, idx):
    if line[4] not in results:
        results[line[4]] = [0]
    i = idx + 1 - len(results[line[4]])
    while i > 0: # add zeros until the index
        results[line[4]].append(0)
        i -= 1
    results[line[4]][idx] = float(line[2])
    return results

def fill_with_zeros(results, idx):
    for i in results:
        results[i] = results [i] + [0] * (idx - len(results[i]))
    return results

def write_to_file(results, filename):
    outf = open(filename, "w")
    outf.write(json.dumps(results))
    outf.close()

def main():
    if len(sys.argv) < 2:
        print("Usage: %s path_to_quip_result_files" %(sys.argv[0]))
        return

    results = {} # results[file] = [r1,r2,r3,...]
    results_time = {} 
    idx = 0 # file index
    for filename in os.listdir(sys.argv[1]):
        print("Parsing %s" %(filename))
        with open(sys.argv[1]+"/"+filename, 'r') as f:
            for line in f:
                line = line[:-1].split(" ")
                if len(line) < 5:
                    continue
                if "Time" in line[0]:
                    results_time = add_to_results(results_time, line, idx)
                if line[0] == "DONE":
                    results = add_to_results(results, line, idx)
            f.close()
        idx += 1
    results = fill_with_zeros(results, idx)
    results_time = fill_with_zeros(results_time, idx)
    write_to_file(results, "out.DONE")
    write_to_file(results_time, "out.Time")
    print("Total files:", idx)
    cnt = 0
    for i in results:
        if bool([x for x in results[i] if x==0]):
            continue
        # count all files that have timeing for all measurements
        cnt += 1
    print("Results with complete measurements:", cnt)

if __name__ == "__main__":
    main()
