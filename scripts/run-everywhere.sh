#!/bin/bash

# This script executes a given command on multiple servers.

# FUNCTIONS
log() {
        local MESSAGE="${1}"
        if [[ "${VERBOSE_MODE}" -eq 1 ]]
        then
                echo "${MESSAGE}"
        fi
        logger -t "$(basename ${0})" "${MESSAGE}"
}

usage() {
        echo -e 'Do not execute this script as root. Use the -s option instead'
        echo "Usage: ${0} [-nsv] [-f FILE] COMMAND"
        echo 'Executes COMMAND as a single command on every server'
        echo -e '\t-f FILE\t Use FILE for the list of servers. Default file is /vagrant/servers'
        echo -e '\t-n\tDry run mode. Display the COMMAND that would have been exected and exit'
        echo -e '\t-s\tExecute the COMMAND using sudo on the remote server'
        echo -e '\t-v\tVerbose mode. Displays the server name before executing COMMAND'
        exit 1
}

# ARGUMENT VARIABLES
SERVER_LIST="/vagrant/servers"
DRY_RUN=0
SUDO=
VERBOSE_MODE=0
COMMAND=
SSH_OPTIONS='-o ConnectTimeout=2'
SSH_COMMAND=
SSH_EXIT_STATUS=
EXIT_STATUS=0

# Make sure that script is not executed as root
if [[ "${UID}" -eq 0 ]]
then
        VERBOSE_MODE=1
        log "Script must be executed with by a non-privileged user. Specify the -s option to have remote commands executed with superuser privileges."
        log "Exiting script."
fi

while getopts fnsv OPTION
do
        case ${OPTION} in
                f)
                        SERVER_LIST="${OPTARG}"
                        ;;
                n)
                        DRY_RUN=1
                        ;;
                s)
                        SUDO='sudo'
                        ;;
                v)
                        VERBOSE_MODE=1
                        log 'Verbose mode on.'
                        ;;
                ?)
                        usage
                        ;;

        esac
done 2>/dev/null

# Remove the options while leaving the remaining arguments
shift "$(( OPTIND - 1))"

# Print usage information to screen if no command is provided
if [[ "${#}" -lt 1 ]]
then
        usage
fi

# Anything that remains on the command line is to be treated as a single command
COMMAND="${@}"

# Check if provided file exists
if [[ ! -e "${SERVER_LIST}" ]]
then
        VERBOSE_MODE=1
        log "Cannot open server list file ${SERVER_LIST}." >&2
        exit 1
fi

for SERVER in $(cat ${SERVER_LIST})
do
        SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"

        if [[ "${DRY_RUN}" -eq 1 ]]
        then
                echo "DRY RUN: ${SSH_COMMAND}"
        else
                # Execute 'hostname' command on remote server
                ${SSH_COMMAND} 2>/dev/null
                SSH_EXIT_STATUS="${?}"

                # Capture any non-zero exit status from the SSH_COMMAND and report to the user.
                if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]
                then
                        EXIT_STATUS="${SSH_EXIT_STATUS}"
                        VERBOSE_MODE=1
                        log "Execution on ${SERVER} failed."
                fi
        fi

done < $SERVER_LIST

exit "${EXIT_STATUS}"
