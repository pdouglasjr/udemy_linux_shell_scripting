#!/bin/bash

# This script will add a user to the Linux system that it is executed on.

# Variables
SCRIPT_NAME=$(basename ${0})
ERROR_LOG="error.log"
OUTPUT_LOG="output.log"

if [[ ! -e ${ERROR_LOG} ]]
then
	touch ${ERROR_LOG}
fi

if [[ ! -e ${OUTPUT_LOG} ]]
then
	touch ${OUTPUT_LOG}
fi

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
	echo "${SCRIPT_NAME}: Must be executed with superuser privileges"
	exit 1
fi

# If the user doesn't supply at least one argument, then give them help.
if [[ "${#}" -eq 0 ]]
then
	echo "Usage: ${SCRIPT_NAME} USERNAME [COMMENT_1 ... COMMENT_2]"
	exit 2
fi

# The first parameter is the user name.
# Grab the user name
USERNAME=${1}

# Shift the parameters over by 1
shift

# The rest of the parameters are for the account comments.
COMMENTS=${@}

# Generate a password.
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | cut -d' ' -f1 | head -c48)

# Create the user with the password.
useradd -c "${COMMENT}" ${USERNAME} 2>> ${ERROR_LOG} 1>> ${OUTPUT_LOG}

# Check to see if the useradd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo "${SCRIPT_NAME}: Unable to create account for '${USERNAME}'"
	exit 3
fi

# Set the password.
echo "${PASSWORD}" | passwd --stdin "${USERNAME}" 2>> ${ERROR_LOG} 1>> ${OUTPUT_LOG}

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo "${SCRIPT_NAME}: Unable to set the password for '${USERNAME}'"
	exit 4
fi

# Force password change on first login.
passwd -e ${USERNAME} 2>> ${ERROR_LOG} 1>> ${OUTPUT_LOG}

if [[ "${?}" -ne 0 ]]
then
	echo "${SCRIPT_NAME}: Unable to enforce password change on initialize login for '${USERNAME}'"
	exit 5
fi

# Display the username, password, and the host where the user was created.
echo "Username: ${USERNAME}"
echo "Password: ${PASSWORD}"
echo "Host: ${HOSTNAME}"

# Clean up
COMMENTS=
ERROR_LOG=
OUTPUT_LOG=
PASSWORD=
SCRIPT_NAME=
USERNAME=

exit 0
