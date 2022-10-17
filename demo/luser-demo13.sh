#!/bin/bash

# This script shows the open network ports on a system
# Use -4 as an argument to limit to tcpv4 ports.

if [[ "${1}" = '-4' ]]
then
	netstat -nutl ${1} | grep ':' | awk '{print $4}' | awk -F ':' '{print $NF}'
else
	exit 1
fi

exit 0
