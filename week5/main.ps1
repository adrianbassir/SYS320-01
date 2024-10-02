
. "C:\Users\champuser\SYS320-01\week5\Apache-Logs.ps1"

$browser = "Chrome"

$result = Get-IPsAndErrorsFromApacheLog -Browser $browser

$result
