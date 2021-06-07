# Paper outline

### Optimization opportunities for AI frameworks

![model](https://user-images.githubusercontent.com/16229479/121099193-614f3e00-c7c5-11eb-9cd5-0d43bc6bbc36.png)

Figure 1. Training and inference for machine learning models 

**List of findings**

- Current training methods maintain a large population of promising mod- els that are evolved or combined to improve the accuracy of the machine learning process.
- Medical applications rely on workflows of tightly coupled applications operating on the same datasets each implementing their own model, re- quiring synchronization within an application between multiple models and between applications.
- Each application is creating a large set of models and artifacts. There is currently no robust way of keeping track of similar models and artifacts at runtime to allow collaborative work on models.
- Large amounts of data need to be processed by multiple models repeat- edly and transferred between different tasks or applications to evaluate if more efficient models provide better accuracy performance. There is currently no automatic way of moving data to and where is needed in an efficient way.
- Querying capabilities are needed to be able to prioritize and filter data based on the needs of coupled applications.

### Vision

![vision](https://user-images.githubusercontent.com/16229479/121099391-c014b780-c7c5-11eb-800c-fe4bdc95880e.png)
Figure 2. Model metadata information is being attached to every data object adding information specific to the models being saved

Main contributions:
- The model abstraction defines a data-centric concepts that provides AI frameworks with a formal way of describing the model specific character- istics in real time.
- The model abstraction provides flexibility in how the optimizations can be implemented by frameworks in many areas: data management, schedul- ing, compression, workflow management.
