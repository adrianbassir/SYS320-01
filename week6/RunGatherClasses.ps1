. "C:\Users\champuser\SYS320-01\week6\GatherClasses.ps1"

$classes = gatherClasses
$translatedClasses = daysTranslator($classes)

foreach ($class in $translatedClasses) {
    Write-Output "Class Code : $($class.'Class Code')"
    Write-Output "Title      : $($class.Title)"
    Write-Output "Days       : {$($class.Days -join ', ')}"
    Write-Output "Time Start : $($class.'Time Start')"
    Write-Output "Time End   : $($class.'Time End')"
    Write-Output "Instructor : $($class.Instructor)"
    Write-Output "Location   : $($class.Location)"
    Write-Output ""
}