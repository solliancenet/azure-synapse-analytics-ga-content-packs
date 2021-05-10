Start-Transcript -Path C:\WindowsAzure\Logs\CloudLabsCustomScriptExtension.txt -Append
[Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls" 
 

#Import Common Functions
#. cloudlabs-common\cloudlabs-windows-functions.ps1
$path = pwd 
$ImportCommonFunctions = $path.Path + "\cloudlabs-common\cloudlabs-windows-functions.ps1"
. $ImportCommonFunctions


#Run Common Functions
WindowsServerCommon
InstallEdgeChromium
DisableServerMgrNetworkPopup
Disable-InternetExplorerESC
Enable-IEFileDownload
