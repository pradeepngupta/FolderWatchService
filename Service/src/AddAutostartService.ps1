$config_content = Get-Content "../service.properties" -raw
$configuration = ConvertFrom-StringData($config_content)

$scriptPath = $configuration.'actionScript'
$nssm = (Get-Command $configuration.'nssm').Source
$serviceName = $configuration.'serviceName'
$powershell = (Get-Command powershell).Source
$arguments = '-ExecutionPolicy Bypass -NoProfile -File "{0}"' -f $scriptPath
$description = $configuration.'serviceDesctiption'
$StartupType = 'SERVICE_AUTO_START'

$basePath = $configuration.'actionBasePath'
if ($basePath -notmatch '/$') {
	$basePath = $basePath + '/';
}
$logsDirectory = $configuration.'serviceLogsPath'
if($logsDirectory -notmatch '/$') {
	$logsDirectory = $logsDirectory + '/';
}
$AppStdout = $logsDirectory + 'FolderWatchService.log'
$AppStderr = $logsDirectory + 'FolderWatchServiceError.log'

& $nssm install $serviceName $powershell $arguments

# Needs a little time to be ready
Start-Sleep -Milliseconds 500

# Set long description
& $nssm set $serviceName Description $description
# Set startup behaviour
& $nssm set $serviceName Start $StartupType	

& $nssm set $serviceName AppDirectory $basePath

& $nssm set $serviceName AppStdout $AppStdout
& $nssm set $serviceName AppStderr $AppStderr
		
& $nssm status $serviceName

Start-Service $serviceName
Get-Service $serviceName