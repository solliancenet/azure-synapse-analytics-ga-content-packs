$InformationPreference = "Continue"

if(Get-Module -Name solliance-synapse-automation){
    Remove-Module solliance-synapse-automation
}
Import-Module "..\solliance-synapse-automation"

#Different approach to run automation in Cloud Shell
$subs = Get-AzSubscription | Select-Object -ExpandProperty Name
if($subs.GetType().IsArray -and $subs.length -gt 1){
    $subOptions = [System.Collections.ArrayList]::new()
    for($subIdx=0; $subIdx -lt $subs.length; $subIdx++){
            $opt = New-Object System.Management.Automation.Host.ChoiceDescription "$($subs[$subIdx])", "Selects the $($subs[$subIdx]) subscription."   
            $subOptions.Add($opt)
    }
    $selectedSubIdx = $host.ui.PromptForChoice('Enter the desired Azure Subscription for this lab','Copy and paste the name of the subscription to make your choice.', $subOptions.ToArray(),0)
    $selectedSubName = $subs[$selectedSubIdx]
    Write-Information "Selecting the $selectedSubName subscription"
    Select-AzSubscription -SubscriptionName $selectedSubName
}

$resourceGroupName = Read-Host "Enter the resource group name";

$userName = ((az ad signed-in-user show) | ConvertFrom-JSON).UserPrincipalName

$artifactsPath = "..\..\"
$reportsPath = "..\reports"
$templatesPath = "..\templates"
$datasetsPath = "..\datasets"
$dataflowsPath = "..\dataflows"
$pipelinesPath = "..\pipelines"
$sqlScriptsPath = "..\sql"


Write-Information "Using $resourceGroupName";

$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName
$uniqueId =  $resourceGroup.Tags["DeploymentId"]
$location = $resourceGroup.Location
$subscriptionId = (Get-AzContext).Subscription.Id
$tenantId = (Get-AzContext).Tenant.Id
$global:logindomain = (Get-AzContext).Tenant.Id;

$workspaceName = "asagaworkspace$($uniqueId)"
$dataLakeAccountName = "asagadatalake$($uniqueId)"
$keyVaultName = "asagakeyvault$($uniqueId)"
$keyVaultSQLUserSecretName = "SQL-USER-ASA"
$sqlPoolName = "SQLPool01"
$integrationRuntimeName = "AutoResolveIntegrationRuntime"
$sparkPoolName = "SparkPool01"
$global:sqlEndpoint = "$($workspaceName).sql.azuresynapse.net"
$global:sqlUser = "asaga.sql.admin"

$global:synapseToken = ""
$global:synapseSQLToken = ""
$global:managementToken = ""
$global:powerbiToken = "";

$global:tokenTimes = [ordered]@{
        Synapse = (Get-Date -Year 1)
        SynapseSQL = (Get-Date -Year 1)
        Management = (Get-Date -Year 1)
        PowerBI = (Get-Date -Year 1)
}

Write-Information "Creating the SalesTelemetry table"

$kustoClusterName = "asagadataexplorer$($uniqueId)"
$kustoDatabaseName = "ASA-Data-Explorer-DB-01"
$kustoStatement = ".create table SalesTelemetry ( CustomerId:int32, ProductId:int32, Timestamp:datetime, Url:string)"

$token = ((az account get-access-token --resource https://help.kusto.windows.net) | ConvertFrom-Json).accessToken
$body = "{ db: ""$kustoDatabaseName"", csl: ""$kustoStatement"" }"
Invoke-RestMethod -Uri https://$kustoClusterName.$($location).kusto.windows.net/v1/rest/mgmt -Method POST -Body $body -Headers @{ Authorization="Bearer $token" } -ContentType "application/json"

# Set the Azure Synapse Analytics GA Labs service principal as admin on the Kusto database

Write-Information "Making the service principal 'Azure Synapse Analytics GA Labs' an admin on the Kusto database"
$app = ((az ad sp list --display-name "Azure Synapse Analytics GA Labs") | ConvertFrom-Json)[0]
$kustoStatement = ".add database ['$($kustoDatabaseName)'] admins ('aadapp=$($app.appId)')"
$body = "{ db: ""$kustoDatabaseName"", csl: ""$kustoStatement"" }"
Invoke-RestMethod -Uri https://$kustoClusterName.$($location).kusto.windows.net/v1/rest/mgmt -Method POST -Body $body -Headers @{ Authorization="Bearer $token" } -ContentType "application/json"


Write-Information "Create linked service for Kusto database $($kustoDatabaseName)"

$linkedServiceName = $kustoClusterName.ToLower()
$result = Create-DataExplorerKeyVaultLinkedService -TemplatesPath $templatesPath -WorkspaceName $workspaceName -Name $linkedServiceName -DataExplorerClusterName "$($kustoClusterName).$($location)" `
                 -DataExplorerDatabaseName $kustoDatabaseName -AADTenantId $tenantId -AADServicePrincipalId $app.appId -KeyVaultLinkedServiceName $keyVaultName -SecretName "ASA-GA-LABS"
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId



Write-Information "Create data sets for loading sales telemetry data into $($kustoDatabaseName) Kusto database"

$loadingDatasets = @{
        wwi02_sale_small_telemetry_adls = $dataLakeAccountName
        wwi02_sale_small_telemetry_ade = $linkedServiceName
}

foreach ($dataset in $loadingDatasets.Keys) {
        Write-Information "Creating dataset $($dataset)"
        $result = Create-Dataset -DatasetsPath $datasetsPath -WorkspaceName $workspaceName -Name $dataset -LinkedServiceName $loadingDatasets[$dataset]
        Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId
}

Write-Information "Create pipeline to load sales telemetry data into the Data Explorer database"

$params = @{}
$loadingPipelineName = "Setup - Import sales telemetry data"
$fileName = "import_sale_small_telemetry_data"

Write-Information "Creating pipeline $($loadingPipelineName)"

$result = Create-Pipeline -PipelinesPath $pipelinesPath -WorkspaceName $workspaceName -Name $loadingPipelineName -FileName $fileName -Parameters $params
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

Write-Information "Running pipeline $($loadingPipelineName)"

$result = Run-Pipeline -WorkspaceName $workspaceName -Name $loadingPipelineName
$result = Wait-ForPipelineRun -WorkspaceName $workspaceName -RunId $result.runId
$result

Write-Information "Deleting pipeline $($loadingPipelineName)"

$result = Delete-ASAObject -WorkspaceName $workspaceName -Category "pipelines" -Name $loadingPipelineName
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId

foreach ($dataset in $loadingDatasets.Keys) {
        Write-Information "Deleting dataset $($dataset)"
        $result = Delete-ASAObject -WorkspaceName $workspaceName -Category "datasets" -Name $dataset
        Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId
}



Write-Information "Deleting linked service for Kusto database"

$result = Delete-ASAObject -WorkspaceName $workspaceName -Category "linkedservices" -Name $linkedServiceName
Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId