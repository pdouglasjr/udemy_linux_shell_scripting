#!/bin/bash

# This script adds a user to the Linux system the script is executed on

# Ask for the username.
read -p 'Enter the username to create: ' USERNAME

# Ask for the full name of the account owner.
read -p 'Enter the full name of the account owner: ' COMMENT

# Ask for the password
read -srep 'Enter the password to use for the account: ' PASSWORD
echo

# Create the user account.
useradd -c "${COMMENT}" -m ${USERNAME}

if [[ "${?}" -ne 0 ]]
then
	echo "Unable to create user account for '${USERNAME}'"
	exit 1
fi

# Set the initial password for the user account
echo "${PASSWORD}" | passwd --stdin ${USERNAME}

if [[ "${?}" -ne 0 ]]
then
	echo "Unable to set the initial password for '${USERNAME}'"
	exit 2
fi

# Force the user to change the password upon first login
passwd -e ${USERNAME}

if [[ "${?}" -ne 0 ]]
then
	echo "Unable to enforce password change upon initial login by '${USERNAME}'"
	exit 3
fi

# Display the username, password, and the host where the user was created.
echo "User account has been created!"
echo "=============================="
echo "Username: ${USERNAME}"
echo "Password: ${PASSWORD}"
echo "Hostname: ${HOSTNAME}"
