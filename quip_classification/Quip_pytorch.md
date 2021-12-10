## Running Quip with MENNDL models

Pre-requisites, pytorch and other python packages need to be installed to be able to load the MENNDL model.

```bash
pip install torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html
pip install ./MENNDL/pymenndl-minimal # install code necessary to run menndl created networks
pip install ./MENNDL/plasmatorch # install the code we use to utilize LMDB. NOTE TO ANA: we were storing the data in LMDB, not using JPEG files.
```

### Changes to the TenserFlow code

The code for prediction is in `u24_lymphocyte/prediction/lymphocyte` folder. 
The code in the `pred_by_external_model.py` file is independent on the type of model being used and offloads the model specific implementation to the `external_model` functions.

```python
from external_model import load_external_model, pred_by_external_model

def split_validation(classn, input_type):
    print("Load external model")
    model = load_external_model(CNNModel)

def val_fn_epoch_on_disk(classn, model, fh):
    output = pred_by_external_model(model, inputs)
```

The TenserFlow implementation is located in `external_model_TF.py`. For pytorch we simply create a new file that overwrites the two functions. The functions are implemented in `external_model_pytorch.py`.

### PyTorch implementation

### Running Quip with the MENNDL model on Summit

```
python minimal-run-menndl-v2.py # make sure caching of data is warm so that we get a fair comparison with following runs
python minimal-run-inceptionv4.py
python minimal-run-menndl-v1.py
python minimal-run-menndl-v2.py
python minimal-run-menndl-noWTN.py


# NOTE TO ANA: v2 and noWTN should be the fastest networks
# NOTE TO ANA: It looks like we are using 100x100 patches in this file.
               I believe these are center crops of whatever size patches were provided,
               but the person that handled data wrangling and interfacing with Stonybrook
               on this project is no longer at ORNL
```
