# Task schedulers

Main repo: [https://github.com/therault/AI-scheduling-spgemm](https://github.com/therault/AI-scheduling-spgemm)

**Using ML to replace scheduling policies**

<img width="830" alt="Screen Shot 2021-09-10 at 10 53 20 AM" src="https://user-images.githubusercontent.com/16229479/132873446-4c6c169c-fa79-4f87-bc5b-63ba34b0a9b3.png">


The ML model decides which tasks to schedule for execution on the GPU (T4 or T5) or not to schedule anything and wait for the tasks that will be created once the current ones finish their execution (T6 and T7). If T6 and T7 share memory with T1, T2 or T3 it might be benefitial to wait not to pay the cost of bringing data from the CPU to the GPU when they will be executed.

The scheduler will train a NN model through reinforcement learning, by using math models to compute the cost for the decision it took and compare it to the cost of the correct decision it would have made if it knew what tasks were about to be generated.

The output of the learning process is a model that fits a given DAG based on the data within the DAG.

**Workflow**

<img width="916" alt="Screen Shot 2021-09-10 at 10 57 25 AM" src="https://user-images.githubusercontent.com/16229479/132874053-2dff4055-9974-413b-9de7-c61993769ade.png">

[Design still under progress] 
Multiple DAGS will create multiple models (if DAGS are the same, the model can be updated with multiple data). 

The models will be merged and the accuracy will be computed for each DAG (accuracy in this case represents the cost of the final schedule, i.e. the end-to-end execution time). There will need to be a trade-off between accuracy of the model and the generality for multiple DAGS. Multiple models might have to be saved.

If multiple models exist, a new DAG will have to choose between the models in some way and use reinformcement learning to update it.

**Issues**

Models will have to be combined, split or updated by new DAGS (with the posibility to roll back if the generality increases over a threshold)
