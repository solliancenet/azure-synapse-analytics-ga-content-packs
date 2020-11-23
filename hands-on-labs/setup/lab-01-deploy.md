# Deploy resources for Lab 01

## Deploy services for the lab

Click the `Deploy to Azure` button below to start the deployment process.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsolliancenet%2Fazure-synapse-analytics-ga-content-packs%2Fmain%2Fhands-on-labs%2Fsetup%2Farm%2Fasaga-workspace-lab-01.json%3Ftoken%3DAA2FKXQQI5UL5WU44XW55SS7YTZNK)

You should see next the `Custom deployment` screen where you need to provide the resource group where the Synapse Analytics workspace was deployed (see [Pre-requisites for deployment](./asa-workspace-deploy.md#pre-requisites-for-deployment) for details):

Select `Review + create` to validate the settings.

![Synapse Analytics workspace deployment configuration](../media/lab-01-deploy-configure.png)

Once the validation is passed, select `Create` to start the deployment. You should see next an indication of the deployment progress:

![Synapse Analytics workspace deployment progress](./../media/lab-01-deploy-progress.png)

Wait until the deployment completes successfully before proceeding to the next step.
