# Outline

# Problem formulation

## AI application patterns

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
