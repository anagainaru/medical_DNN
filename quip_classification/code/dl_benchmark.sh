#BSUB -P CSC143
#BSUB -W 0:30
#BSUB -nnodes 1
#BSUB -q debug
#BSUB -J mldl_pred_job
#BSUB -o pred%J.out
#BSUB -e pred%J.err

module load  ibm-wml-ce/1.6.2-1
conda activate ibm-wml-ce-1.6.2-1
module load hdf5
export PYTHONPATH=/gpfs/alpine/world-shared/csc143/ganyushin/ADIOS2-Python-fast/build/lib/python3.6/site-packages:$PYTHONPATH
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/ADIOS2-Python-fast/build/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/openslide/:$LD_LIBRARY_PATH

NODES=$(cat ${LSB_DJOB_HOSTFILE} | sort | uniq | grep -v login | grep -v batch | wc -l)

cd ./u24_lymphocyte/scripts/

NPROC=6

for n in $(seq 0 $((NPROC-1))); do
   jsrun -n1 -a1 -c7 -g1  --bind=proportional-packed:7 --launch_distribution=packed bash  ./prediction.sh $n $NPROC &  
done
wait   
