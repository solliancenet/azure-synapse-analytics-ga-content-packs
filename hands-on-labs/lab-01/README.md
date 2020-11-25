# Lab 01 - The Integrated Machine Learning Process in Synapse Analytics

This lab demonstrates the integrated, end-to-end Azure Machine Learning and Azure Cognitive Services experience in Azure Synapse Analytics. You will learn how to connect an Azure Synapse Analytics workspace to an Azure Machine Learning workspace using a Linked Service and then trigger an Automated ML experiment that uses data from a Spark table. You will also learn how to use trained models from Azure Machine Learning or Azure Cognitive Services to enrich data in a SQL pool table and then serve prediction results using Power BI.

After completing the lab, you will understand the main steps of an end-to-end Machine Learning process that build on top of the integration between Azure Synapse Analytics and Azure Machine Learning.

This lab has the following structure:

- [Before the hands-on lab](#before-the-hands-on-lab)
  - [Task 1 - Create and configure the Azure Synapse Analytics workspace](#task-1---create-and-configure-the-azure-synapse-analytics-workspace)
  - [Task 2 - Create and configure additional resources for this lab](#task-2---create-and-configure-additional-resources-for-this-lab)
- [Exercise 1 - Create an Azure Machine Learning linked service](#exercise-1---create-an-azure-machine-learning-linked-service)
  - [Task 1 - Create and configure an Azure Machine Learning linked service in Synapse Studio](#task-1---create-and-configure-an-azure-machine-learning-linked-service-in-synapse-studio)
  - [Task 2 - Explore Azure Machine Learning integration features in Synapse Studio](#task-2---explore-azure-machine-learning-integration-features-in-synapse-studio)
- [Exercise 2 - Trigger an Auto ML experiment using data from a Spark table](#exercise-2---trigger-an-auto-ml-experiment-using-data-from-a-spark-table)
  - [Task 1 - Trigger a regression Auto ML experiment on a Spark table](#task-1---trigger-a-regression-auto-ml-experiment-on-a-spark-table)
  - [Task 2 - View experiment details in Azure Machine Learning workspace](#task-2---view-experiment-details-in-azure-machine-learning-workspace)
- [Exercise 3 - Enrich data in a SQL pool table using a trained model](#exercise-3---enrich-data-in-a-sql-pool-table-using-a-trained-model)
  - [Task 1 - Enrich data in a SQL pool table using a trained model from Azure Machine Learning](#task-1---enrich-data-in-a-sql-pool-table-using-a-trained-model-from-azure-machine-learning)
  - [Task 2 - Enrich data in a SQL pool table using a trained model from Azure Cognitive Services](#task-2---enrich-data-in-a-sql-pool-table-using-a-trained-model-from-azure-cognitive-services)
  - [Task 3 - Integrate a Machine Learning-based enrichment procedure in a Synapse pipeline](#task-3---integrate-a-machine-learning-based-enrichment-procedure-in-a-synapse-pipeline)
- [Exercise 4 - Serve prediction results using Power BI](#exercise-4---serve-prediction-results-using-power-bi)
  - [Task 1 - Create a view on top of a prediction query](#task-1---create-a-view-on-top-of-a-prediction-query)
  - [Task 2 - Display prediction results in a Power BI report](#task-2---display-prediction-results-in-a-power-bi-report)
  - [Task 3 - Trigger the pipeline using an event-based trigger](#task-3---trigger-the-pipeline-using-an-event-based-trigger)
- [After the hands-on lab](#after-the-hands-on-lab)
- [Resources](#resources)

## Before the hands-on lab

Before stepping through the exercises in this lab, make sure you have properly configured your Azure Synapse Analytics workspace. Perform the tasks below to configure the workspace.

### Task 1 - Create and configure the Azure Synapse Analytics workspace

>**NOTE**
>
>If you have already created and configured the Synapse Analytics workspace while running one of the other labs available in this repo, you must not perform this task again and you can move on to the next task. The labs are designed to share the Synapse Analytics workspace, so you only need to create it once.

Follow the instructions in [Deploy your Azure Synapse Analytics workspace](./../setup/asa-workspace-deploy.md) to create and configure the workspace.

### Task 2 - Create and configure additional resources for this lab

Follow the instructions in [Deploy resources for Lab 01](./../setup/lab-01-deploy.md) to deploy additional resources for this lab. Once deployment is complete, you are ready to proceed with the exercises in this lab.

## Exercise 1 - Create an Azure Machine Learning linked service

In this exercise, you will create and configure an Azure Machine Learning linked service in Synapse Studio. Once the linked service is available, you will explore the Azure Machine Learning integration features in Synapse Studio.

### Task 1 - Create and configure an Azure Machine Learning linked service in Synapse Studio

The Synapse Analytics linked service authenticates with Azure Machine Learning using a service principal. The service principal is based on an Azure Active Directory application named `Azure Synapse Analytics GA Labs` and has already been created for you by the deployment procedure. The secret associated with the service principal has also been created and saved in the Azure Key Vault instance, under the `ASA-GA-LABS` name.

>**NOTE**
>
>In the labs provided by this repo, the Azure AD application is used in a single Azure AD tenant which means it has exactly one service principal associated to it. Consequently, we will use the terms Azure AD application and service principal interchangeably. For a detailed explanation on Azure AD applications and security principals, see [Application and service principal objects in Azure Active Directory](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals).

To view the service principal, open the Azure portal and navigate to your instance of Azure Active directory. Select the `App registrations` section and you should see the `Azure Synapse Analytics GA Labs` application under the `Owned applications` tab.

![Azure Active Directory application and service principal](./../media/lab-01-ex-01-task-01-service-principal.png)

Select the application to view its properties and copy the value of the `Application (client) ID` property (you will need it in a moment to configure the linked service).

![Azure Active Directory application client ID](./../media/lab-01-ex-01-task-01-service-principal-clientid.png)

To view the secret, open the Azure Portal and navigate to the Azure Key Vault instance that has been created in your resource group. Select the `Secrets` section and you should see the `ASA-GA-LABS` secret:

![Azure Key Vault secret for security principal](./../media/lab-01-ex-01-task-01-keyvault-secret.png)

First, you need to make sure the service principal has permissions to work with the Azure Machine Learning workspace. Open the Azure Portal and navigate to the Azure Machine Learning workspace that has been created in your resource group. Select the `Access control (IAM)` section on the left, then select `+ Add` and `Add role assignment`. In the `Add role assignment` dialog, select the `Contributor` role, select `Azure Synapse Analytics GA Labs` service principal, and the select `Save`.

![Azure Machine Learning workspace permissions for security principal](./../media/lab-01-ex-01-task-01-mlworkspace-permissions.png)

You are now ready to create the Azure Machine Learning linked service.

To create a new linked service, open Synapse Studio, select the `Manage` hub, select `Linked services`, and the select `+ New`. In the search field from the `New linked service` dialog, enter `Azure Machine Learning`. Select the `Azure Machine Learning` option and then select `Continue`.

![Create new linked service in Synapse Studio](./../media/lab-01-ex-01-task-01-new-linked-service.png)

In the `New linked service (Azure Machine Learning)` dialog, provide the following properties:

- Name: enter `asagamachinelearning01`.
- Azure subscription: make sure the Azure subscription containing your resource group is selected.
- Azure Machine Learning workspace name: make sure your Azure Machine Learning workspace is selected.
- Notice how `Tenant identifier` has been already filled in for you.
- Service principal ID: enter the application client ID that you copied earlier.
- Select the `Azure Key Vault` option.
- AKV linked service: make sure your Azure Key Vault service is selected.
- Secret name: enter `ASA-GA-LABS`.

![Configure linked service in Synapse Studio](./../media/lab-01-ex-01-task-01-configure-linked-service.png)

Next, select `Test connection` to make sure all settings are correct, and then select `Create`. The Azure Machine Learning linked service will now be created in the Synapse Analytics workspace.

>**IMPORTANT**
>
>The linked service is not complete until you publish it to the workspace. Notice the indicator near your Azure Machine Learning linked service. To publish it, select `Publish all` and then `Publish`.

![Publish Azure Machine Learning linked service in Synapse Studio](./../media/lab-01-ex-01-task-01-publish-linked-service.png)

### Task 2 - Explore Azure Machine Learning integration features in Synapse Studio

First, we need to create a Spark table as a starting point for the Machine Learning model trainig process. In Synapse Studio, select the `Data` hub and then the `Linked` section. In the primary `Azure Data Lake Storage Gen 2` account, select the `wwi-02` file system, and then select the `sale-small-20191201-snappy.parquet` file under `wwi-02\sale-small\Year=2019\Quarter=Q4\Month=12\Day=20191201`. Right click the file and select `New notebook -> New Spark table`.

![Create new Spark table from Parquet file in primary data lake](./../media/lab-01-ex-01-task-02-create-spark-table.png)

Replace the content of the notebook cell with the following code:

```python
import pyspark.sql.functions as f

df = spark.read.load('abfss://wwi-02@asagadatalake01.dfs.core.windows.net/sale-small/Year=2019/Quarter=Q4/Month=12/*/*/*.parquet',
    format='parquet')
df_consolidated = df.groupBy('ProductId', 'TransactionDate', 'Hour').agg(f.sum('Quantity').alias('TotalQuantity'))
df_consolidated.write.mode("overwrite").saveAsTable("default.SaleConsolidated")
```

The code takes all data available for December 2019 and aggregates it at the `ProductId`, `TransactionDate`, and `Hour` level, calculating the total product quantities sold as `TotalQuantity`. The result is then saved as a Spark table named `SaleConsolidated`. To view the table in the `Data`hub, expand the `default (Spark)` database in the `Workspace` section. Your table will show up in the `Tables` folder. Select the three dots at the right of the table name to view the `Machine Learning` option in the context menu.

![Machine Learning option in the context menu of a Spark table](./../media/lab-01-ex-01-task-02-ml-menu.png)

The following options are available in the `Machine Learning` section:

- Enrich with new model: allows you to start an AutoML experiment to train a new model.
- Enrich with existing model: allows you to use an existing Azure Cognitive Services model.

## Exercise 2 - Trigger an Auto ML experiment using data from a Spark table

In this exercise, you will trigger the execution of an Auto ML experiment and view its progress in Azure Machine learning studio.

### Task 1 - Trigger a regression Auto ML experiment on a Spark table

To trigger the execution of a new AutoML experiment, select the `Data` hub and then select the `...` area on the right of the `saleconsolidated` Spark table to activate the context menu.

![Context menu on the SaleConsolidated Spark table](./../media/lab-01-ex-02-task-01-ml-menu.png)

From the context menu, select `Enrich with new model`.

![Machine Learning option in the context menu of a Spark table](./../media/lab-01-ex-01-task-02-ml-menu.png)

The `Enrich with new model` dialog allow you to set the properties for the Azure Machine Learning experiment. Provide values as follows:

- **Azure Machine Learning workspace**: leave unchanged, should be automaticall populated with your Azure Machine Learning workspace name.
- **Experiment name**: leave unchanged, a name will be automatically suggested.
- **Best model name**: leave unchanged, a name will be automatically suggested. Save this name as you will need it later to identify the model in the Azure Machine Learning Studio.
- **Target column**: Select `TotalQuantity(long)` - this is the feature you are looking to predict.
- **Spark pool**: leave unchanged, should be automaticall populated with your Spark pool name.

![Trigger new AutoML experiment from Spark table](./../media/lab-01-ex-02-task-01-trigger-experiment.png)

Notice the Apache Spark configuration details:

- The number of executors that will be used
- The size of the executor

Select `Continue` to advance with the configuration of your Auto ML experiment.

Next, you will choose the model type. In this case, the choice will be `Regression` as we try to predict a continuous numerical value. After selecting the model type, select `Continue` to advance.

![Select model type for Auto ML experiment](./../media/lab-01-ex-02-task-01-model-type.png)

On the `Configure regression model` dialog, provide values as follows:

- **Primary metric**: leave unchanged, `Spearman correlation` should be suggested by default.
- **Training job time (hours)**: set to 0.25 to force the process to finish after 15 minutes.
- **Max concurrent iterations**: leave unchanged.
- **ONNX model compatibility**: set to `Enable` - this is very important as currently only ONNX models are supported in the Synapse Studio integrated experience.

Once you have set all the values, select `Create run` to advance.

![Configure regression model](./../media/lab-01-ex-02-task-01-regressio-model-configuration.png)

As your run is being submitted, a notification will pop up instructing you to wait until the Auto ML run is submited. You can check the status of the notification by selecting the `Notifications` icon on the top right part of your screen.

![Submit AutoML run notification](./../media/lab-01-ex-02-task-01-submit-notification.png)

Once your run is successfully submitted, you will get another notification that will inform you about the actual start of the Auto ML experiment run.

![Started AutoML run notification](./../media/lab-01-ex-02-task-01-started-notification.png)

>**NOTE**
>
>Alongside the `Create run` option you might have noticed the `Open in notebook option`. Selecting that option allows you to review the actual Python code that is used to submit the Auto ML run. As an exercise, try re-doing all the steps in this task, but instead of selecting `Create run`, select `Open in notebook`. You should see a notebook similar to this:
>
>![Open AutoML code in notebook](./../media/lab-01-ex-02-task-01-open-in-notebook.png)
>
>Take a moment to read through the code that is generated for you.

### Task 2 - View experiment details in Azure Machine Learning workspace

To view the experiment run you just started, open the Azure Portal, select your resource group, and then select the Azure Machine Learning workspace from the resource group.

![Open Azure Machine Learning workspace](./../media/lab-01-ex-02-task-02-open-aml-workspace.png)

Locate and select the `Launch studio` button to start the Azure Machine Learning Studio.

In Azure Machine Leanring Studio, select the `Automated ML` section on the left and identify the experiment run you have just started. Note the experiment name, the `Running status`, and the `local` compute target.

![AutoML experiment run in Azure Machine Learning Studio](./../media/lab-01-ex-02-task-02-experiment-run.png)

The reason why you see `local` as the compute target is because you are running the AutoML experiment on the Spark pool inside Synapse Analytics. From the point of view of Azure Machine Learning, you are not running your experiment on Azure Machine Learning's compute resources, but on your "local" compute resources.

Select your run, and then select the `Models` tab to view the current list of models being built by your run. The models are listed in descending order of the metric value (which is `Spearman correlation` in this case), the best ones being listed first.

![Models built by AutoML run](./../media/lab-01-ex-02-task-02-run-details.png)

Select the best model (the one at the top of the list) and then select the `Explanations (preview)` tab to see the model explanation. You are now able to see the global importance of the input features. For your model, the feature that influences the most the value of the predicted value is   `ProductId`.

![Explainability of the best AutoML model](./../media/lab-01-ex-02-task-02-best-mode-explained.png)

Next, select the `Models` section on the left in Azure Machine Learning Studio and see your best model registered with Azure Machine Learning. This allows you to refer to this model later on in this lab.

![AutoML best model registered in Azure Machine Learning](./../media/lab-01-ex-02-task-02-model-registry.png)

## Exercise 3 - Enrich data in a SQL pool table using a trained model

In this exercise, you will use the model you trained in Exercise 2 to perform predictions on new data.

### Task 1 - Enrich data in a SQL pool table using a trained model from Azure Machine Learning

In Synapse Studio, select the `Data` hub, then select the `Workspace` tab, and then locate the `wwi.ProductQuantityForecast` table in the `SQLPool01 (SQL)` database (under `Databases`). Activate the context menu by selecting `...` from the righ side of the table name, and then select `New SQL script > Select TOP 100 rows`. The table contains the following columns:

-**ProductId**: the identifier of the product for which we want to predict
-**TransactionDate**: the future date for which we want to predict
-**Hour**: the hour from the future date for which we want to predict
-**TotalQuantity**: the value we want to predict for the specified product, day, and hour.

![ProductQuantitForecast table in the SQL pool](./../media/lab-01-ex-03-task-01-explore-table.png)

Notice that `TotalQuantity` is zero in all rows as this is the placeholder for the predicted values we are looking to get.

To use the model you just trained in Azure Machine Learning, activate the context menu of the `wwi.ProductQuantityForecast`, and then select `Machine Learning > Enrich with existing model`. This will open the `Enrich with existing model` dialog where you can select your model. Select the most recent model and then select `Continue`.

![Select trained Machine Learning model](./../media/lab-01-ex-03-task-01-select-model.png)

Next, you will manage the input and output column mappings. Because the column names from the target table and the table used for model training match, you can leave all mappings as suggested by default. Select `Continue` to advance.

![Column mapping in model selection](./../media/lab-01-ex-03-task-01-map-columns.png)

The final step presents you with options to name the stored procedure that will perform the predictions and the table that will store the serialized form of your model. Provide the following values:

- **Stored procedure name**: `[wwi].[ForecastProductQuantity]`
- **Select target table**: `Create new`
- **New table**: `[wwi].[Model]

Select `Deploy model + open script` to deploy your model into the SQL pool.

![Configure model deployment](./../media/lab-01-ex-03-task-01-deploy-model.png)

A new SQL script is created for you:

![SQL script for stored procedure](./../media/lab-01-ex-03-task-01-forecast-stored-procedure.png)

### Task 2 - Enrich data in a SQL pool table using a trained model from Azure Cognitive Services

Task description

### Task 3 - Integrate a Machine Learning-based enrichment procedure in a Synapse pipeline

Task description

## Exercise 4 - Serve prediction results using Power BI

Exercise description

### Task 1 - Create a view on top of a prediction query

Task description

### Task 2 - Display prediction results in a Power BI report

Task description

### Task 3 - Trigger the pipeline using an event-based trigger

New data has landed in the Data Lake

## After the hands-on lab

Follow the instructions in [Clean-up your subscription](./../setup/cleanup.md) to clean-up your environment after the hands-on lab.

## Resources

To learn more about the topics covered in this lab, use these resources:

- [Quickstart: Create a new Azure Machine Learning linked service in Synapse](https://docs.microsoft.com/en-us/azure/synapse-analytics/machine-learning/quickstart-integrate-azure-machine-learning)
- [Tutorial: Machine learning model scoring wizard for dedicated SQL pools](https://docs.microsoft.com/en-us/azure/synapse-analytics/machine-learning/tutorial-sql-pool-model-scoring-wizard)