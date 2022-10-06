#!/bin/sh

# This script adds users to the Linux system that it is executed on.

# Name of this script
SCRIPT=$(basename ${0})

# Make sure the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]
then
	echo "Must execute this script with superuser privileges"
	exit 1
fi

# Check that user has supplied at least one argument to the script
if [[ "${#}" -eq 0 ]]
then
	echo "Usage: ${SCRIPT} USERNAME [COMMENT_1 ... COMMENT_N]"
	exit 2
fi

# Grab the username
USERNAME=${1}
shift

# Grab the comments, if any
COMMENTS=${@}

# Generate a password
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | cut -d' ' -f1 | head -c48)

# Create the user with the password
useradd -c "${COMMENT}" ${USERNAME} 2>/dev/null

# Check to see if the useradd command succeeded
if [[ "${?}" -ne 0 ]]
then
	echo "${SCRIPT}: Unable to create account for '${USERNAME}'"
	exit 3
fi

# Set the password
echo "{$PASSWORD}" | passwd --stdin "${USERNAME}"

# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo "${SCRIPT}: Unable to set password for '${USERNAME}'"
	exit 4
fi

# Force password change on first login.
passwd -e "${USERNAME}"

# Check if the password change enforcement was successful
if [[ "${?}" -ne 0 ]]
then
	echo "${SCRIPT}: Unable to enforce password change upon initial login by '${USERNAME}'"
	exit 5
fi

# Display the username, password, and the host where the user was created.
echo "Username: ${USERNAME}"
echo "Password: ${PASSWORD}"
echo "Host: ${HOSTNAME}"

# Exit script gracefully
exit 0
