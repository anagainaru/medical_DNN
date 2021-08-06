#!/bin/bash
set -x
ROOT_PATH=/gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/quip_classification/u24_lymphocyte
source $ROOT_PATH/conf/variables.sh

FOLDER=$1
# PARAL = [0, MAX_PARAL-1]
PARAL=$2      # a number of this particular process
MAX_PARAL=$3  # total number of processes
DEVICE=$4

echo "Device=$DEVICE"
DATA_FILE=patch-level-lym.txt
DONE_FILE=extraction_done.txt

if [ ${EXTERNAL_LYM_MODEL} -eq 0 ]; then
    EXEC_FILE=pred.py
else
    EXEC_FILE=pred_by_external_model.py
fi
echo "[debug] Prediction file: ${EXEC_FILE}"

PRE_FILE_NUM=0
while [ 1 ]; do
    LINE_N=0
    FILE_NUM=0
    EXTRACTING=0
    echo "[debug] Looking in folder: ${FOLDER}"
    for files in ${FOLDER}/*.svs; do
        FILE_NUM=$((FILE_NUM+1))

        LINE_N=$((LINE_N+1))
        if [ $((LINE_N % MAX_PARAL)) -ne ${PARAL} ]; then continue; fi

        #if [ -f ${files}/${DONE_FILE} ]; then
            if [ ! -f ${files}/${DATA_FILE} ]; then
                echo "[debug] ${files}/${DATA_FILE} generating"
                echo "python -u ${ROOT_PATH}/prediction/lymphocyte/${EXEC_FILE} ${files} ${LYM_NECRO_CNN_MODEL_PATH} ${DATA_FILE} ${LYM_PREDICTION_BATCH_SIZE} ${DEVICE}"
                THEANO_FLAGS="device=${DEVICE}" python -u ${ROOT_PATH}/prediction/lymphocyte/${EXEC_FILE} \
                    ${files} ${LYM_NECRO_CNN_MODEL_PATH} ${DATA_FILE} ${LYM_PREDICTION_BATCH_SIZE} ${DEVICE}
            fi
    done

    #if [ ${EXTRACTING} -eq 0 ] && [ ${PRE_FILE_NUM} -eq ${FILE_NUM} ]; then break; fi
    break
    PRE_FILE_NUM=${FILE_NUM}
done
set +x
exit 0
