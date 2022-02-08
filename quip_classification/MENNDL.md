## Running Quip with MENNDL models

Pre-requisites, pytorch and other python packages need to be installed to be able to load the MENNDL model.

```bash
pip install torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html
pip install ./MENNDL/pymenndl-minimal # install code necessary to run menndl created networks
pip install ./MENNDL/plasmatorch # install the code we use to utilize LMDB. NOTE TO ANA: we were storing the data in LMDB, not using JPEG files.
```

For Summit, the conda environment `open-ce-1.4.0-py37-0` is used. We need to install code necessary to run menndl created networks and plasmatorch for reading the input data.

```bash
module load open-ce/1.4.0-py37-0
conda activate open-ce-1.4.0-py37-0
pip install ./pymenndl-minimal -t /ccs/home/againaru/medical/quip_MENNDL/modules-install
cp -r  plasmatorch/plasmatorch module-install
pip install lmdb -t /ccs/home/againaru/medical/quip_MENNDL/modules-install

export PYTHONPATH=$PYTHONPATH:/ccs/home/againaru/medical/quip_MENNDL/modules-install

python
>>> torch.__version__
'1.9.0'
>>> torchvision.__version__
'0.10.0'
>>> lmdb.__version__
'1.3.0'
>>> h5py.__version__
'3.2.1'
```

Testing the MENNDL model on Summit (code stored in `/gpfs/alpine/csc143/proj-shared/againaru/medical/quip_menndl` and in `~/medical/quip_MENNDL`)

```bash
(open-ce-1.4.0-py37-0) [againaru@login1.summit code]$ python minimal-run-menndl-v2.py
Found file: a79773ce-5aed-11e9-9b65-70e2841459e0.params - restarting from previous state
Succesfully loaded network!
/sw/summit/open-ce/anaconda-base/envs/open-ce-1.4.0-py37-0/lib/python3.7/site-packages/torch/nn/functional.py:718: UserWarning: Named tensors and all their associated APIs are an experimental feature and subject to change. Please do not use them for anything important until they are released as stable. (Triggered internally at  /gpfs/alpine/stf007/world-shared/davismj/open-ce-builds/rhel8-oce-1.4.0/python-env/conda-bld/pytorch-base_1633116212289/work/c10/core/TensorImpl.h:1156.)
  return torch.max_pool2d(input, kernel_size, stride, padding, dilation, ceil_mode)
Avg Time: 0.0206032815829728
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


Loading the pytorch MENNDL model

```python
from pymenndl.constructor import ConvClassifier

file_prefix = model_path
network_wrapper = ConvClassifier(file_prefix=file_prefix)
network_wrapper.try_restart()
net = network_wrapper.net
net.cuda().half()
net.eval()
```

Read the dataset and prediction

```python
import torch
import torchvision.transforms as transforms
from plasmatorch.LMDB import LMDBDataset

transform = transforms.Compose([transforms.CenterCrop(100), transforms.ToTensor()])
valset = LMDBDataset('val_ub_lmdb', transform=transform)
valloader   = torch.utils.data.DataLoader( valset, batch_size=128, shuffle=False, num_workers=16 )

with torch.no_grad():
    for inputs, labels in valloader:
        inputs, labels = inputs.cuda().half(), labels.cuda()
        outputs = net(inputs)
```

### Running Quip with the MENNDL model on Summit

```bash
module load ibm-wml-ce/1.6.2-1
conda activate ibm-wml-ce-1.6.2-1

export PYTHONPATH=$PYTHONPATH:/ccs/home/againaru/medical/quip_MENNDL/modules-install
export PYTHONPATH=/gpfs/alpine/world-shared/csc143/ganyushin/ADIOS2-Python-fast/build/lib/python3.6/site-packages:$PYTHONPATH
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/ADIOS2-Python-fast/build/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/openslide/:$LD_LIBRARY_PATH

module load hdf5

$ python -u /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_pytorch/quip_classification/u24_lymphocyte/prediction/lymphocyte/pred_by_external_model.py /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/svs/TCGA-22-4599-11A-01-TS1.6361e51a-0f6d-4ef3-9d93-0e7b16834ead.svs /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_pytorch/quip_classification/u24_lymphocyte/prediction/Pytorch_MENNDL_model/a79773ce-5aed-11e9-9b65-70e2841459e0 patch-level-lym.txt 96 0

DONE in 391.00140878604725 sec /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/patches/TCGA-22-4599-11A-01-TS1.6361e51a-0f6d-4ef3-9d93-0e7b16834ead.svs 
// with the initial code
```

Equivalent execution time using TenserFlow is similar
```
module load  ibm-wml-ce/1.6.2-1
conda activate ibm-wml-ce-1.6.2-1
module load hdf5
export PYTHONPATH=/gpfs/alpine/world-shared/csc143/ganyushin/ADIOS2-Python-fast/build/lib/python3.6/site-packages:$PYTHONPATH
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/quip_app/ADIOS2-Python-fast/build/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/gpfs/alpine/world-shared/csc143/ganyushin/openslide/:$LD_LIBRARY_PATH

python -u /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_init/quip_classification/u24_lymphocyte/prediction/lymphocyte/pred_by_external_model.py /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/svs/TCGA-22-4599-11A-01-TS1.6361e51a-0f6d-4ef3-9d93-0e7b16834ead.svs /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_init/quip_classification/u24_lymphocyte/prediction/NNFramework_TF_models/config_vgg-mix_test_ext.ini patch-level-lym.txt 96 0

DONE in 365.4974382640794 sec /gpfs/alpine/csc143/proj-shared/againaru/medical/quip_adios/data/patches/TCGA-22-4599-11A-01-TS1.6361e51a-0f6d-4ef3-9d93-0e7b16834ead.svs
```
