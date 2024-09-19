$chromeProcess = Get-Process -Name chrome -ErrorAction SilentlyContinue

if ($chromeProcess){
    Stop-Process -Name chrome
    Write-Host "Chrome was running and has been stopped"
} else {
    Start-Process "chrome.exe" "https://www.champlain.edu/"
    Write-Host "Chrome was not running and has been started with champlain.edu"
}