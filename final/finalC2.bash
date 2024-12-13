#!/bin/bash

# Check if correct number of arguments is passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <log_file> <ioc_file>"
    exit 1
fi

# Assign input variables
LOG_FILE=$1
IOC_FILE=$2
OUTPUT_FILE="report.txt"

# Clear the output file if it exists
> "$OUTPUT_FILE"

# Read each IOC line and grep for matches in the log file
while IFS= read -r ioc; do
    grep -- "$ioc" "$LOG_FILE" | awk '{print $1, $4, $5, $7}' | sed 's/\[//;s/\]//' >> "$OUTPUT_FILE"
done < "$IOC_FILE"

# Output results to console
echo "Indicators of Compromise detected:"
cat "$OUTPUT_FILE"
