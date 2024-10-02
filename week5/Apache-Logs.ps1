function Get-IPsAndErrorsFromApacheLog {
    param (
        [string]$Browser = ""
    )


    $logFilePath = "C:\xampp\apache\logs\access.log"

    $ipRegex = [regex] "\b(?:\d{1,3}\.){3}\d{1,3}\b"
    $statusCodeRegex = [regex] "\s(\d{3})\s"

    $logEntries = Get-Content $logFilePath
    $results = @()

    foreach ($entry in $logEntries) {
        if (-not [string]::IsNullOrEmpty($Browser) -and $entry -notmatch $Browser) {
            continue
        }

        $ipMatch = $ipRegex.Match($entry)
        if ($ipMatch.Success) {
            $ipAddress = $ipMatch.Value

            $statusCodeMatch = $statusCodeRegex.Match($entry)
            if ($statusCodeMatch.Success) {
                $statusCode = $statusCodeMatch.Groups[1].Value

                $results += [PSCustomObject]@{
                    IP = $ipAddress
                    StatusCode = $statusCode
                }
            }
        }
    }

    if ($results.Count -eq 0) {
        Write-Host "No log entries found for the given browser: $Browser"
    } else {
        $groupedResults = $results | Group-Object -Property IP, StatusCode | Select-Object @{
            Name = 'Count'; Expression = { $_.Count }
        }, @{
            Name = 'IP'; Expression = { $_.Group[0].IP }
        }, @{
            Name = 'StatusCode'; Expression = { $_.Group[0].StatusCode }
        }

        return $groupedResults
    }
}
