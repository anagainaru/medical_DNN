## Running Quip with MENNDL models

Code is in Dropbox `MENNDL-ADIOS` folder.

```
pip install torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html
pip install ./pymenndl-minimal # install code necessary to run menndl created networks
pip install ./plasmatorch # install the code we use to utilize LMDB. NOTE TO ANA: we were storing the data in LMDB, not using JPEG files.
cd code
python minimal-run-menndl-v2.py # make sure caching of data is warm so that we get a fair comparison with following runs 
python minimal-run-inceptionv4.py  
python minimal-run-menndl-v1.py  
python minimal-run-menndl-v2.py
python minimal-run-menndl-noWTN.py
```

**NOTE TO ANA:** v2 and noWTN should be the fastest networks

** NOTE TO ANA:** It looks like we are using 100x100 patches in this file. 
               I believe these are center crops of whatever size patches were provided,
               but the person that handled data wrangling and interfacing with Stonybrook
               on this project is no longer at ORNL.
