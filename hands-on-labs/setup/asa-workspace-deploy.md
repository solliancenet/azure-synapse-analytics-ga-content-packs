# Deploy your Azure Synapse Analytics workspace

## Pre-requisites for deployment

The following requirements must be met before the deployment:

- A resource group created in the `South Central US` region (this will be provided during the deployment process).

    >**IMPORTANT**
    >
    >In case you didn't create the resource group yourself, make sure your account has the `Owner` role on the resource group.
    >
    >Also, your account (i.e. the Azure AD account used to deploy the Azure Synapse Analytics workspace) must have permissions to create new resource groups in the subscription (this is required because Synapse Analytics requires an additional resource group to keep various hidden artifacts; this resource group is created during the deployment process).

- A unique suffix to be used when generating the name of the workspace. All workspaces deployed using the templates in this repo are named `asagaworkspace<unique_suffix>`, where `<unique_suffix>` gets replaced with the value you provide. Make sure the unique suffix is specific enough to avoid potential naming collisions (i.e. avoid using common values like `01`, `1`, `test`, etc.). Make sure you remember the unique suffix as you need to use it for additional configuration once the Azure Synapse Analytics workspace deployment is complete.
- A password for the SQL admin account of the workspace. Make sure you save the password in a secure location (like a password manager) as you will need to use it later.
- A GitHub account to access the content packs repository.

## Configure the Azure Cloud Shell

>**NOTE**
>
>If Cloud Shell is already configured, you can skip this section entirely and advance to [Deploy the Synapse Analytics workspace](#deploy-the-synapse-analytics-workspace).

In the Azure Portal, navigate to your resource group and create a new storage account to be used in the Cloud Shell configuration process (make sure the resource type you create is `Storage account`). In the newly created storage account, select `File shares` (under the `File service` settings group) and create a new file share.

Next, select the Cloud Shell icon (located in the top right part of the page) and then select `PowerShell`:

![Cloud Shell configuration start](./../media/cloudshell-configure-01.png)

Select your subscription under `Subscription` if it's not already selected, and then select `Show advanced settings`:

![Cloud Shell configuration advanced settings](./../media/cloudshell-configure-02.png)

Provide values for the following fields:

- **Cloud Shell region**: the same region as the region of your resource group.
- **Resource group**: select `Use existing` and then select you resource group from the list.
- **Storage account**: select `Use existing` and then select the storage account you created above.
- **File share**: select `Use existing` and then select the file share you created above.

Select `Attach storage` once all the values are in place.

![Cloud Shell configuration advanced settings values](./../media/cloudshell-configure-03.png)

Once configuration is complete, you should get an instance of Cloud Shell:

![Cloud Shell](./../media/cloudshell-configure-04.png)

## Deploy the Synapse Analytics workspace

Click the `Deploy to Azure` button below to start the deployment process.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fsolliancenet%2Fazure-synapse-analytics-ga-content-packs%2Fmain%2Fhands-on-labs%2Fsetup%2Farm%2Fasaga-workspace-core.json%3Ftoken%3DAA2FKXQGW3MSP3V67PVZPBC7YH6F2)

You should see next the `Custom deployment` screen where you need to provide the following (see [Pre-requisites for deployment](#pre-requisites-for-deployment) above for details):

- The resource group where the Synapse Analytics workspace will be deployed.
- The unique suffix used to generate the name of the workspace.
- The password for the SQL Administrator account.

Select `Review + create` to validate the settings.

![Synapse Analytics workspace deployment configuration](../media/asaworkspace-deploy-configure.png)

Once the validation is passed, select `Create` to start the deployment. You should see next an indication of the deployment progress:

![Synapse Analytics workspace deployment progress](./../media/asaworkspace-deploy-progress.png)

Wait until the deployment completes successfully before proceeding to the next step.

## Tag your resource group with the unique suffix

In the Azure Portal, navigate to the resource group you used to deploy the Synapse Analytics workspace (see [Pre-requisites for deployment](#pre-requisites-for-deployment) above for details).

Select the `Tags` section and add a new tag named `DeploymentId`. Use the unique suffix as the value of the tag and then select `Apply` to save it.

![Synapse Analytics workspace resource group tagging](./../media/asaworkspace-deploy-tag.png)

The deployment of your Synapse Analytics workspace is now complete. Next, you will deploy the artifacts required by the labs into the newly created Synapse Analytics workspace.

## Run the global setup script in Cloud Shell

In the Azure Portal, navigate to the resource group you used to deploy the Synapse Analytics workspace (see [Pre-requisites for deployment](#pre-requisites-for-deployment) above for details) and start a Cloud Shell instance (see [Configure the Azure Cloud Shell](#configure-the-azure-cloud-shell) above for details).

Once the Cloud Shell instance becomes available, run ```az login``` to make sure the correct account and subscription context are set:

![Cloud Shell login](./../media/cloudshell-setup-01.png)

Clone the content packs repository into the `asa` local folder using

```cmd
git clone https://github.com/solliancenet/azure-synapse-analytics-ga-content-packs asa
```

If GIT asks for credentials, provide your GitHub username and password.

>**IMPORTANT**
>
>If your GitHub account has two-factor authentication activated, you need to provide a PAT (Personal Access Token) instead your password. For more details, read the [Creating a personal access token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) section in GitHub Docs.
>
>When pasting your password or PAT into the Cloud Shell window, make sure you are familiar with the supported key combinations (Shift-INS for Windows and Cmd-V for Mac). For more details, see [Using the Azure Cloud Shell window](https://docs.microsoft.com/en-us/azure/cloud-shell/using-the-shell-window#copy-and-paste).

Once the repository is successfully cloned, you shoud see a result similar to this:

![Cloud Shell git clone repository](./../media/cloudshell-setup-02.png)

Change your current directory using

```cmd
cd asa/hands-on-labs/setup/automation
```

and then start the setup script using

```powershell
.\environment-setup.ps1
```

Make sure the selected subscription is the one that contains the resource group where you deployed the Synapse Analytics workspace:

![Cloud Shell select subscription](./../media/cloudshell-setup-03.png)

Enter the name of the resource group where you deployed the Synapse Analytics workspace:

![Cloud Shell select resource group](./../media/cloudshell-setup-04.png)

The setup script will now proceed to create all necesary Synapse Analytics artifacts in your environment.

The process should take 5 to 10 minutes to finish. Wait until the setup script is finished before proceeding to the next steps.
