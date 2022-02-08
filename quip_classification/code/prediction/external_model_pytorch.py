import numpy as np
import sys
import torch
from pymenndl.constructor import ConvClassifier
import torchvision.transforms as transforms
from plasmatorch.LMDB import LMDBDataset

def load_external_model(model_path):
    # Load your model here
    file_prefix = model_path
    network_wrapper = ConvClassifier(file_prefix=file_prefix)
    network_wrapper.try_restart()
    net = network_wrapper.net
    return net

def pred_by_external_model(model, inputs):
    # model:
    #     A model loaded by load_external_model
    # inputs :
    #     float32 numpy array with shape N x 3 x 100 x 100
    #     Range of value: 0.0 ~ 255.0
    # Expected output:
    #     float32 numpy array with shape N x 1
    #     Each entry is a probability ranges 0.0 ~ 1.0
    #     Output is transformed to correspond to the output of the TenserFlow model
    #       - the MENNDL model returns both negative and positive classes ([:,0:1] chooses the positive ones)
    tfinput = torch.from_numpy(inputs)
    pred = model(tfinput)
    return pred.detach().numpy()[:,1:2];

def restart_external_model(model):
    # pytorch does not need restarting (no memory exhaust problem)
    return

if __name__ == "__main__":
    config_filepath = "/ccs/home/againaru/medical/quip_MENNDL/code/a79773ce-5aed-11e9-9b65-70e2841459e0";

    print(config_filepath)
    model = load_external_model(config_filepath);
    print('load_external_model called')
    inputs = np.random.rand(10, 3, 100, 100);
    print('inputs created')
    pred = pred_by_external_model(model, inputs)
    print('after predict')
    print(pred);
