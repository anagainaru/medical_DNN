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
