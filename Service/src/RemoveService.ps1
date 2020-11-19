$config_content = Get-Content "../service.properties" -raw
$configuration = ConvertFrom-StringData($config_content)

$nssm = (Get-Command $configuration.'nssm').Source
$serviceName = $configuration.'serviceName'

$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if ($service)
{
	if ($service.Status -ine 'Stopped')
	{
		Write-Host "Attempting to stop $serviceName"
		$service.Stop()

		while ($service.Status -ine 'Stopped')
		{
			Start-Sleep -Seconds 1
			$service.Refresh()
		}
	}
}

& $nssm remove $serviceName 