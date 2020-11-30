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

$cognitiveServicesAccountName = "asagacognitiveservices$($uniqueId)"

$cognitiveServicesKeys = Get-AzCognitiveServicesAccountKey -ResourceGroupName $resourceGroupName -name $cognitiveServicesAccountName

$secretValue = ConvertTo-SecureString $cognitiveServicesKeys.Key1 -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "ASA-GA-COGNITIVE-SERVICES" -SecretValue $secretValue


Write-Information "Create data sets for Product Quantity Forecast data load in SQL pool $($sqlPoolName)"

$loadingDatasets = @{
        wwi02_sale_small_product_quantity_forecast_adls = $dataLakeAccountName
        wwi02_sale_small_product_quantity_forecast_asa = $sqlPoolName.ToLower()
}

foreach ($dataset in $loadingDatasets.Keys) {
        Write-Information "Creating dataset $($dataset)"
        $result = Create-Dataset -DatasetsPath $datasetsPath -WorkspaceName $workspaceName -Name $dataset -LinkedServiceName $loadingDatasets[$dataset]
        Wait-ForOperation -WorkspaceName $workspaceName -OperationId $result.operationId
}