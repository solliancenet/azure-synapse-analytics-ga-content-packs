# Deploy your Azure Synapse Analytics workspace

## Pre-requisites for deployment

The following requirements must be met before the deployment:

- A resource group created in the `South Central US` region (this will be provided during the deployment process).
- The Azure AD account used to deploy the Azure Synapse Analytics workspace must have permissions to create new resource groups in the subscription (this is required because Azure Synapse Analytics requires an additional resource group to keep various hidden artifacts; this resource group is created during the deployment process).
- A password for the SQL admin account of the workspace. Make sure you save the password in a secure location (like a password manager) as you will need to use it later.
- A unique suffix to be used when generating the name of the workspace. All workspaces deployed using the templates in this repo are named `asagaworkspace<unique_suffix>`, where `<unique_suffix>` gets replaced with the value you provide. Make sure the unique suffix is specific enough to avoid potential naming collisions (i.e. avoid using common values like `01`, `1`, `test`, etc.). Make sure you remember the unique suffix as you need to use it for additional configuration once the Azure Synapse Analytics workspace deployment is complete.

## Deploy the workspace

Click the `Deploy to Azure` button below to start the deployment process.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsolliancenet%2Fazure-synapse-analytics-ga-content-packs%2Fmain%2Fhands-on-labs%2Fsetup%2Farm%2Fasaga-workspace-core.json%3Ftoken%3DAA2FKXQGW3MSP3V67PVZPBC7YH6F2)

You should see nex the `Customer deployment` screen where you need to provide the following (see [Pre-requisites for deployment](#pre-requisites-for-deployment) above for details):

- The resource group where the Synapse Analytics workspace will be deployed.
- The unique suffix used to generate the name of the workspace.
- The password for the SQL Administrator account.

![Synapse Analytics workspace deployment configuration](../media/asaworkspace-deploy-configure.png)

