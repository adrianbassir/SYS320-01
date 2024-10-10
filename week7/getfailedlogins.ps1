function getFailedLoginsTen {

    $failedlogins = Get-EventLog -LogName Security |
        Where-Object { $_.EventID -eq 4625 } |
        Select-Object -Last 10

    $failedlogins | Format-Table -AutoSize
}
