. C:\Users\champuser\SYS320-01\week7\apachelogsone.ps1
. C:\Users\champuser\SYS320-01\week7\getfailedlogins.ps1
. C:\Users\champuser\SYS320-01\week7\Event-Logs.ps1
. C:\Users\champuser\SYS320-01\week7\main.ps1

function Show-Menu {
    Write-Host "1. Display last 10 apache logs"
    Write-Host "2. Display last 10 failed logins for all users"
    Write-Host "3. Display at-risk users"
    Write-Host "4. Start Chrome web browser and navigate to champlain.edu"
    Write-Host "5. Exit"
}

function Get-UserSelection {
    param (
        [int]$min = 1,
        [int]$max = 5
    )
    $selection = Read-Host "Please enter your choice (1-5)"
    while ($selection -notmatch '^[1-5]$') {
        Write-Host "Invalid input. Please enter a number between $min and $max." -ForegroundColor Red
        $selection = Read-Host "Please enter your choice (1-5)"
    }
    return [int]$selection
}

do {
    Show-Menu
    $choice = Get-UserSelection

    switch ($choice) {
        1 {
            Write-Host "Displaying the last 10 Apache logs..."
            ApacheLogs1
        }
        2 {
            Write-Host "Displaying the last 10 failed login attempts..."
            getFailedLoginsTen
        }
        3 {
            Write-Host "Displaying at-risk users..."
            listAtRiskUsers
        }
        4 {
            Write-Host "Checking if Chrome is running..."
            if (-not (Get-Process -Name chrome -ErrorAction SilentlyContinue)) {
                Start-Process "chrome.exe" "https://www.champlain.edu"
                Write-Host "Chrome started and navigated to champlain.edu."
            } else {
                Write-Host "Chrome is already running."
            }
        }
        5 {
            Write-Host "Exiting the menu. Goodbye!" -ForegroundColor Green
        }
        default {
            Write-Host "Invalid option. Please select a valid menu option." -ForegroundColor Red
        }
    }
} while ($choice -ne 5)
