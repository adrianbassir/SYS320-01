$stoppedServices = Get-Service |
Where-Object { $_.Status -eq 'Stopped' }

$sortedServices = $stoppedServices |
Sort-Object -Property Name

$sortedServices | Export-Csv -Path "stopped_services.csv"

$sortedServices