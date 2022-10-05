#!/bin/bash

# This script generates a random password for each user specified on the command line.

# Display what the user typed on the command line.
echo "You executed this command: ${0}"

# Display the path and filename of the script.
echo "You used $(dirname ${0}) as the path to the $(basename ${0}) script."

# Tell them how many arguments they passed in.
# (Inside the script they are parameters, outside they are arguments.)
NUMBER_OF_PARAMETERS="${#}" 
echo "You supplied ${NUMBER_OF_PARAMETERS} arguments(s) on the command line."

# Make sure they at least supply one argument.
if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
	echo "Usage: ${0} USERNAME [USERNAME ... USERNAME]"
	exit 1
fi

# Generate and display a password for each parameter.
for USERNAME in "${@}"
do
	PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
	echo "${USERNAME}: ${PASSWORD}"
done

exit 0
