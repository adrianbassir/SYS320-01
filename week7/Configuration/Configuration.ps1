function readConfiguration {
    if (Test-Path -Path "./configuration.txt") {
        $config = Get-Content -Path "./configuration.txt"
        $configObject = [pscustomobject]@{
            Days = [int]$config[0]
            ExecutionTime = $config[1]
        }
        return $configObject
    } else {
        Write-Host "Configuration file not found."
    }
}

function changeConfiguration {
    $newDays = Read-Host "Enter the number of days (only digits)"
    while (-not ($newDays -match '^\d+$')) {
        Write-Host "Invalid input! Please enter digits only."
        $newDays = Read-Host "Enter the number of days (only digits)"
    }

    $newTime = Read-Host "Enter the execution time (format: HH:MM AM/PM)"
    while (-not ($newTime -match '^\d{1,2}:\d{2} (AM|PM)$')) {
        Write-Host "Invalid time format! Please enter time as HH:MM AM/PM."
        $newTime = Read-Host "Enter the execution time (format: HH:MM AM/PM)"
    }

    @(
        "$newDays"
        "$newTime"
    ) | Set-Content -Path "./configuration.txt"

    Write-Host "Configuration updated successfully."
}

function configurationMenu {
    do {
        Write-Host "1. Show Configuration"
        Write-Host "2. Change Configuration"
        Write-Host "3. Exit"

        $choice = Read-Host "Choose an option (1, 2, or 3)"

        switch ($choice) {
            1 {
                $config = readConfiguration
                if ($config) {
                    Write-Host "Current Configuration:"
                    $config | Format-Table -AutoSize
                }
            }
            2 { changeConfiguration }
            3 { Write-Host "Exiting..." }
            default { Write-Host "Invalid choice. Please choose 1, 2, or 3." }
        }
    } while ($choice -ne 3)
}

# Run the menu
configurationMenu
