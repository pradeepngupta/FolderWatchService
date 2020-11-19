$sourceId = 'File-Added'

$config_content = Get-Content "./folderWatch.properties" -raw
$configuration = ConvertFrom-StringData($config_content)
$watchDirectory = $configuration.'watchFolder'

$logsDirectory = $configuration.'folderWatchLogsPath'

Write-Host "Adding watch for changes to $watchDirectory"
### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $watchDirectory
$watcher.Filter = "*.*"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true  

$action = {
	# change type information:
	$details = $event.SourceEventArgs
	$Name = $details.Name
	$FullPath = $details.FullPath
	# type of change:
	$changeType = $details.ChangeType

	# when the change occured:
	$Timestamp = $event.TimeGenerated
	
	$logsDirectory = $event.MessageData.logsDirectory
	$FolderWatchLogFile = $logsDirectory+"folderWatch.log"
	
	# let's compose a message:
	$text = "{2}: {0} was {1}" -f $FullPath, $ChangeType, $Timestamp
	((Get-Date).ToString() + " - " + $text) >> $FolderWatchLogFile;
}

$pso = new-object psobject -property @{logsDirectory = $logsDirectory;}
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
Register-ObjectEvent $watcher "Created" -Action $action -SourceIdentifier 'ZBT-File-Added' -MessageData $pso
###Register-ObjectEvent $watcher "Changed" -Action $action
###Register-ObjectEvent $watcher "Deleted" -Action $action
###Register-ObjectEvent $watcher "Renamed" -Action $action
Write-Host "Watching for changes to $watchDirectory"

while ($true) {
	# Wait-Event waits for a second and stays responsive to events
	# Start-Sleep in contrast would NOT work and ignore incoming events
	# Wait-Event -Timeout 1
	Wait-Event -SourceIdentifier 'ZBT-File-Added'

	# write a dot to indicate we are still monitoring:
	Write-Host "Keeps Listening" -NoNewline
}