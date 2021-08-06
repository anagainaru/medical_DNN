#!/bin/bash
ROOT_PATH=/gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/quip_classification/u24_lymphocyte
THREAD=$1
NTHREADS=$2

set -x 
source $ROOT_PATH/conf/variables.sh

echo $PATCH_PATH 
echo $LYM_CNN_PRED_DEVICE

echo "bash $ROOT_PATH/prediction/lymphocyte/pred_thread_lym.sh ${SVS_INPUT_PATH} ${THREAD} ${NTHREADS} ${LYM_CNN_PRED_DEVICE}"
bash $ROOT_PATH/prediction/lymphocyte/pred_thread_lym.sh \
    ${SVS_INPUT_PATH} ${THREAD} ${NTHREADS} ${LYM_CNN_PRED_DEVICE} #\
    #> ${LOG_OUTPUT_FOLDER}/log.pred_thread_lym_${THREAD}.txt 2>&1

set +x 
exit 0
