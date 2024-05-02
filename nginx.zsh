#!/bin/zsh

# Define the log file location
LOG_FILE="access.log"

# Check if the log file exists
if [[ ! -f $LOG_FILE ]]; then
    echo "Log file does not exist: $LOG_FILE"
    exit 1
fi

# Initialize an associative array to hold the count of each response code
typeset -A response_codes

# Read through the log file
while read line; do
    # Extract the method, path, and status code
    method=$(echo $line | awk '{print $6}' | tr -d '"')
    path=$(echo $line | awk '{print $7}')
    status_code=$(echo $line | awk '{print $9}')

    # Check if the line corresponds to the POST request to /api/uploads
    if [[ "$method" == "POST" && "$path" == "/api/uploads" ]]; then
        # Increment the count for this status code
        ((response_codes[$status_code]++))
    fi
done < $LOG_FILE

# Print the results
echo "Response Code Counts for POST /api/uploads:"
for code in ${(k)response_codes}; do
    echo "Status Code $code: $response_codes[$code]"
done
