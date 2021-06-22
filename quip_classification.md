Instructions from Dmitry

```
To run the benchmark, please copy the folder /gpfs/alpine/world-shared/csc303/Ganyushin/quip_app into your location, make recursive grep -r ganyushin * and adjust all pathes for your_root_directory.
 
Make symbolic links in your_root_directory /quip_app/data/
cd your_root_directory/quip_app/data
ln -s svs_12 svs
ln -s patches_12 patches
 
run bsub dl_preproc.sh  - that makes bp files in the patches directory
run bsub dl_benchmark.sh – that reads bp files and makes predictions
```
