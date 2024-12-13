#!/bin/bash

# Input and Output
INPUT_FILE="report.txt"
OUTPUT_FILE="/var/www/html/report.html"

# Check if report.txt exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: $INPUT_FILE not found!"
    exit 1
fi

# Start HTML file with basic structure
echo "<html>" > "$OUTPUT_FILE"
echo "<head><title>IOC Report</title></head>" >> "$OUTPUT_FILE"
echo "<body>" >> "$OUTPUT_FILE"
echo "<h2>Access logs with IOC indicators:</h2>" >> "$OUTPUT_FILE"
echo "<table border='1' cellspacing='0' cellpadding='5'>" >> "$OUTPUT_FILE"

# Table Header
echo "<tr><th>IP</th><th>Date/Time</th><th>Page Accessed</th></tr>" >> "$OUTPUT_FILE"

# Read each line from report.txt and format it into HTML rows
while read -r line; do
    IP=$(echo "$line" | awk '{print $1}')
    DATETIME=$(echo "$line" | awk '{print $2}')
    PAGE=$(echo "$line" | awk '{print $3, $4}')

    echo "<tr>" >> "$OUTPUT_FILE"
    echo "<td>$IP</td><td>$DATETIME</td><td>$PAGE</td>" >> "$OUTPUT_FILE"
    echo "</tr>" >> "$OUTPUT_FILE"
done < "$INPUT_FILE"

# Close HTML tags
echo "</table>" >> "$OUTPUT_FILE"
echo "</body>" >> "$OUTPUT_FILE"
echo "</html>" >> "$OUTPUT_FILE"

# Ensure proper permissions for the HTML file
chmod 644 "$OUTPUT_FILE"

# Inform user of success
echo "HTML report generated at $OUTPUT_FILE"
