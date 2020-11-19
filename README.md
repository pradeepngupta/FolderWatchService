# FolderWatchService
A FolderWatch Service in Windows OS with Powershell script and NSSM (Non-Sucking Service Manager) [https://nssm.cc/]

There are two main properties file to configure the FolderWatcher service after you download the code from this repository
1. Service/service.properties - For configuration the service name / description
2. folderWatcher.properties - For configuration of which folder to be watched.

How to run the Service:
1. Run the powershell as an administrator
2. Run Service/AddAutoStartService.ps1 - This will start and run the Folder Watcher Service on your windows OS.
		After running the script, once can see the Service 'My FolderWatcher' in the Services.msc
		This service starts watching the folder, <your basepath>/watchFolder
3. Run Service/RemoveService.ps1 - This will remove the above mentioned service.
