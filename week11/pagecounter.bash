pageCount() {
	awk '{print $7}' /var/log/apache2/access.log | sed 's|^/||' | sort | uniq -c
}

pageCount
