#BSUB -P {project}
#BSUB -W 00:50
#BSUB -nnodes 1
#BSUB -q debug
#BSUB -J imagenet_adios
#BSUB -o imagenet%J.out
#BSUB -e imagenet%J.out

module load  ibm-wml-ce/1.6.2-1
conda activate ibm-wml-ce-1.6.2-1

export PYTHONPATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/ADIOS2-Python-fast/build/lib/python3.6/site-packages:$PYTHONPATH
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/ADIOS2-Python-fast/build/lib64:$LD_LIBRARY_PATH

# INITIAL code
# submit 6 training processes on the same node (one per GPU)
for gpu in {0..6}; do
  # Using 4 threads for reading
  jsrun -n1 -a1 -c4 -g1 python main.py -j 4 -a resnet18 -e /gpfs/alpine/csc143/proj-shared/againaru/imagenet/imagenet_small &
done
wait

# ADIOS code
jsrun -n1 python prepare_data.py -j 4 -e /gpfs/alpine/csc143/proj-shared/againaru/imagenet/imagenet_small &
for gpu in {0..6}; do
  # Using 4 threads for reading
  jsrun -n1 -a1 -c4 -g1 python train_predict.py -j 4 -e -a resnet18 &
done
wait
