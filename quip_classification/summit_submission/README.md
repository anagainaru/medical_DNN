# Running QUIP on Summit

## Prepare the data

Before QUIP can be ran, data needs to be copied in the path known by the application (in the `OUTPUT` external variable used by the application in the `conf/variables.sh` file). The application expects the files directly stored in the data folder (and not organized in other folders inside data).

The WSI raw files are stored in `/gpfs/alpine/csc303/world-shared/tkurc1/wsi-all` in multiple folders. The Quip application will work with sym links to these files, stored in the `data` folder.

```
rm -r /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/svs
mkdir ls /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/svs
for i in /gpfs/alpine/csc303/world-shared/tkurc1/wsi-all/*/*.svs; do ln -s $i /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/svs/$(basename $i) ; done

ls -l /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/svs | wc -l
28379
```

## Execute the application

<img width="780" alt="Screen Shot 2021-12-20 at 10 37 45 AM" src="https://user-images.githubusercontent.com/16229479/146793195-d7c6fe88-ec46-41f0-aef7-9fc393254cd4.png">

Two steps: pre-processing and prediction in two separate applications. The pre-processing application reads a WSI, pre-process it and divides it into tiles then saves each tile to a separate file (illustrated in the figure). The prediction application reads tiles until it create batches based on agiven criteria, moves data to the gpu and does prediction. In the end it outputs results to the stdout. The input WSI file size and the tile size are between a few KB to a few GB.

### 1. Pre-processing

The pre-processing application can be ran usuing the dl_preproc.sh script. It doesn't use GPU so it can be run on any node. 



### 2. Prediction

The prediction application can be ran using the dl_benchmark.sh script. It can only run on GPU nodes, compute nodes on Summit have 2 22-core Power9 CPUs and 6 V100 GPUs.  Each V100 contains 80 streaming multiprocessors (SMs), 16 GB (32 GB on high-memory nodes) of high-bandwidth memory (HBM2), and a 6 MB L2 cache that is available to the SMs.
