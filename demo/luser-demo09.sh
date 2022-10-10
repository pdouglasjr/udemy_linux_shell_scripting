#!/bin/bash

# This script demonstrates the case statement.

#if [[ "${1}" = 'start' ]]
#then
#	echo 'Starting...'
#elif [[ "${1}" = 'stop' ]]
#then
#	echo 'Stopping...'
#elif [[ "${1}" = 'status' ]]
#then
#	echo "STATUS: "
#else
#	echo 'Supply a valid option.' >&2
#	exit 1
#fi

case "${1}" in
	start) echo 'Starting...' ;;
	stop) echo 'Stopping...' ;;
	state|status|--state|--status) echo "STATUS: ";;
	*)
		echo 'Supply a valid options.' >&2
		;;
esac

exit 0
