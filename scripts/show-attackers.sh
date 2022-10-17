#!/bin/bash

# This script displays the number of failed login attempts by IP address and location.
# If there are any IPs with over LIMIT failures, display the count, IP, and location

LIMIT=10
LOG_FILE="${1}"

# Check if file exists
if [[ ! -e "${LOG_FILE}" ]]
then
	echo "Cannot open log file: ${LOG_FILE}" >&2
	exit 1
fi

# Loop through the list of failed attempts and corresponding IP addresses.
grep Failed "${LOG_FILE}"| awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read COUNT IP
do
	# If the number of failed attempts is greater than the limit, display count, IP and location.
	if [[ "${COUNT}" -gt "${LIMIT}" ]]
	then
		LOCATION=$(geoiplookup ${IP} | awk -F ", " '{print $NF}')
		echo "${COUNT},${IP},${LOCATION}"
	fi
done
