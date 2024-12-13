#!/bin/bash

IOC_URL="http://10.0.17.6/IOC.html"

curl -s "$IOC_URL" | \
grep -oP '(?<=<td>).*?(?=</td>)' | \
awk 'NR % 2 == 1' | \
sed '/^\s*$/d' > IOC.txt
