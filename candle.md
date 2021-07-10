# ECP CANDLE 


## General instructions

In order to use the tensorflow spack package on Summit:
```
module load open-ce
```

Using a custom installation of tensorflow:
```
BUILDS=/gpfs/alpine/world-shared/stf008/bing/stemdl_benchmark/1.14.0
source $BUILDS/env.sh
```

Using Darshan DXT
```
module load darshan-runtime/3.2.1
#export DXT_ENABLE_IO_TRACE=1
export DARSHAN_DISABLE_SHARED_REDUCTION=1
export DXT_ENABLE_IO_TRACE=4
```

For applications needing tensorflow version 1
```
module load ibm-wml-ce/1.6.2-1
```

### Manual installation of TensorFlow

**1. Installing Anaconda**

```
curl -o Anaconda3-2020.02-Linux-x86_32.sh https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-ppc64le.sh
chmod u+x ./Anaconda3-2020.02-Linux-x86_32.sh
./Anaconda3-2020.02-Linux-x86_32.sh

export PATH=$HOME/anaconda3/bin:$PATH
```

**2. Install TenserFlow**

```
conda install tensorflow
```

