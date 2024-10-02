function ApacheLogs1(){
$logsNotFormatted = 
$tableRecords = 

for ($i=0; $i - ; $i++){

$words = 

$tableRecords += 


}

return $tableRecords | Where-Object {}

$tableRecords = ApacheLogs1
$tableRecords | Format-Table -AutoSize -Wrap

}