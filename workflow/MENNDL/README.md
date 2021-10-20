# MENNDL

**Code** in [https://github.com/pytorch/examples/blob/master/imagenet/main.py](https://github.com/pytorch/examples/blob/master/imagenet/main.py)

```
git clone https://github.com/pytorch/examples.git
```

**Input** 

Files are in the `dtn.ccs.ornl.gov:/gpfs/alpine/world-shared/csc396/forAna/` folder.

That folder contains `imagenet.tar.xz` and `imagenet_small.tar.xz`. 
The small version is just 10 examples per class in the train and val datasets and is probably enough for this.

<sup> <sup> [*] dtn.ccs.ornl.gov is the data transfer node(s) for OLCF. You should use them when moving large amounts of data to/from OLCF (and not using Globus... which I also highly recommend if you haven't used it). You just use your OLCF user/passcode like you would on Summit. 
</sup> </sup>

**Running**

To train the model on a single GPU:
```
python main.py -a resnet18 imagenet_small
```

I would think what you would want to do, is use a custom dataset instead of ImageFolder here: 

- [https://github.com/pytorch/examples/blob/master/imagenet/main.py#L207](https://github.com/pytorch/examples/blob/master/imagenet/main.py#L207)
- [https://github.com/pytorch/examples/blob/master/imagenet/main.py#L226](https://github.com/pytorch/examples/blob/master/imagenet/main.py#L226)

To implement a custom dataset, you simply have to implement the Dataset class (https://pytorch.org/tutorials/beginner/data_loading_tutorial.html#dataset-class). 

This bascially amounts to implementing a `__getitem__` function and a `__len__` function. 

Sidenotes: maybe we would want to use IterableDataset instead? 
https://pytorch.org/docs/stable/data.html#torch.utils.data.IterableDataset.

We may also want to think about customizing the DataLoader, but that would probably be a heavier lift.
https://pytorch.org/docs/stable/data.html#torch.utils.data.DataLoader



```
module load python
[againaru@andes-login4 imagenet]$ pip install -r requirements.txt --target /ccs/home/againaru/medical/tenserflow_example/python_install
export PYTHONPATH=$PYTHONPATH:/ccs/home/againaru/medical/tenserflow_example/python_install
[againaru@andes-login4 imagenet]$ python main.py -a resnet18 /gpfs/alpine/csc143/proj-shared/againaru/imagenet/imagenet_small
=> creating model 'resnet18'
using CPU, this will be slow
Epoch: [0][ 0/40]	Time 13.696 (13.696)	Data  1.789 ( 1.789)	Loss 7.0595e+00 (7.0595e+00)	Acc@1   0.00 (  0.00)	Acc@5   0.39 (  0.39)
Epoch: [0][10/40]	Time  9.565 ( 9.752)	Data  0.017 ( 0.183)	Loss 7.2454e+00 (7.0950e+00)	Acc@1   0.00 (  0.00)	Acc@5   0.78 (  0.53)
```


## Validation

Initial (using one worker to load the data)

```
> python main.py -j 1 -a resnet18 -e /gpfs/alpine/csc143/proj-shared/againaru/imagenet/imagenet_small
=> creating model 'resnet18'
Test: [ 0/40]   Time 10.331 (10.331)    Loss 7.4725e+00 (7.4725e+00)    Acc@1   0.00 (  0.00)   Acc@5   0.00 (  0.00)
Test: [10/40]   Time  2.156 ( 2.545)    Loss 7.2221e+00 (7.2787e+00)    Acc@1   0.00 (  0.28)   Acc@5   0.78 (  1.14)
Test: [20/40]   Time  2.195 ( 2.378)    Loss 7.5344e+00 (7.3444e+00)    Acc@1   0.00 (  0.17)   Acc@5   0.00 (  0.91)
Test: [30/40]   Time  2.138 ( 2.297)    Loss 7.3168e+00 (7.3933e+00)    Acc@1   0.00 (  0.11)   Acc@5   0.00 (  0.62)
 * Acc@1 0.090 Acc@5 0.530
```

ADIOS files (one step for each image in validation)

```
> python prepare_data.py -e /gpfs/alpine/csc143/proj-shared/againaru/imagenet/imagenet_small
Writing validation data in test.bp
Write Time 54.259 (54.259)
> python train_predict.py -e -a resnet18
=> creating model 'resnet18'
Test: [ 0/40]   Time  9.905 ( 9.905)    Loss 7.4117e+00 (7.4117e+00)    Acc@1   0.00 (  0.00)   Acc@5   0.00 (  0.00)
Test: [10/40]   Time  1.456 ( 2.260)    Loss 7.1881e+00 (7.3349e+00)    Acc@1   0.00 (  0.00)   Acc@5   0.00 (  1.03)
Test: [20/40]   Time  1.573 ( 1.891)    Loss 7.4218e+00 (7.3677e+00)    Acc@1   0.00 (  0.00)   Acc@5   3.52 (  0.71)
Test: [30/40]   Time  1.446 ( 1.762)    Loss 7.4588e+00 (7.3638e+00)    Acc@1   0.00 (  0.13)   Acc@5   0.00 (  0.60)
 * Acc@1 0.100 Acc@5 0.480
```

ADIOS files (one variable for each image)

```
> python prepare_data.py -e /gpfs/alpine/csc143/proj-shared/againaru/imagenet/imagenet_small
Writing validation data in test.bp
Write Time 53.516 (53.516)
> python train_predict.py -e -a resnet18
=> creating model 'resnet18'
Test: [0/1] Time  9.209 ( 9.209)    Loss 7.3967e+00 (7.3967e+00)    Acc@1   0.00 (  0.00)   Acc@5   0.00 (  0.00)
Test: [10/1]    Time  1.481 ( 2.190)    Loss 7.5279e+00 (7.6426e+00)    Acc@1   0.00 (  0.00)   Acc@5   0.00 (  0.18)
Test: [20/1]    Time  1.603 ( 1.874)    Loss 7.7143e+00 (7.7116e+00)    Acc@1   0.00 (  0.00)   Acc@5   0.00 (  0.09)
Test: [30/1]    Time  1.471 ( 1.756)    Loss 7.3559e+00 (7.7362e+00)    Acc@1   0.00 (  0.10)   Acc@5   0.00 (  0.44)
 * Acc@1 0.080 Acc@5 0.510
```

### Memory

```
> du -H /gpfs/alpine/csc143/proj-shared/againaru/imagenet/imagenet_small 
2.5GB /gpfs/alpine/csc143/proj-shared/againaru/imagenet/imagenet_small 
> du imagenet.bp
5.7GB imagenet.bp
```
