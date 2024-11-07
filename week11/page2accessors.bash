cat /var/log/apache2/access.log | grep "page2.html" | awk '{print $1, $7}' | sed 's|/||'
