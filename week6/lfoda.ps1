# Print innerText of every div element that has the class as "div-1"
$divs1 = $scraped_page.ParsedHtml.getElementsByTagName("div") | Where-Object {
    $_.className -eq "div-1"
} | ForEach-Object {
    [PSCustomObject]@{ innerText = $_.innerText }
}

$divs1