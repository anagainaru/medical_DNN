# Paper outline

### Introduction

1. **Big data revolution**

[1] [https://journalofbigdata.springeropen.com/articles/10.1186/s40537-020-00361-2](https://journalofbigdata.springeropen.com/articles/10.1186/s40537-020-00361-2)

The big data revolution disrupted the digital and computing landscape in the early 2010s. Data torrents produced by corporations such as Google, Amazon, Facebook and YouTube, among others, presented a unique opportunity for innovation. Traditional signal processing tools and computing methodologies were inadequate to turn these big-data challenges into technological breakthroughs. The quest for novel pattern recognition algorithms that sift through large, high-quality data sets eventually led to a disruptive combination of deep learning and graphics processing units (GPUs) that enabled a rapid succession of advances in computer vision, speech recognition, natural language processing, and robotics, to mention a few.

2. **Convergency of AI and HPC**

The convergence of AI and HPC is being pursued in earnest across the HPC ecosystem. Recent accomplishments of this program have been reported in plasma physics [20], cosmology [21], gravitational wave astrophysics [22], high energy physics [23], multi-messenger astrophysics [24], materials science [25], data management of unstructured datasets [26, 27], and genetic data [28], among others.

These achievements share a common thread, namely, the algorithms developed to accelerate the training of AI models in HPC platforms have a strong experimental component. To date, there is no rigorous framework to constrain the ideal set of hyper-parameters that ensures rapid convergence and optimal performance of AI models as the number of GPU nodes is increased to accelerate the training stage. 

[Figure with speed-up on multiple GPUs]
[About figure: Additionally, we also scaled the data-parallel distributed training strategy up to 6144 NVIDIA V100 GPUs at 80% efficiency on the Summit supercomputer at Oak Ridge National Laboratory, as shown in right panel of Fig. 7. In data-parallel distribution scheme, the neural network model is replicated on each individual GPU and each replication is fed non-overlapping batches of training data in parallel. After each batch, the GPUs communicate to synchronize gradients and update model weights. Because this scheme involves a linear increase in global batch size with the number of GPUs, it has been observed that such scaling leads to a degradation in convergence and generalization of the model [65]. To address this issue, we employed the layer-wise adaptive large batch optimization technique (LAMB) [66], and successfully trained the model without degradation in convergence using 1536 NVIDIA V100 GPUs within 1.2 hours. We have made the trained model [67] and testing dataset publicly available at Data and Learning Hub for Science (DLHub) [68], [69] hosted at Argonne National Laboratory.]

These examples clearly underscore the importance of coupling AI with HPC: (i) it significantly speeds up the training stage, enabling the exploration of domain-inspired architectures and optimization schemes, which are critical for the design of rigorous, trustworthy and interpretable AI solutions; (ii) it enables the use of larger training data sets to boost the accuracy and reliability of AI models while keeping the training stage at a minimum.


3. **Challenges**
 
Types of training / interference and data patterns

![model](https://user-images.githubusercontent.com/16229479/120384942-cf42c380-c2f4-11eb-898b-bd0dd6c8a574.png)


4. **Opportunities**

The Frontier, Aurora and El Capitan exascale systems will combine simulation, data science, and machine learning to revolutionize how supercomputers are used for scientific discovery and innovation.
The development of a rigorous mathematical framework to make informed choices of domain inspired AI architectures and optimization schemes; (ii) the creation of an interdisciplinary effort that brings together domain, information science, AI, data and software experts to inform the collection and curation of experimental and simulation datasets; (iii) the identification of connections between AI data and models, which will facilitate the production of commodity software that may be seamlessly applicable to disparate fields that share common data and computing data challenges

While it is customary to quantify the performance of HPC platforms for distributed training at scale using idealized datasets and vanilla AI models, i.e., ResNet-50 trained with the ImageNet dataset, it is also important to assess the performance of advanced cyberinfrastructure facilities to train more complex, domain-inspired AI models with realistic, experimental datasets.

## Problem formulation

### AI application patterns

**Functionality**

Multiple steps within the training and the interference steps of an AI algorithm. Steps withing a DNN: for training **pre-processing, model discovery, model training** and for interference **high parameter optimizations, post-processing**. Each with different IO patterns and requirements.

Advanced data management approaches are needed to save / stream intermediate DNN models/layers as the training (or inference) progresses. In addition to the normal progress of the training, interference steps, the model or data might need to be saved to storage to preserve them for later study/revisiting, or they might need to be clone for the purpose of forking the training / inference into different parallel directions.

Type of parallelism used by training / interference methods: **data parallelism**, **model parallelism** and **pipeline parallelism**
(opportunities and challenges for each). In addition the pre-processing, post-processing steps might be expensive due to data manipulation.

*Data management systems need to automatically capture the evolution of the snapshots, expose their properties, enable search based on such properties, reshape the snapshots on-the-fly to adapt
to a new context where it needs to be used.*

*However, providing such advanced data management capabilities is challenging, because DNN training approaches are constantly being adapted to take
advantage of large-scale infrastructures. *

**IO patterns**

Compared to HPC applications, more focus on read and more need for streaming.

## Proposed scheme

**Streaming**

Bring data that is needed first at high resolution, the rest slower overlapping computation


## Applications

Paper [1]  The AI models we consider are tailored for image recognition, classification and regression analyses of telescope image datasets, and time-series data that describe the collision of black holes.


<img width="1348" alt="Screen Shot 2021-05-12 at 3 50 53 PM" src="https://user-images.githubusercontent.com/16229479/118035894-d8fe8a00-b339-11eb-8b4d-3e54727dbf9e.png">

**Fusion Science**

We have been researching DL models to analyze fusion science data for disruption predic-tion [16], for fusion particle distribution data regeneration [13], 
and for a conservative approximation to thecollision operator [63]. In previous work, we addressed challenges in training physics-constrained models 
by developing a stochastic augmented Lagrangian method [23] that yielded promising preliminary resultsfor a plasma physics simulation. 
Furthermore, anomaly detection [66] augments experiments or simulationswith valuable insights to track interesting developments, potentially leading 
to findings [15]. In the past,such a task relied on human experts that rapidly become bottlenecks in the workflow.

**Quantum Materials**

We have been researching ML models, including DL, to integrate surrogates intoneutron scattering pipelines [11, 26].
Previous work addressed extraction of model parameters as well as autonomous data treatment from diffuse and inelastic scattering using surrogates. 
This involved training nonlinear autoencoders on Monte Carlo and Landau-Lifshitz simulations [80, 73]. However, to address the challenges of high-dimensional
interaction spaces and the need for highly optimized ML to work effectively with expensive simulations, better approaches are needed. 
The Monte Carlo and Landau Lifshitz approachesdo not capture quantum effects adequately [80], and DCA and DMRG techniques are needed. 
These tech-niques need to be greatly accelerated by using models that can take the output of these HPC codes to createfast surrogate models 
to benefit neutron scattering experiments.

**Cancer Imaging**
Development of DL models to analyze tissue images and characterize the tumor micro environment is a highly active area in cancer imaging.
A variety of DL methods have been developed for detection and segmentation of cells and nuclei, segmentation and characterization of tumor and normal tissue
regions, and characterization of distributions of cells and nuclei [25,75,31,38,45,89,47,46,72,52,1]. These methods can take a long time to execute when
they are applied to entire whole slide images at the highest resolution, resulting in long-running imaging experiments. New approaches are needed to 
integrateless expensive ML methods as surrogates [84], adaptive processing approaches [17], and multiscale tech-niques [58] to speed up imaging experiments.

## Deep learning applications

[https://hal.archives-ouvertes.fr/hal-02941295/document](https://hal.archives-ouvertes.fr/hal-02941295/document)

In a quest to solve this challenge, systematic approaches are beginning to
emerge: guided model discovery where the DNN architecture [26] and hyperparameters [3] are automatically identified, sensitivity analysis [29], which is used
to identify what parts/layers of the DNN model and/or training samples are the
most influential the learning process and how robust the DNN model is regarding tolerance to outliers or transfer learning (i.e., ability to reuse the learned
patterns to solve related problems), etc.

However, with increasing complexity and sizes of DNN models and training data, a mix of data parallel, model parallel, pipeline parallel and layer-wise
parallel approaches are emerging to speed-up the training process. In this context, a training instance is not a single process anymore, but an entire group
of tightly coupled processes that are distributed across many devices and/or
compute nodes of large scale HPC infrastructures. Such groups of processes collaboratively work on a shared, distributed DNN model state, exhibiting specific
properties and access patterns. In addition, HPC data centers are increasingly
equipped with complex heterogeneous storage stacks (multi-level memory hierarchies on compute nodes, distributed caches and burst buffers, key-value stores,
parallel file systems, etc.). Under such circumstances, the fundamental data management abilities mentioned above become highly challenging to implement in a
scalable and efficient manner.

## HPC

With the advent of Big Data and machine learning, and the
race to Exascale (a supercomputer able to compute at a peak of 1018Flops) an explosion of application domains
turned to such resources. In addition, the structure of these machines is changing; the scientific workflows
are becoming more complex; their execution patterns are drastically evolving. These resources are extremely
expensive, both in terms of construction (the Frontier supercomputer, expected to be one of the first Exascale
machines, is estimated to half a billion euros^1
) and exploitation (Fugaku, the current fastest supercomputer,
consumes 28MW, which represents 24 million Euros per year; which should be added to several important
maintenance costs). Given such a high-cost and energy consumption, utilization of these systems has to be
as close to 100% as possible!

1. [https://www.pcmag.com/news/us-to-spend-600-million-on-frontier-exascale-supercomputer](https://www.pcmag.com/news/us-to-spend-600-million-on-frontier-exascale-supercomputer)


### Research
Both the data states and the transitions between them are recorded into
the lineage, which keeps the evolution of the data states. The lineage exposes
primitives to navigate (i.e., move to a successor or predecessor) and to search
(i.e., find data states that satisfy given properties) the lineage.

For example,
this can be used to follow the evolution of tagged DNN model states during
training or to search for previously tagged intermediate DNN models based on
their accuracy and/or other attributes. Furthermore, each data state can be
part of one or more scopes, which are explicitly specified in Ma. To avoid the
explosion of storage space utilization, non-critical data states that have gone out
of scope (e.g., non-critical or locally relevant intermediate DNN models) and
their transitions can be pruned from the lineage as needed. Pruning is subject
to garbage collection algorithms, but can also be triggered explicitly through a
dedicated primitive.

The lineage can be combined with two additional powerful primitives: fork
and reshape. Both of them are similar to tagging (i.e., they trigger a transition
to a new data state and the execution of an asynchronous action plan) but with
important differences. Fork creates a clone of the data state on an entirely different set of processes and “splits” the lineage into two independent directions that 
can evolve separately. For example, fork can be used to explore an alternative direction for training a DNN model (e.g., using different hyper-parameters and/or
training samples). Reshape enables the processes to change the layout and/or
distribution of C, by specifying appropriate attributes in Ma. Specifically, this
refers to operations such as migrate (to different processes) and shuffle (i.e., ex-
change pieces of C between processes, which is a common pattern in distributed
training of DNN models). 

Combined with tagging and search/navigation, these
two primitives allow flexible strategies to explore multiple parallel evolutions and
revisit/reuse previous data states. Note the versatility of reshape, which can be
extended with multiple other patterns. For example, data states could be used to
record a lineage for Tensorflow [1] by introducing support for tensor operations:
slice, rebalance, stack, etc

However, redundancy is detected onthe-fly, which can be an unnecessary overhead for clone and revisit (e.g., model
replicas are known to be identical for data-parallel training).
