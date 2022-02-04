## Running Quip with MENNDL models

Pre-requisites, pytorch and other python packages need to be installed to be able to load the MENNDL model.

```bash
pip install torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html
pip install ./MENNDL/pymenndl-minimal # install code necessary to run menndl created networks
pip install ./MENNDL/plasmatorch # install the code we use to utilize LMDB. NOTE TO ANA: we were storing the data in LMDB, not using JPEG files.
```

For Summit, the conda environment `open-ce-1.4.0-py37-0`

```bash
module load open-ce/1.4.0-py37-0
conda activate open-ce-1.4.0-py37-0
pip install ./pymenndl-minimal -t /ccs/home/againaru/medical/quip_MENNDL/modules-install
cp -r  plasmatorch/plasmatorch module-install
pip install lmdb -t /ccs/home/againaru/medical/quip_MENNDL/modules-install

export PYTHONPATH=$PYTHONPATH:/ccs/home/againaru/medical/quip_MENNDL/modules-install

// torchaudio is not installed
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

