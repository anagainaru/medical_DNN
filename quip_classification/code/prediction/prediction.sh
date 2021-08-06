#!/bin/bash
module load  ibm-wml-ce/1.6.2-1
conda activate ibm-wml-ce-1.6.2-1
module load hdf5
export PYTHONPATH=/gpfs/alpine/world-shared/csc143/ganyushin/ADIOS2-Python-fast/build/lib/python3.6/site-packages:$PYTHONPATH
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/ADIOS2-Python-fast/build/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/openslide/:$LD_LIBRARY_PATH

ROOT_PATH=/gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/quip_classification/u24_lymphocyte
THREAD=$1 
NTHREADS=$2

set -x 
source $ROOT_PATH/conf/variables.sh
bash $ROOT_PATH/prediction/start.sh ${THREAD}  ${NTHREADS}

set +x 
exit 0
