# Running QUIP on Summit

### 1. Prepare the data

The WSI raw files are stored in `/gpfs/alpine/csc303/world-shared/tkurc1/wsi-all`. The Quip application needs the input data stored in the `data` folder.

```
rm -r /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/svs
mkdir ls /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/svs
for i in /gpfs/alpine/csc303/world-shared/tkurc1/wsi-all/*/*.svs; do ln -s $i /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/svs/$(basename $i) ; done

ls -l /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/svs | wc -l
28379
```

### 2. Pre-processing



### 3. Prediction
