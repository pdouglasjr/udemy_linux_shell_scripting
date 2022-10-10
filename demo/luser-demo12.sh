#!/bin/bash

# This script deletes a user.

# Run as root.
if [[ "${UID}" -ne 0 ]]
then
	echo "$(basename ${0}): Must have superuser privileges to execute this script."
	exit 1
fi

# Assume the first argument is the user to delete.
USER="${1}"

# Delete the user
userdel ${USER}

# Make sure the user got deleted
if [[ "${?}" -ne 0 ]]
then
	echo "$(basename ${0}): The account ${USER} was NOT delted." >&2
	exit 2
fi

# Tell the user the account was deleted
echo "The account ${USER} was deleted."

exit 0
