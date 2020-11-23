# Azure Synapse Analytics GA Content Packs

Readiness content packs for Azure Synapse Analytics features released at GA.

The following content packs will be released:
- Pre-GA content pack
- Post-GA content pack

The following table shows the mapping of categories and topics to content packs:

<table>
    <thead><tr>
        <th colspan=5 style="text-align: center">Category / Topic mapping to content packs<br/>&nbsp;</th>
    </tr></thead>
    <tbody>
        <tr>
            <td>Category</td>
            <td>Topic</td>
            <td>Pre-GA CP</td>
            <td>Post-GA CP</td>
            <td>Details</td>
        </tr>
        <tr>
            <td rowspan="2">Migration from ADF and SQL DW</td>
            <td>ADF import to Synapse Pipeline</td>
            <td>Markdown / Lab 03</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Synapse workspace addition on top of existing SQL DW</td>
            <td>Markdown / Video 01</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td rowspan="4">Git integration</td>
            <td>CI/CD and Git Integration</td>
            <td>Markdown / Video 02</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Artifact - Folders</td>
            <td>Markdown / Video 02</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Artifact - Rename</td>
            <td>Markdown / Video 02</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Workspace access control</td>
            <td>Markdown / Video 02</td>
            <td></td>
            <td>Admin, data engineer/scientist, data/business analyst</td>
        </tr>
        <tr>
            <td rowspan="4">Linked Services</td>
            <td>Integration - Babylon</td>
            <td></td>
            <td>Markdown / Video 06</td>
            <td></td>
        </tr>
        <tr>
            <td>Integration - AML</td>
            <td>Markdown / Lab 01</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Integration - Cognitive Services</td>
            <td>Markdown / Lab 01</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Integration - Azure Data Explorer</td>
            <td>Markdown / Lab 02</td>
            <td></td>
            <td>https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-connect-azure-data-explorer</td>
        </tr>
        <tr>
            <td rowspan="2">Synapse Link</td>
            <td>Synapse Link with MongoDB API</td>
            <td></td>
            <td>Markdown / Video 07</td>
            <td></td>
        </tr>
        <tr>
            <td>Synapse Link SQL serverless - CosmosDB</td>
            <td>Markdown / Video 03</td>
            <td></td>
            <td>https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link<br/>https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-cosmos-db-analytical-store</td>
        </tr>
        <tr>
            <td rowspan="7">Development</td>
            <td>Data Wrangling using Power Query</td>
            <td></td>
            <td>Markdown / Video 08</td>
            <td></td>
        </tr>
        <tr>
            <td>What does it mean to run Apache Spark in Synapse - benefits, unique capabilities</td>
            <td>Markdown / Lab 02</td>
            <td></td>
            <td>https://docs.microsoft.com/en-us/azure/synapse-analytics/metadata/overview</td>
        </tr>
        <tr>
            <td>MSSparkUtil library</td>
            <td>Markdown / Lab 02</td>
            <td></td>
            <td>https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/microsoft-spark-utilities?pivots=programming-language-python</td>
        </tr>
        <tr>
            <td>Hummingbird library</td>
            <td>Markdown / Video 04 ?</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Metastore - Spark and serverless SQL pool</td>
            <td>Markdown / Lab 02</td>
            <td></td>
            <td>https://docs.microsoft.com/en-us/azure/synapse-analytics/metadata/database <br/>
            https://docs.microsoft.com/en-us/azure/synapse-analytics/metadata/table</td>
        </tr>
        <tr>
            <td>Hyperspace</td>
            <td>Markdown / Lab 02</td>
            <td></td>
            <td>https://github.com/microsoft/hyperspace<br/>https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-performance-hyperspace?pivots=programming-language-csharp</td>
        </tr>
        <tr>
            <td>Spark CDM connector</td>
            <td></td>
            <td>TBD</td>
            <td>https://github.com/Azure/spark-cdm-connector</td>
        </tr>
        <tr>
            <td rowspan="4">Monitoring</td>
            <td>Monitoring - Az Monitor Integration</td>
            <td>Markdown / Video 05</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Monitoring - SQL Request Details</td>
            <td>Markdown / Video 05</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Monitoring - Spark pools</td>
            <td>Markdown / Video 05</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Monitoring  - dedicated SQL pool</td>
            <td>Markdown / Video 05</td>
            <td></td>
            <td></td>
        </tr>
    </tbody>
</table>

## Lab descriptions

Id | Name | Description | Useful links
---|---|---|---
Lab 01 | [The Integrated Machine Learning process in Synapse Analytics](./hands-on-labs/lab-01/README.md) |  This lab demonstrates the integrated, end-to-end Azure Machine Learning and Azure Cognitive Services experience in Azure Synapse Analytics. You will learn how to connect an Azure Synapse Analytics workspace to an Azure Machine Learning workspace using a Linked Service and then trigger an Automated ML experiment that uses data from a Spark table. You will also learn how to use trained models from Azure Machine Learning or Azure Cognitive Services to enrich data in a SQL pool table and then serve prediction results using Power BI. <br/><br/>After completing the lab, you will understand the main steps of an end-to-end Machine Learning process that build on top of the integration between Azure Synapse Analytics and Azure Machine Learning. | https://docs.microsoft.com/en-us/azure/synapse-analytics/machine-learning/quickstart-integrate-azure-machine-learning <br/>https://docs.microsoft.com/en-us/azure/synapse-analytics/machine-learning/tutorial-sql-pool-model-scoring-wizard
Lab 02 | [Working with Apache Spark in Synapse Analytics](./hands-on-labs/lab-02/README.md) | This lab demonstrates the experience of working with Apache Spark in Azure Synapse Analytics. You will learn how to connect an Azure Synapse Analytics workspace to an Azure Data Explorer workspace using a Linked Service and then load data from one of its databases using a Spark notebook. You will also learn how to use libraries like Hyperspace and MSSparkUtil to optimize the experience of working with Data Lake storage accounts from Spark notebooks. In addition to Data Explorer and Data Lake storage, the data enrichment process will also use historical data from a SQL  Pool. In the end, you will learn how to publish the enriched data back into the Data Lake and consume it with the SQL Built-in Pool and Power BI. <br/><br/>After completing the lab, you will understand the main steps of an end-to-end data enrichment process that uses Spark in an Azure Synapse Analytics workspace. | https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-overview<br/>https://techcommunity.microsoft.com/t5/azure-data-explorer/announcing-azure-data-explorer-data-connector-for-azure-synapse/ba-p/1743868
Lab 03 | [Migrating Data Factory Pipelines to Synapse Analytics Pipelines](./hands-on-labs/lab-03/README.md) | This lab demonstrates the experience of migrating an existing Azure Data Factory pipeline to an Azure Synapse Analytics Pipeline. You will learn how to script major ADF artifacts like linked services, datasets, activities, and pipelines. You will also learn how to import these artifacts into Azure Synapse Analytics. In the end, you will learn to validate, test, and trigger the imported Azure Synapse Pipeline.<br/><br/>After completing the lab, you will understand the main steps of a migration process from Azure Data Factory pipelines to Azure Synapse Analytics pipelines. | https://docs.microsoft.com/en-us/dotnet/api/azure.analytics.synapse.artifacts?view=azure-dotnet-preview

