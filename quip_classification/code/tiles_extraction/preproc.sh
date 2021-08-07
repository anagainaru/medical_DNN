#!/bin/bash

module load  ibm-wml-ce/1.6.2-1
# conda activate ibm-wml-ce-1.6.2-1
conda activate cloned-ibm-env
module load hdf5
#ADIOS2
export PYTHONPATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/ADIOS2-Python-fast/build/lib/python3.6/site-packages:$PYTHONPATH
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/ADIOS2-Python-fast/build/lib64:$LD_LIBRARY_PATH
#Openslide-python
export PYTHONPATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/openslide-python-1.1.2/build/lib.linux-ppc64le-3.6:$PYTHONPATH
#openslide - so
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/openslide-rpm/usr/lib64/:$LD_LIBRARY_PATH
#openjpeg
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/libopenjpeg1-rpm/usr/lib64:$LD_LIBRARY_PATH


ROOT_PATH=/gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/quip_classification/u24_lymphocyte
THREAD=$1
NTHREADS=$2

source $ROOT_PATH/conf/variables.sh
bash $ROOT_PATH/patch_extraction/start.sh ${THREAD} ${NTHREADS}
exit 0
