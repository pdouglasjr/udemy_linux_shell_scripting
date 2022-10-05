#!/bin/bash

# This script generates a list of random passwords.

# A random number a password.
# $RANDOM is an internal Bash function that returns a pseudorandom integer between 0 - 32767
PASSWORD="${RANDOM}"
echo "${PASSWORD}"

# Three random numbers together.
PASSWORD="${RANDOM}${RANDOM}${RANDOM}"
echo "${PASSWORD}"

# Use the current date/time as the basis for the password.
PASSWORD=$(date +%s)
echo "${PASSWORD}"

# Use nanoseconds to act as randomization
PASSWORD=$(date +%s%N)
echo "${PASSWORD}"
