$scraped_page = Invoke-WebRequest -Uri "http://10.0.17.44/ToBeScraped.html"

$scraped_page.Links.Count