# The Integrated Machine Learning Process in Synapse Analytics

This lab demonstrates the integrated, end-to-end Azure Machine Learning and Azure Cognitive Services experience in Azure Synapse Analytics. You will learn how to connect an Azure Synapse Analytics workspace to an Azure Machine Learning workspace using a Linked Service and then trigger an Automated ML experiment that uses data from a Spark table. You will also learn how to use trained models from Azure Machine Learning or Azure Cognitive Services to enrich data in a SQL pool table and then serve prediction results using Power BI.

After completing the lab, you will understand the main steps of an end-to-end Machine Learning process that build on top of the integration between Azure Synapse Analytics and Azure Machine Learning.

This lab has the following structure:

- [Before the hands-on lab](#before-the-hands-on-lab)
- [Exercise 1 - Create an Azure Machine Learning linked service](#exercise-1---create-an-azure-machine-learning-linked-service)
  - [Task 1 - Create and configure an Azure Machine Learning linked service in Synapse Studio](#task-1---create-and-configure-an-azure-machine-learning-linked-service-in-synapse-studio)
  - [Task 2 - Explore Azure Machine Learning integration features in Synapse Studio](#task-2---explore-azure-machine-learning-integration-features-in-synapse-studio)
- [Exercise 2 - Trigger an Auto ML experiment using data from a Spark table](#exercise-2---trigger-an-auto-ml-experiment-using-data-from-a-spark-table)
  - [Task 1 - Create a Spark table on top of data from the Data Lake](#task-1---create-a-spark-table-on-top-of-data-from-the-data-lake)
  - [Task 2 - Trigger a regression Auto ML experiment on a Spark table](#task-2---trigger-a-regression-auto-ml-experiment-on-a-spark-table)
  - [Task 3 - View experiment details in Azure Machine Learning workspace](#task-3---view-experiment-details-in-azure-machine-learning-workspace)
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

Instructions to setup the lab environment.

## Exercise 1 - Create an Azure Machine Learning linked service

Exercise description

### Task 1 - Create and configure an Azure Machine Learning linked service in Synapse Studio

Task content

### Task 2 - Explore Azure Machine Learning integration features in Synapse Studio

Task content

## Exercise 2 - Trigger an Auto ML experiment using data from a Spark table

Exercise description

### Task 1 - Create a Spark table on top of data from the Data Lake

Task content

### Task 2 - Trigger a regression Auto ML experiment on a Spark table

Task content

### Task 3 - View experiment details in Azure Machine Learning workspace

Task content (includes viewing an already registered model in the workspace and its details)

## Exercise 3 - Enrich data in a SQL pool table using a trained model

Exercise description

### Task 1 - Enrich data in a SQL pool table using a trained model from Azure Machine Learning

Task description

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

Instructions to cleanup resources after the lab.

## Resources

To learn more about the topics covered in this lab, use these resources:

- [Quickstart: Create a new Azure Machine Learning linked service in Synapse](https://docs.microsoft.com/en-us/azure/synapse-analytics/machine-learning/quickstart-integrate-azure-machine-learning)
- [Tutorial: Machine learning model scoring wizard for dedicated SQL pools](https://docs.microsoft.com/en-us/azure/synapse-analytics/machine-learning/tutorial-sql-pool-model-scoring-wizard)