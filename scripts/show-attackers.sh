#!/bin/bash

# This script displays the number of failed login attempts by IP address and location.

# Grab the input file
LOG_FILE="${1}"

# Check if file exists
if [[ ! -e "${LOG_FILE}" ]]
then
	echo "Cannot open file." >&2
	exit 1
fi


