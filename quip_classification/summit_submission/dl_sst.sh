#BSUB -P CSC143
#BSUB -W 0:50
#BSUB -nnodes 2
#BSUB -q debug
#BSUB -J sst_quip_job
#BSUB -o sst%J.out
#BSUB -e sst%J.err

cd ./u24_lymphocyte/scripts/

NPROC=6

for n in $(seq 0 $((NPROC-1))); do
   echo "Preproc $n"
   jsrun -n1 -a1 -c1  ./preproc.sh $n $NPROC &
done
for n in $(seq 0 $((NPROC-1))); do
   echo "Prediction $n"
   jsrun -n1 -a1 -c7 -g1  --bind=proportional-packed:7 --launch_distribution=packed bash  ./prediction.sh $n $NPROC &  
done
wait

