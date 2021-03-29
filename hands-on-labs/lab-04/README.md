# Lab 04 - Working with the Common Data Model in Synapse Analytics

This lab demonstrates using Synapse Analytics Spark to work with the Common Data Model.

After completing the lab, you will know how to interact with the Common Data Model in Synapse Analytics.

- [Lab 04 - Working with the Common Data Model in Synapse Analytics](#lab-04---working-with-the-common-data-model-in-synapse-analytics)
  - [Before the hands-on lab](#before-the-hands-on-lab)
    - [Task 1 - Create and configure the Azure Synapse Analytics workspace](#task-1---create-and-configure-the-azure-synapse-analytics-workspace)
    - [Task 2 - Create and configure additional resources for this lab](#task-2---create-and-configure-additional-resources-for-this-lab)
  - [Exercise 1 - Read data that exists in the CDM](#exercise-1---read-data-that-exists-in-the-cdm)
    - [Task 1 - Explore CDM data in the Synapse workspace data lake](#task-1---explore-cdm-data-in-the-synapse-workspace-data-lake)
    - [Task 2 - Load Spark dataframes from entities in CDM folders](#task-2---load-spark-dataframes-from-entities-in-cdm-folders)
  - [Exercise 2 - Update data that exists in the CDM](#exercise-2---update-data-that-exists-in-the-cdm)
    - [Task 1 - Update CDM data using dataframe schemas](#task-1---update-cdm-data-using-dataframe-schemas)
    - [Task 2 - Update CDM data using CDM entity definitions](#task-2---update-cdm-data-using-cdm-entity-definitions)
    - [Task 3 - Use Spark to transform incoming raw data to CDM data](#task-3---use-spark-to-transform-incoming-raw-data-to-cdm-data)
      - [Task 3 A - creating CDM with implicit manifest](#task-3-a---creating-cdm-with-implicit-manifest)
      - [Task 3 B - creating CDM with explicit manifest](#task-3-b---creating-cdm-with-explicit-manifest)
  - [Exercise 3 - Create an end-to-end CDM-based data pipeline](#exercise-3---create-an-end-to-end-cdm-based-data-pipeline)
    - [Task 1 - Automate raw data ingestion and coversion to CDM using Synapse Pipelines](#task-1---automate-raw-data-ingestion-and-coversion-to-cdm-using-synapse-pipelines)
  - [After the hands-on lab](#after-the-hands-on-lab)
  - [Resources](#resources)
  - [Report issues](#report-issues)

## Before the hands-on lab

Before stepping through the exercises in this lab, make sure you have properly configured your Azure Synapse Analytics workspace. Perform the tasks below to configure the workspace.

### Task 1 - Create and configure the Azure Synapse Analytics workspace

>**NOTE**
>
>If you have already created and configured the Synapse Analytics workspace while running one of the other labs available in this repo, you must not perform this task again and you can move on to the next task. The labs are designed to share the Synapse Analytics workspace, so you only need to create it once.

Follow the instructions in [Deploy your Azure Synapse Analytics workspace](./../setup/asa-workspace-deploy.md) to create and configure the workspace.

### Task 2 - Create and configure additional resources for this lab

Details coming soon ...

## Exercise 1 - Read data that exists in the CDM

### Task 1 - Explore CDM data in the Synapse workspace data lake

Our CDM data is already stored on Azure Data Lake Gen 2. 

We have to open the corresponding container/folder:

![Open the DataLake folder with CDM data](./../media/lab-04/lab04-ex1-task1-read-cdm-01.png)

To view the actual data, we can use a SQL query. Right click on the corresponding data folder and choose `New SQL Script` then choose `Select TOP 100 rows`

![Note the presence of the CDM manifest](./../media/lab-04/lab04-ex1-task1-read-cdm-02.png)

You may right click and choose `Preview` to visualize contents for the `default.manifest.cdm.json` file.

This file points to our entity which is part of our subfolder `SaleSmall`, see below.

![Note the presence of the CDM entity](./../media/lab-04/lab04-ex1-task1-read-cdm-03.png)

You may right click and choose `Preview` to visualize contents for the `SaleSmall.cdm.json` file.

![Check the manifest of our CDM entity](./../media/lab-04/lab04-ex1-task1-read-cdm-04.png)

The data itself is stored in a subfolder: `2020-12-12`, see below.

![Use SQL query to select CDM data](./../media/lab-04/lab04-ex1-task1-read-cdm-05.png)

Click the `Run` button in the toolbar to execute the SQL query. Once executed, results are visible in the lower pane.

![View the available CDM data](./../media/lab-04/lab04-ex1-task1-read-cdm-06.png)

Alternately we can load the CDM data in a Spark dataframe

![Use spark to select CDM data](./../media/lab-04/lab04-ex1-task1-read-cdm-07.png)

Choose a Spark pool first, then click the `Run` button in the toolbar to run the notebook. Once executed, results are visible in the lower pane.

![View the available CDM data](./../media/lab-04/lab04-ex1-task1-read-cdm-08.png)

### Task 2 - Load Spark dataframes from entities in CDM folders

We will load the existing CDM data into Spark dataframes. Open a notebook and use the following python code to load the CDM data:

```python
from pyspark.sql.types import *
from pyspark.sql import functions, Row
from decimal import Decimal
from datetime import datetime


storageAccountName = "asadatalake01.dfs.core.windows.net"
container = "wwi-02"
outputContainer = "wwi-02"

abfssRoot = "abfss://" + outputContainer + "@" + storageAccountName

folder1 = "/cdm-data/input"

#read CDM entities
df = (spark.read.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder1 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .load())

df.printSchema()

df.select("*").show()
```

The loaded CDM data is now displayed as spark dataframes in the lower pane. 

The dataframe schema matches the structure of our CDM entity.

![Load the available CDM data via Spark](./../media/lab-04/lab04-ex1-task2-spark-read-cdm-01.png)

Note how our manifest file `default.manifest.cdm.json` points to our model

```json
...
  "entities" : [
    {
      "type" : "LocalEntity",
      "entityName" : "SaleSmall",
      "entityPath" : "SaleSmall/SaleSmall.cdm.json/SaleSmall",
    }
  ]
...
```

which in turn contains our entity's definition `SaleSmall`.

Some contents of `SaleSmall.cdm.json` is skipped for brevity:

```json
{
  "definitions" : [
    {
      "entityName" : "SaleSmall",
      "attributeContext" : {
        "type" : "entity",
        "name" : "SaleSmall",
        "definition" : "resolvedFrom/SaleSmall",
        "contents" : [
          ...
        ]
      },
      "hasAttributes" : [
        {
          "name" : "TransactionId",
          "dataFormat" : "String"
        },
        {
          "name" : "CustomerId",
          "dataFormat" : "Int32"
        },
        {
          "name" : "ProductId",
          "dataFormat" : "Int16"
        },
        {
          "name" : "Quantity",
          "dataFormat" : "Byte"
        },
        {
          "name" : "Price",
          "dataFormat" : "Decimal"
        },
        {
          "name" : "TotalAmount",
          "dataFormat" : "Decimal"
        },
        {
          "name" : "TransactionDate",
          "dataFormat" : "Int32"
        },
        {
          "name" : "ProfitAmount",
          "dataFormat" : "Decimal"
        },
        {
          "name" : "Hour",
          "dataFormat" : "Byte"
        },
        {
          "name" : "Minute",
          "dataFormat" : "Byte"
        },
        {
          "name" : "StoreId",
          "dataFormat" : "Int16"
        }
      ]
    }
  ]
}
```

## Exercise 2 - Update data that exists in the CDM

### Task 1 - Update CDM data using dataframe schemas

We will update existing CDM data by modifying the Spark dataframe schema. 

```python
from pyspark.sql.types import *
from pyspark.sql import functions as f, Row

from decimal import Decimal
from datetime import datetime


storageAccountName = "asadatalake01.dfs.core.windows.net"
container = "wwi-02"
outputContainer = "wwi-02"

abfssRoot = "abfss://" + outputContainer + "@" + storageAccountName

folder1 = "/cdm-data/input"
folder2 = "/cdm-data/update-implicit"

#read CDM
df = (spark.read.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder1 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .load())

df.printSchema()
df.select("*").show()

#update dataframe/schema
df2 = df.withColumn("x4", f.lit(0))
df2.printSchema()
df2.select("*").show()

#write CDM; entity manifest is implicitly created based on df schema
(df2.write.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder2 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .option("format", "parquet")
  .option("compression", "gzip")
  .save())

readDf2 = (spark.read.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder2 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .load())

readDf2.select("*").show()
```

This is now the new schema as shown by the spark dataframe:

![New df schema](./../media/lab-04/lab04-ex2-task1-update-cdm-01.png)

Note that the CDM manifest was updated:

![New CDM manifest](./../media/lab-04/lab04-ex2-task1-update-cdm-02.png)

### Task 2 - Update CDM data using CDM entity definitions

We will update existing CDM data by using a modified CDM manifest. 

```python
from pyspark.sql.types import *
from pyspark.sql import functions as f, Row

from decimal import Decimal
from datetime import datetime


storageAccountName = "asadatalake01.dfs.core.windows.net"
container = "wwi-02"
outputContainer = "wwi-02"

abfssRoot = "abfss://" + outputContainer + "@" + storageAccountName

folder1 = "/cdm-data/input"
folder2 = "/cdm-data/update-explicit"

#read CDM
df = (spark.read.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder1 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .load())

df.printSchema()
df.select("*").show()

#update dataframe/schema
df2 = df.withColumn("x5", f.lit(0))
df2.printSchema()
df2.select("*").show()

#write CDM; entity manifest is explicitly passed as SaleSmall-Modified.cdm.json
(df2.write.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder2 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .option("entityDefinitionModelRoot", container + folder1)                                      #root folder for our own CDM models
  .option("entityDefinitionPath", "/salesmall/SaleSmall/SaleSmall-Modified.cdm.json/SaleSmall")  #relative path for our own CDM model
  .option("format", "parquet")
  .option("compression", "gzip")
  .save())

readDf2 = (spark.read.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder2 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .load())

readDf2.select("*").show()
```

This is now the new schema as shown by the spark dataframe:

![New df schema](./../media/lab-04/lab04-ex2-task2-update-cdm-01.png)

Note that the CDM manifest contains a member that matches our new column.

![New CDM manifest](./../media/lab-04/lab04-ex2-task2-update-cdm-02.png)



### Task 3 - Use Spark to transform incoming raw data to CDM data

#### Task 3 A - creating CDM with implicit manifest

We will write new CDM data based on existing Spark dataframes. 

We will infer the CDM manifest based on the dataframe's schema.

Open a notebook and use the following python code to save the CDM data:

```python
storageAccountName = "asadatalake01.dfs.core.windows.net"
container = "wwi-02"
outputContainer = "wwi-02"

abfssRoot = "abfss://" + outputContainer + "@" + storageAccountName

# WARNING: if output folder exists, writer will fail with a java.lang.NullPointerException
folder1 = "/cdm-data/output-implicit"

from pyspark.sql.types import *
from pyspark.sql import functions, Row
from decimal import Decimal
from datetime import datetime

df = spark.read.parquet(abfssRoot + "/sale-small/Year=2019/Quarter=Q4/Month=12/*/*.parquet")
df.show(10)
df.printSchema()

#save dataframe using CDM format; entity manifest is implicitly created based on df schema
(df.write.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder1 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .option("format", "parquet")
  .option("compression", "gzip")
  .save())

readDf = (spark.read.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder1 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .load())

readDf.select("*").show()
```
![Save new CDM data, use df schema](./../media/lab-04/lab04-ex2-task3-spark-write-cdm-01.png)


#### Task 3 B - creating CDM with explicit manifest

Writing new CDM data based on existing CDM models is just as easy. 

The CDM manifest is explicit here, user specified.

Open a notebook and use the following python code to save the CDM data:

```python
storageAccountName = "asadatalake01.dfs.core.windows.net"
container = "wwi-02"
outputContainer = "wwi-02"

abfssRoot = "abfss://" + outputContainer + "@" + storageAccountName

# WARNING: if output folder exists, writer will fail with a java.lang.NullPointerException
folderInput = "/cdm-data/input"
folder2 = "/cdm-data/output-explicit"

from pyspark.sql.types import *
from pyspark.sql import functions, Row
from decimal import Decimal
from datetime import datetime

df2 = spark.read.parquet(abfssRoot + "/sale-small/Year=2019/Quarter=Q4/Month=12/*/*.parquet")
df2.show(10)
df2.printSchema()

#save dataframe using CDM format; entity manifest is explicitly passed as SaleSmall/SaleSmall.cdm.json
(df2.write.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder2 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .option("entityDefinitionModelRoot", container + folderInput)                         #root folder for our own CDM models
  .option("entityDefinitionPath", "/salesmall/SaleSmall/SaleSmall.cdm.json/SaleSmall")  #relative path for our own CDM model
  .mode("overwrite")
  .save())

readDf2 = (spark.read.format("com.microsoft.cdm")
  .option("storage", storageAccountName)
  .option("manifestPath", container + folder2 + "/salesmall/default.manifest.cdm.json")
  .option("entity", "SaleSmall")
  .option("entityDefinitionModelRoot", container + folderInput)
  .load())

readDf2.select("*").show()
```

![Save new CDM data, use CDM model](./../media/lab-04/lab04-ex2-task3-spark-write-cdm-02.png)

## Exercise 3 - Create an end-to-end CDM-based data pipeline

### Task 1 - Automate raw data ingestion and coversion to CDM using Synapse Pipelines

![Create a new pipeline](./../media/lab-04/lab04-ex3-task1-pipeline-cdm-01.png)

Go to the `Integrate` hub, press the `+` button then choose `Pipeline` to create a new pipeline.

![Configure the pipeline](./../media/lab-04/lab04-ex3-task1-pipeline-cdm-02.png)

Name your pipeline, then pick an activity from the `Activities` list: drag a `Notebook` element found under the `Synapse` group.

![Configure the activity](./../media/lab-04/lab04-ex3-task1-pipeline-cdm-03.png)

In the lower pane, choose the `Settings` tab and select the notebook you want to be used by our pipeline.

In our example we chose the notebook that converts raw data to cdm format.

![Automate the pipeline](./../media/lab-04/lab04-ex3-task1-pipeline-cdm-04.png)

Press `Add trigger` to use a condition that will automatically launch your new pipeline.

![Creating the trigger](./../media/lab-04/lab04-ex3-task1-pipeline-cdm-05.png)

Press `New` to create a new trigger.

![Configure the trigger](./../media/lab-04/lab04-ex3-task1-pipeline-cdm-06.png)

* Name your trigger, and choose its type as `Event`. 
* Choose the Azure subscription, Storage account name, Container name.
* Setup a path prefix that will be used to detect changes in our datalake in a specific location.
* Check the `Blob created` Event to make sure that pipeline is launched when new blob appears in your blob path.

Save your trigger, then click on the `Validate` button and then press `Publish` to save your new pipeline.

We chose to use a trigger that detects changes in our datalake. 
Which means that everytime we get new data in our datalake, our pipeline will run.
In our case, the notebook will be executed, and will convert the raw data to the CDM format.

## After the hands-on lab

Follow the instructions in [Clean-up your subscription](./../setup/cleanup.md) to clean-up your environment after the hands-on lab.

## Resources

To learn more about the topics covered in this lab, use these resources:

- [Azure.Analytics.Synapse.Artifacts Namespace Classes](https://docs.microsoft.com/en-us/dotnet/api/azure.analytics.synapse.artifacts?view=azure-dotnet-preview)
- [Using the Spark CDM Connector](https://github.com/Azure/spark-cdm-connector/blob/master/documentation/overview.md)
- [Common Data Model (CDM) Schema](https://github.com/microsoft/CDM)

## Report issues

In case you encounter any issues with the content in this repository, please follow the [How to report issues](./../../report-issues.md) guideline. We will try to address them as soon as possible. Please check your open issues to learn about their status.
