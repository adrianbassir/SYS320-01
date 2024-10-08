function gatherClasses {
    $page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.44/Courses.html

    $trs = $page.ParsedHtml.getElementsByTagName('tr')

    $fullTable = @()

    for ($i = 1; $i -lt $trs.length; $i++) {
        $tds = $trs[$i].getElementsByTagName('td')

        $Times = $tds[5].innerText -split '-'

        $fullTable += [PSCustomObject]@{
            "Class Code" = $tds[0].innerText.Trim()
            "Title"      = $tds[1].innerText.Trim()
            "Days"       = $tds[4].innerText.Trim()
            "Time Start" = $Times[0].Trim()
            "Time End"   = $Times[1].Trim()
            "Instructor" = $tds[6].innerText.Trim()
            "Location"   = $tds[9].innerText.Trim()
        }
    }
    return $fullTable
}

function daysTranslator ($fullTable) {
    for ($i = 0; $i -lt $fullTable.Length; $i++) {
        $days = @()

        if ($fullTable[$i].Days -like "*M*") { $days += "Monday" }
        if ($fullTable[$i].Days -like "*T*" -and $fullTable[$i].Days -notlike "*Th*") { $days += "Tuesday" }
        if ($fullTable[$i].Days -like "*W*") { $days += "Wednesday" }
        if ($fullTable[$i].Days -like "*Th*") { $days += "Thursday" }
        if ($fullTable[$i].Days -like "*F*") { $days += "Friday" }

        $fullTable[$i].Days = "{" + ($days -join ', ') + "}"
    }
    return $fullTable
}

$classes = gatherClasses
$translatedClasses = daysTranslator $classes

$translatedClasses

# 6.i) List all the classes of the instructor Furkan Paligu, including the instructor's name in the output
$classesByInstructor = $translatedClasses | Where-Object { $_.Instructor -eq "Furkan Paligu" } | 
    Select-Object "Class Code", "Title", "Days", "Time Start", "Time End", "Instructor", "Location"
$classesByInstructor

# 6.ii) List all the classes of JOYC 310 on Mondays, only display Class Code and Times
# Sort by Start Time
$translatedClasses | Where-Object { 
    $_.Location -like "*JOYC 310*" -and ($_.Days -like "*Monday*") 
} | 
Sort-Object "Time Start" | 
Select-Object "Time Start", "Time End", "Class Code" | 
Format-Table -AutoSize

# 6.iii) Make a list of all the instructors that teach at least 1 course in the courses: SYS, NET, SEC, FOR, CSI, DAT
$ITInstructors = $translatedClasses | 
    Where-Object { $_."Class Code" -match 'SYS|SEC|NET|FOR|CSI|DAT' } |
    Select-Object -Property "Instructor" -Unique |
    Sort-Object "Instructor"
$ITInstructors

# 6.iv) Group all the instructors by the number of classes they are teaching, sort by the number of classes they are teaching
$instructorGroups = $translatedClasses | Group-Object "Instructor" |
    Select-Object Count, Name |  # Select Count first, then Name
    Sort-Object Count -Descending | 
    Format-Table -AutoSize
$instructorGroups