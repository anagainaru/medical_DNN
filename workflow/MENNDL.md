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
