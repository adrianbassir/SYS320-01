. "C:\Users\champuser\SYS320-01\week6\GatherClasses.ps1"

$classes = gatherClasses

$translatedClasses = daysTranslator($classes)

$FullTable | Where-Object {
    $_."Instructor" -eq "Furkan Paligu"
} | Select-Object "Class Code", Instructor, Location, Days, "Time Start", "Time End"
