Start-Transcript -Path C:\WindowsAzure\Logs\logontasklogs.txt -Append

#cd 'C:\LabFiles\asa\hands-on-labs\setup\automation'

#Install power Bi desktop
Start-Process -FilePath "C:\LabFiles\PBIDesktop_x64.exe" -ArgumentList '-quiet','ACCEPT_EULA=1'

Unregister-ScheduledTask -TaskName "Setup" -Confirm:$false

Stop-Transcript
