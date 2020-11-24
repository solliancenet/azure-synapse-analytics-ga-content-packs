using System;
using System.Collections.Generic;

//
// .net core console application to demo the Azure.Analytics.Synapse sdk for c#
// -----------------------------------------------------------------------------
//
// use Nuget Package Manager Console to install the required Azure SDK dependencies
//
// Install-Package Azure.Analytics.Synapse.Artifacts -Version 1.0.0-preview.4
// Install-Package Azure.Identity
// Install-Package Microsoft.Azure.Management.DataFactory
//

using Azure.Analytics.Synapse.Artifacts;
using Azure.Analytics.Synapse.Artifacts.Models;
using Azure.Core;
using Azure.Identity;
using SchemaElem = Microsoft.Azure.Management.DataFactory.Models.DatasetSchemaDataElement;

namespace azClient
{
    class AzurePipelineClientExample
    {
        static void Main(string[] args)
        {

            //
            // 1. PREPARE TWO DATASETS to be used with our pipeline
            //
            AzureBlobFSLocation ds1Location = new AzureBlobFSLocation();
            ds1Location.FileName = "telemData20191201.csv";
            ds1Location.FolderPath = "sale-small-telemetry";
            ds1Location.FileSystem = "wwi-02";

            LinkedServiceReference linkedServiceName1 = new LinkedServiceReference(new LinkedServiceReferenceType("LinkedServiceReference"), "asadatalake01");
            DelimitedTextDataset ds1 = new DelimitedTextDataset(linkedServiceName1);
            ds1.Location = ds1Location;
            ds1.ColumnDelimiter = ",";
            ds1.EscapeChar = "\\";
            ds1.QuoteChar = "\"";
            ds1.Schema = new SchemaElem[] //required package: Microsoft.Azure.Management.DataFactory
            {
                new SchemaElem(null, null, "String"),
                new SchemaElem(null, null, "String"),
                new SchemaElem(null, null, "String"),
                new SchemaElem(null, null, "String")
            };
            DatasetResource ds1Resource = new DatasetResource(ds1);

            LinkedServiceReference linkedServiceName2 = new LinkedServiceReference(new LinkedServiceReferenceType("LinkedServiceReference"), "asadataexplorer01");
            AzureDataExplorerTableDataset ds2 = new AzureDataExplorerTableDataset(linkedServiceName2);
            ds2.Table = "SalesTelemetry";
            DatasetResource ds2Resource = new DatasetResource(ds2);

            const string DATASET_1 = "TelemetryCsv";
            const string DATASET_2 = "AdeKustoSalesTelemetry";

            //
            // 2. PREPARE THE PIPELINE that we want to add to Azure
            //
            AzureBlobFSReadSettings sourceStoreSettings = new AzureBlobFSReadSettings
            {
                Recursive = true,
                WildcardFolderPath = "sale-small",
                WildcardFileName = "*.csv"
            };

            DelimitedTextReadSettings sourceFormatSettings = new DelimitedTextReadSettings
            {
                SkipLineCount = 0
            };

            DelimitedTextSource source = new DelimitedTextSource
            {
                StoreSettings = sourceStoreSettings,
                FormatSettings = sourceFormatSettings
            };

            AzureDataExplorerSink sink = new AzureDataExplorerSink();

            CopyActivity act = new CopyActivity("Copy Data", source, sink);
            //act.DependsOn;
            //act.UserProperties;
            //act.LinkedServiceName;
            //act.Policy;
            act.Inputs.Add(new DatasetReference(new DatasetReferenceType("DatasetReference"), DATASET_1)); //"TelemetryCsv" dataset must have been defined
            act.Outputs.Add(new DatasetReference(new DatasetReferenceType("DatasetReference"), DATASET_2)); //"AdeKustoSalesTelemetry" dataset must have been defined
            act.Source = source;
            act.Sink = sink;

            PipelineResource pipeline = new PipelineResource();
            pipeline.Activities.Add(act);

            //
            // 3. MAIN: ask Azure to create the datasets and the pipeline that uses them:
            //
            // https://docs.microsoft.com/en-us/dotnet/api/azure.analytics.synapse.artifacts.pipelineclient.-ctor?view=azure-dotnet-preview
            //

            // authenticate to Azure
            Uri endpoint = new Uri("https://my-endpoint");
            TokenCredential credential = new DefaultAzureCredential(true); //required package: Azure.Identity 

            //register datasets
            DatasetClient azureSynapseDatasetClient = new DatasetClient(endpoint, credential); //required package: Azure.Analytics.Synapse.Artifacts
            azureSynapseDatasetClient.StartCreateOrUpdateDataset(DATASET_1, ds1Resource);
            azureSynapseDatasetClient.StartCreateOrUpdateDataset(DATASET_2, ds2Resource);

            //create the new pipeline
            PipelineClient azureSynapsePipelineClient = new PipelineClient(endpoint, credential); //required package: Azure.Analytics.Synapse.Artifacts
            azureSynapsePipelineClient.StartCreateOrUpdatePipeline("NewPipeline01", pipeline);
        }
    }
}


//{
//    "name": "Copy data2",
//    "type": "Copy",
//    "dependsOn": [],
//    "policy": {
//        "timeout": "7.00:00:00",
//        "retry": 0,
//        "retryIntervalInSeconds": 30,
//        "secureOutput": false,
//        "secureInput": false
//    },
//    "userProperties": [],
//    "typeProperties": {
//        "source": {
//            "type": "DelimitedTextSource",
//            "storeSettings": {
//                "type": "AzureBlobFSReadSettings",
//                "recursive": true
//            },
//            "formatSettings": {
//                "type": "DelimitedTextReadSettings"
//            }
//        },
//        "sink": {
//            "type": "AzureDataExplorerSink"
//        },
//        "enableStaging": false,
//        "translator": {
//            "type": "TabularTranslator",
//            "typeConversion": true,
//            "typeConversionSettings": {
//                "allowDataTruncation": true,
//                "treatBooleanAsNumber": false
//            }
//        }
//    },
//    "inputs": [
//        {
//        "referenceName": "TelemetryCsv",
//            "type": "DatasetReference"
//        }
//    ],
//    "outputs": [
//        {
//        "referenceName": "AdeKustoSalesTelemetry",
//            "type": "DatasetReference"
//        }
//    ]
//}


//
// https://azure.github.io/azure-sdk-for-net/
// https://github.com/Azure/azure-sdk-for-net/tree/Microsoft.Azure.Synapse_0.1.0-preview
// https://docs.microsoft.com/en-us/python/api/azure-core/azure.core.pipelineclient?view=azure-python
// https://docs.microsoft.com/en-us/dotnet/api/azure.analytics.synapse.artifacts.pipelineclient.startcreateorupdatepipeline?view=azure-dotnet-preview#Azure_Analytics_Synapse_Artifacts_PipelineClient_StartCreateOrUpdatePipeline_System_String_Azure_Analytics_Synapse_Artifacts_Models_PipelineResource_System_String_System_Threading_CancellationToken_
// https://docs.microsoft.com/en-us/azure/search/tutorial-csharp-create-first-app
//

//https://azure.github.io/azure-sdk-for-net/#client-new-releases
//https://azure.github.io/azure-sdk/releases/latest/dotnet.html
//https://azure.microsoft.com/en-us/downloads/?sdk=net
//https://www.nuget.org/packages/Azure.Analytics.Synapse.Artifacts/1.0.0-preview.4
//https://github.com/Azure/azure-sdk-for-net/tree/Microsoft.Azure.Synapse_0.1.0-preview
//
