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

$dataFactoryAccountName = "asagadatafactory$($uniqueId)"

$dataLakeAccountKey = List-StorageAccountKeys -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroupName -Name $dataLakeAccountName

$secretValue = ConvertTo-SecureString $dataLakeAccountKey -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name "ASA-GA-DATA-LAKE" -SecretValue $secretValue

Write-Output "Data Factory v2 account name is $($dataFactoryAccountName)"
$dataFactoryServicePrincipal = (Get-AzADServicePrincipal -DisplayName $dataFactoryAccountName)
Set-AzKeyVaultAccessPolicy -ResourceGroupName $resourceGroupName -VaultName $keyVaultName -ObjectId $dataFactoryServicePrincipal.Id -PermissionsToSecrets set,delete,get,list

# Create Azure Data Factory v2 linked services

$template = Get-Content -Path "$($templatesPath)/key_vault_linked_service.json"
$templateContent = $template.Replace("#LINKED_SERVICE_NAME#", "asagakeyvault01_adf").Replace("#KEY_VAULT_NAME#", $keyVaultName)
Set-Content -Path .\temp.json -Value $templateContent
Set-AzDataFactoryV2LinkedService -DataFactoryName $dataFactoryAccountName `
    -ResourceGroupName $resourceGroupName -Name "asagakeyvault01_adf" `
    -DefinitionFile ".\temp.json" -Force
Remove-Item -Path .\temp.json -Force


$template = Get-Content -Path "$($templatesPath)/data_lake_key_vault_linked_service.json"
$templateContent = $template.Replace("#LINKED_SERVICE_NAME#", "asagadatalake01_adf").Replace("#DATA_LAKE_ACCOUNT_NAME#", $dataLakeAccountName).Replace("#KEY_VAULT_LINKED_SERVICE_NAME#", "asagakeyvault01_adf").Replace("#SECRET_NAME#", "ASA-GA-DATA-LAKE")
Set-Content -Path .\temp.json -Value $templateContent
Set-AzDataFactoryV2LinkedService -DataFactoryName $dataFactoryAccountName `
    -ResourceGroupName $resourceGroupName -Name "asagadatalake01_adf" `
    -DefinitionFile ".\temp.json" -Force
Remove-Item -Path .\temp.json -Force


$template = Get-Content -Path "$($templatesPath)/sql_pool_key_vault_linked_service.json"
$templateContent = $template.Replace("#LINKED_SERVICE_NAME#", "asagasqlpool01_adf").Replace("#WORKSPACE_NAME#", $workspaceName).Replace("#DATABASE_NAME#", "SQLPool01").Replace("#USER_NAME#", "asaga.sql.admin").Replace("#KEY_VAULT_LINKED_SERVICE_NAME#", "asagakeyvault01_adf").Replace("#SECRET_NAME#", "SQL-USER-ASA")
Set-Content -Path .\temp.json -Value $templateContent
Set-AzDataFactoryV2LinkedService -DataFactoryName $dataFactoryAccountName `
    -ResourceGroupName $resourceGroupName -Name "asagasqlpool01_adf" `
    -DefinitionFile ".\temp.json" -Force
Remove-Item -Path .\temp.json -Force

# Create tables in SQL pool
Write-Information "Create tables for Lab 03 in $($sqlPoolName)"

#$secret = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name SQL-USER-ASA
#$global:sqlPassword = $secret.SecretValue | ConvertFrom-SecureString -AsPlainText
$global:sqlPassword = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name SQL-USER-ASA -AsPlainText

$params = @{}
$result = Execute-SQLScriptFile -SQLScriptsPath $sqlScriptsPath -WorkspaceName $workspaceName -SQLPoolName $sqlPoolName -FileName "05-create-tables-lab-03" -Parameters $params
$result


# Create datasets

Set-AzDataFactoryV2Dataset -DataFactoryName $dataFactoryAccountName `
    -ResourceGroupName $resourceGroupName -Name "wwi02_sale_small_stats_adls" `
    -DefinitionFile "$($datasetsPath)\wwi02_sale_small_stats_adls.json" -Force


Set-AzDataFactoryV2Dataset -DataFactoryName $dataFactoryAccountName `
    -ResourceGroupName $resourceGroupName -Name "wwi02_sale_small_stats_asa" `
    -DefinitionFile "$($datasetsPath)\wwi02_sale_small_stats_asa.json" -Force


# Create pipeline

$template = Get-Content -Path "$($pipelinesPath)/import_sale_small_stats_data.json"
$templateContent = $template.Replace("#BLOB_STORAGE_LINKED_SERVICE_NAME#", "asagadatalake01_adf")
Set-Content -Path .\temp.json -Value $templateContent
Set-AzDataFactoryV2Pipeline -DataFactoryName $dataFactoryAccountName `
    -ResourceGroupName $resourceGroupName -Name "Lab 03 - Import Sales Stats" `
    -DefinitionFile ".\temp.json" -Force
Remove-Item -Path .\temp.json -Force