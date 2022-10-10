#!/bin/bash

# This script generates a random password.

# Arguments:
# 	-l 	set the password length
# 	-s	add a special character
#	-v	enable verbose mode

# Set a default password length
LENGTH=48

usage() {
	echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
	echo 'Generate a random password.'
	echo '	-l LENGTH	Specify the password length.'
	echo '	-s		Append a special charater to the password.'
	echo ' 	-v		Increase verbosity.'
	exit 1
}

log() {
	local MESSAGE="${@}"
	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "${MESSAGE}"
	fi
	logger -t "$(basename ${0})" "${MESSAGE}"
}

# -l is a mandatory option
while getopts vl:s OPTION
do
	case ${OPTION} in
		v)
			VERBOSE='true'
			log 'Verbose mode on.'
			;;
		l)
			LENGTH="${OPTARG}"
			;;
		s)
			USE_SPECIAL_CHARACTER='true'
			;;
		?)
			usage
			;;
	esac
done

# Remove the options while leaving the remaining arguments.
shift "$(( OPTIND - 1 ))"

if [[ "${#}" -gt 0 ]]
then
	usage
fi

log 'Generating a password.'

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c${LENGTH})

# Append a special character if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" = 'true' ]]
then
	log 'Selecting a random special character.'
	SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -1c)
	PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'Here is the password:'

# Display the password.
echo -e "\t${PASSWORD}"

exit 0
