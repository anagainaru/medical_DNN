rm submit_sst_temp.erf
NPROC=12
STID=$1
if [ -z "$1" ]
  then
    STID=0
fi
ENDID=$2
if [ -z "$2" ]
  then
    ENDID=12
fi

p=0
for n in $(seq $STID $((ENDID-1))); do
  echo "app $p: /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/quip_classification/u24_lymphocyte/scripts/preproc.sh $n $NPROC" >> submit_sst_temp.erf
  p=$(( $p + 1 ))
done


for n in $(seq $STID $((ENDID-1))); do
  echo "app $p: /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/quip_classification/u24_lymphocyte/scripts/prediction.sh $n $NPROC" >> submit_sst_temp.erf
  p=$(( $p + 1 ))
done

echo "overlapping_rs: warn
oversubscribe_cpu: warn
oversubscribe_mem: allow
oversubscribe_gpu: allow
launch_distribution: packed
" >> submit_sst_temp.erf

p=0
for n in $(seq $STID $((ENDID-1))); do
  cpu=$(( $(( $n - $STID )) * 4 ))
  echo "rank: $p: { host: 1; cpu: {$cpu-$(( $cpu + 3 ))} } : app $p" >> submit_sst_temp.erf
  p=$(( $p + 1 ))
done

for n in $(seq $STID $((ENDID-1))); do
  cpu=$(( $(( $n - $STID )) * 4 ))
  echo "rank: $p: { host: 2; cpu: {$cpu-$(( $cpu + 3 ))} } : app $p" >> submit_sst_temp.erf
  p=$(( $p + 1 ))
done

echo "
#!/bin/bash -l
#BSUB -P CSC143
#BSUB -W 0:30
#BSUB -nnodes 2
#BSUB -q debug
#BSUB -J sst_test_job
#BSUB -o sst%J.out
#BSUB -e sst%J.out

export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/ADIOS2-Python-fast/build/thirdparty/EVPath/EVPath/lib64:$LD_LIBRARY_PATH

jsrun --erf_input submit_sst_temp.erf
" > submit_temp.sh

bsub submit_temp.sh
