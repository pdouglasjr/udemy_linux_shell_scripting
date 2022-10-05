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

# A better password.
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo "${PASSWORD}"

# An even better password.
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo "${PASSWORD}"

# Append a special character to the password.
SPECIAL_CHARACTER=$(echo '!@#$%^&*()_-+=' | fold -w1 | shuf | head -1c)
echo "${PASSWORD}${SPECIAL_CHARACTER}"
