#!/bin/bash
set -x
ROOT_PATH=/gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/quip_classification/u24_lymphocyte
source ${ROOT_PATH}/conf/variables.sh

THREAD=$1
NTHREADS=$2

bash ${ROOT_PATH}/patch_extraction/save_svs_to_tiles.sh ${THREAD}  ${NTHREADS} 2>&1 # > ${LOG_OUTPUT_FOLDER}/log.save_svs_to_tiles.thread_${THREAD} 2>&1
set +x 
exit 0
