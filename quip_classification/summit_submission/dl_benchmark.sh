#BSUB -P CSC143
#BSUB -W 0:30
#BSUB -nnodes 1
#BSUB -q debug
#BSUB -J mldl_pred_job
#BSUB -o pred%J.out
#BSUB -e pred%J.err

cd ./u24_lymphocyte/scripts/

NPROC=6

for n in $(seq 0 $((NPROC-1))); do
   jsrun -n1 -a1 -c7 -g1  --bind=proportional-packed:7 --launch_distribution=packed bash  ./prediction.sh $n $NPROC &  
done
wait   

