Start-Transcript -Path C:\WindowsAzure\Logs\logontasklogs.txt -Append

#Install power Bi desktop
Start-Process -FilePath "C:\LabFiles\PBIDesktop_x64.exe" -ArgumentList '-quiet','ACCEPT_EULA=1'

Cd 'C:\LabFiles\asa\hands-on-labs\setup\automation'

./environment-setup.ps1

sleep 2
./lab-01-setup.ps1

sleep 2

./lab-02-setup.ps1
./lab-03-setup.ps1

Unregister-ScheduledTask -TaskName "Setup" -Confirm:$false
Stop-Transcript
