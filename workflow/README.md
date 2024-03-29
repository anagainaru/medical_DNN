# Workflow for ML applications

<img width="946" alt="medical-framework" src="https://user-images.githubusercontent.com/16229479/135008557-643efb65-febb-454f-83af-ab973740266c.png">

Framework will work with **data objects, model objects** and allow **query capabilities**.

**Data objects** hold the images and input data required by the ML applications.

**Model objects** are data objects for which the framework attaches extra information related to the model: model parameters, provenence information (states that the model went through) and input requirements (informing the framework of the pre-processing requirements of a ML application).

ADIOS configuration file:
```xml
<?xml version="1.0"?>
<adios-config>
    <io name="test">
      <engine type="sst">
	<parameter key="RendezvousReaderCount" value="2"/>
        </engine>
    </io>
</adios-config>
```

Workflow framework configuration file:
```xml
<?xml version="1.0" encoding="utf-8"?>
<application name="QUIP-preproc">
    <output>
        <name> WSIpatch </name>
        <path> /quip/patches </path>
        <iolib name="ADIOS">
            <config> adios.xml </config>
        </iolib>
    </output>
</application>

<application name="QUIP-classification">
    <input> 
        <name> WSIpatch </name>
        <iolib name="ADIOS">
            <config> adios.xml </config>
        </iolib>
    </input>
    <preprocess>
        <code path="/quip/create-batch.sh">
            <param> 100 </param>
        </code>
    </preprocess>
</application>
</xml>
```

**Queries**

 There are two classes of queries that are most relevant to the patterns of AI frameworks, namely: 
 - Queries for models fitting certain criteria
 - Queries for domain decomposition information linked to a model.

The figure above shows the design of the ML workflow framework when used by two deep learning model applications and an ensemble learning process for both types of queries. By separating the I/O plane from the machine learning tasks, the deep learning models can set up the model object with information about how the pre-processing needs to be done (for example, in the Figure, TIL model 1 requires segmenting the input images into 80x80 pixel tiles). 

This information allows the framework prepare the input data in the format required by each application (and decrease the amount of redundant computation if possible). In addition, the queries for domain decomposition leverage the relation between the input data and the domain decomposition within a model to automatically detect which parts of the data are relevant to a given classification task. 

Using our framework, the ensemble learning process can revert to previous states of a model or could decide to change the shape and/or growing the model to decrease the bias error. It can also allow to migrate and re-distribute the machine learning process in an automatic way on the workers similarly to the pattern used by distributed training/inference of CNN or forest tree models. Being able to navigate through state of a model and searching for relevant moments combined with actions on how to handle the data in each case allows to implement flexible strategies for hyper-parameter search and and to explore efficiently multiple evolutions of a model.
