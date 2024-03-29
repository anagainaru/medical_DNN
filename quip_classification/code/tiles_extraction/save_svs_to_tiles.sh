#!/bin/bash
ROOT_PATH=/gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/quip_classification/u24_lymphocyte
source ${ROOT_PATH}/conf/variables.sh

set -x
COD_PARA=$1
MAX_PARA=$2
IN_FOLDER=${SVS_INPUT_PATH}
OUT_FOLDER=${PATCH_PATH}
echo $COD_PARA
echo $MAX_PARA
echo " In folder $IN_FOLDER"
echo " Out folder $OUT_FOLDER"


LINE_N=0
for files in ${IN_FOLDER}/*.*; do
    LINE_N=$((LINE_N+1))
    if [ $((LINE_N % MAX_PARA)) -ne ${COD_PARA} ]; then continue; fi

    SVS=`echo ${files} | awk -F'/' '{print $NF}'`
    echo "[debug] Looking at file $SVS"
    python ${ROOT_PATH}/patch_extraction/save_svs_to_tiles.py $SVS $IN_FOLDER $OUT_FOLDER
    if [ $? -ne 0 ]; then
        echo "failed extracting patches for " ${SVS}
        rm -rf ${OUT_FOLDER}/${SVS}
    fi
done
set +x
exit 0;


