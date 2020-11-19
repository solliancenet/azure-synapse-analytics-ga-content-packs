# Azure Synapse Analytics GA Content Packs

Readiness content packs for Azure Synapse Analytics features released at GA.

The following content packs will be released:
- Pre-GA content pack
- Post-GA content pack

The following table shows the mapping of categories and topics to content packs:

<table>
    <thead><tr>
        <th colspan=5>Category / Topic mapping to content packs</th>
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
            <td>Markdown / Lab 03 v1</td>
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
            <td></td>
        </tr>
        <tr>
            <td rowspan="4">Linked Services</td>
            <td>Integration - Babylon</td>
            <td></td>
            <td>Markdown / Video 07</td>
            <td></td>
        </tr>
        <tr>
            <td>Integration - AML</td>
            <td>Markdown / Video 03 / Lab 01 v1</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Integration - Cognitive Services</td>
            <td>Markdown / Video 03 / Lab 01 v1</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Integration - Azure Data Explorer</td>
            <td>Markdown / Video 03 / Lab 02 v1</td>
            <td></td>
            <td>https://docs.microsoft.com/en-us/azure/synapse-analytics/quickstart-connect-azure-data-explorer</td>
        </tr>
        <tr>
            <td rowspan="2">Synapse Link</td>
            <td>Synapse Link with MongoDB API</td>
            <td></td>
            <td>Markdown / Video 08</td>
            <td></td>
        </tr>
        <tr>
            <td>Synapse Link SQL serverless - CosmosDB</td>
            <td>Markdown / Video 04</td>
            <td></td>
            <td>https://docs.microsoft.com/en-us/azure/cosmos-db/synapse-link<br/>https://docs.microsoft.com/en-us/azure/synapse-analytics/sql/query-cosmos-db-analytical-store</td>
        </tr>
        <tr>
            <td rowspan="6">Development</td>
            <td>Data Wrangling using Power Query</td>
            <td></td>
            <td>Markdown / Video 09</td>
            <td></td>
        </tr>
        <tr>
            <td>Apache Spark in Synapse</td>
            <td>Markdown / Video 05 / Lab 02 v1</td>
            <td></td>
            <td>https://docs.microsoft.com/en-us/azure/synapse-analytics/metadata/overview</td>
        </tr>
        <tr>
            <td>What does it mean to run Apache Spark in Synapse - benefits, unique capabilities</td>
            <td>Markdown / Video 05 / Lab 02 v1</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>MSSparkUtil library, Hummingbird library</td>
            <td>Markdown / Video 05</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Metastore - Spark and serverless SQL pool</td>
            <td>Markdown / Video 05</td>
            <td></td>
            <td>https://docs.microsoft.com/en-us/azure/synapse-analytics/metadata/database <br/>
            https://docs.microsoft.com/en-us/azure/synapse-analytics/metadata/table</td>
        </tr>
        <tr>
            <td>Hyperspace</td>
            <td>Markdown / Video 05</td>
            <td></td>
            <td>https://github.com/microsoft/hyperspace</td>
        </tr>
        <tr>
            <td rowspan="4">Monitoring</td>
            <td>Monitoring - Az Monitor Integration</td>
            <td>Markdown / Video 06</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Monitoring - SQL Request Details</td>
            <td>Markdown / Video 06</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Monitoring - Spark pools</td>
            <td>Markdown / Video 06</td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>Monitoring  - dedicated SQL pool</td>
            <td>Markdown / Video 06</td>
            <td></td>
            <td></td>
        </tr>
    </tbody>
</table>


## Labs

Id | Name | Description | Useful links
---|---|---|---
Lab 01 | [The Integrated Machine Learning process in Synapse Analytics](./hands-on-labs/lab-01/README.md) | Data Lake -> Spark table -> AutoML model -> ONNX model -> SQL Pool + PREDICT | https://docs.microsoft.com/en-us/azure/synapse-analytics/machine-learning/quickstart-integrate-azure-machine-learning <br/>https://docs.microsoft.com/en-us/azure/synapse-analytics/machine-learning/tutorial-sql-pool-model-scoring-wizard
Lab 02 | [Working with Apache Spark in Synapse Analytics](./hands-on-labs/lab-02/README.md) | Load data from Kusto, Data Lake, SQL table in Spark data frame, consolidate and enrich data, save in Spark table or SQL Pool table for later reuse. | https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-overview
Lab 03 | Migrating Data Factory Pipelines to Synapse Analytics Pipelines | "Manual" migration of ADF pipelines to Synapse Analytics using the Synapse Analytics SDK. | https://docs.microsoft.com/en-us/dotnet/api/azure.analytics.synapse.artifacts?view=azure-dotnet-preview

