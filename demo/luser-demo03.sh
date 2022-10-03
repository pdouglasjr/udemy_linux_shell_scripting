#!/bin/bash

# Display the UID and username of the user executing this script.
# Display if the user is the vagrant user or not.

# Display the UID.
echo "Your UID is ${UID}"

# Only display if the UID does NOT match 1000.
UID_TO_TEST_FOR='1000'
if [[ "${UID}" -ne ${UID_TO_TEST_FOR} ]]
then
	echo "Your UID does not match ${UID_TO_TEST_FOR}."
	exit 1
fi

# Display the username.
USERNAME=$(id -nu 2>&1)
echo "Your username is ${USERNAME}"

# Test if the command succeeded.
if [[ "${?}" -ne 0 ]]
then
	echo 'The id command did not execute successfully'
	exit 1
fi

# You can use a string test conditional.
USERNAME_TO_TEST_FOR='vagrant'
if [[ "${USERNAME}" = "${USERNAME_TO_TEST_FOR}" ]]
then
	echo "Your username matches ${USERNAME_TO_TEST_FOR}"
fi

# Test for != (not equal) for the string.
if [[ "${USERNAME}" != "${USERNAME_TO_TEST_FOR}" ]]
then
	echo "Your username does not match ${USERNAME_TO_TEST_FOR}"
	exit 1
fi

# Exit script successfully
exit 0
