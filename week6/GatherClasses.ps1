function gatherClasses() {
    $page = Invoke-WebRequest -Uri "http://10.0.17.44/Courses.html" -TimeoutSec 10
    $trs = $page.ParsedHtml.getElementsByTagName('tr')
    $FullTable = @()

    for ($i = 1; $i -lt $trs.length; $i++) {
        $tds = $trs[$i].getElementsByTagName('td')

        # Safely get the time data and split it if it exists
        $timeField = if ($tds[5] -ne $null) { $tds[5].innerText } else { "" }
        $Times = if ($timeField) { $timeField -split "\s*-\s*" } else { @() }

        # Extract the 'Days' from the correct column (index adjusted to 3)
        # Safely get each element, providing a default value if null
        $FullTable += [PSCustomObject]@{
            "Class Code" = if ($tds[0] -ne $null) { $tds[0].innerText.Trim() } else { "" }
            "Title"      = if ($tds[1] -ne $null) { $tds[1].innerText.Trim() } else { "" }
            "Days"       = if ($tds[4] -ne $null) { $tds[4].innerText.Trim() } else { "" }
            "Time Start" = if ($Times.Length -ge 1) { $Times[0].Trim() } else { "" }
            "Time End"   = if ($Times.Length -ge 2) { $Times[1].Trim() } else { "" }
            "Instructor" = if ($tds[6] -ne $null) { $tds[6].innerText.Trim() } else { "" }
            "Location"   = if ($tds[9] -ne $null) { $tds[9].innerText.Trim() } else { "" }
        }

    }
    
    return $FullTable
}



function daysTranslator($FullTable) {
    for ($i = 0; $i -lt $FullTable.length; $i++) {
        # Empty array to hold days for every record
        $Days = @()

        # Extract the days string and trim any extra spaces
        $daysString = $FullTable[$i].Days.Trim()

        # If you see "M" -> Monday
        if ($daysString -match "\bM\b") { $Days += "Monday" }

        # If you see "T" but not "TH" -> Tuesday
        if ($daysString -match "\bT\b" -and $daysString -notmatch "\bTH\b") { $Days += "Tuesday" }

        # If you see "W" -> Wednesday
        if ($daysString -match "\bW\b") { $Days += "Wednesday" }

        # If you see "TH" -> Thursday
        if ($daysString -match "\bTH\b") { $Days += "Thursday" }

        # If you see "F" -> Friday
        if ($daysString -match "\bF\b") { $Days += "Friday" }

        # Update the Days property with the array of days
        $FullTable[$i].Days = $Days
    }

    return $FullTable
}
