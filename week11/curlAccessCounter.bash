countingCurlAccess(){
	grep "curl" /var/log/apache2/access.log | awk '{print $1, $12}' | sort | uniq -c
}

countingCurlAccess
