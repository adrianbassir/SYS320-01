$h2s = $scraped_page.ParsedHtml.body.getElementsByTagName("h2") | ForEach-Object { $_.outerText }
$h2s