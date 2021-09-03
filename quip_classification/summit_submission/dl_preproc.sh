#BSUB -P CSC143
#BSUB -W 0:30
#BSUB -nnodes 1
#BSUB -q debug
#BSUB -J mldl_test_job
#BSUB -o mldl%J.out
#BSUB -e mldl%J.err

NODES=$(cat ${LSB_DJOB_HOSTFILE} | sort | uniq | grep -v login | grep -v batch | wc -l)

cd ./u24_lymphocyte/scripts/

NPROC=6

for n in $(seq 0 $((NPROC-1))); do
   echo "Preproc $n"
   jsrun -n1 -a1 -c1  ./preproc.sh $n $NPROC &
done
wait

