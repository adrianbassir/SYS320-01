function Get-IOCFromWebPage {
    param (
        [string]$url = "http://10.0.17.5/IOC.html"
    )
    try {
        $webContent = Invoke-WebRequest -Uri $url -UseBasicParsing
    } catch {
        Write-Error "Failed to retrieve content from $url"
        return
    }

    $iocList = @()
    $htmlContent = $webContent.Content

    $regex = "<tr>\s*<td>(.*?)<\/td>\s*<td>(.*?)<\/td>\s*<\/tr>"

    $matches = [regex]::Matches($htmlContent, $regex)

    foreach ($match in $matches) {
        $pattern = $match.Groups[1].Value.Trim()
        $explanation = $match.Groups[2].Value.Trim()

        $iocList += [pscustomobject]@{
            Pattern = $pattern
            Explanation = $explanation
        }
    }

    if ($iocList.Count -eq 0){
        Write-Host "No IOCs found on the page."
    } else {
        $iocList | Format-Table -AutoSize
    }

}

Get-IOCFromWebPage