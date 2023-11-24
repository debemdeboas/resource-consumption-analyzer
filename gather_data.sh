#!/bin/bash

NOT_ENOUGH_ARGUMENTS=1
DOCKER_COMPOSE_ERROR=2
WRONG_ARGUMENTS=3
INVALID_DIRECTORY=4

# Define a usage function
usage() {
    echo "Usage: $0 '<folder>'"
    echo "  folder: The folder containing the docker-compose.yml file."
}

# Define a function to print an error message and exit with the provided exit code
fatal() {
    # Print the message "FATAL" in red followed by $1
    echo -e "\e[31mFATAL\e[0m: $1"
    exit $2
}

# Define the trap function
cleanup() {
    # Skip popd if we exited via $WRONG_ARGUMENTS
    if [ $? -ne $INVALID_DIRECTORY ]; then
        popd > /dev/null
    fi
    exit
}

# Check if the folder argument is provided
if [ $# -eq 0 ]; then
    usage
    fatal "Please provide the folder path as an argument." $NOT_ENOUGH_ARGUMENTS
fi

# Set the trap to call the cleanup function on script exit
trap cleanup EXIT

REPLICAS=(1 2 5 10 20 50 100 200 300 500)
RUN_AMOUNT_SECONDS=15
LOGS_DIR=`pwd`/logs

# Change the current working directory to the provided folder
# and redirect stderr to stdout
pushd "$1" > /dev/null 2>&1

# Check if pushd was successful
if [ $? -ne 0 ]; then
    fatal "The provided folder does not exist." $INVALID_DIRECTORY
fi

# Check if the docker-compose.yml file exists
if [ ! -f "docker-compose.yml" ]; then
    fatal "The docker-compose.yml file does not exist in the provided folder." $WRONG_ARGUMENTS
fi

# Check if the $LOGS_DIR directory exists. If it does, delete it and create a new one
if [ -d "$LOGS_DIR" ]; then
    rm -rf "$LOGS_DIR"
fi
mkdir "$LOGS_DIR"

for amount in ${REPLICAS[@]}; do
    echo starting $amount client containers

    CLIENT_REPLICAS=$amount docker compose up -d --build

    if [ $? -ne 0 ]; then
        fatal "Docker compose error." $DOCKER_COMPOSE_ERROR
    fi

    SECONDS=0
    while (( SECONDS < $RUN_AMOUNT_SECONDS )); do
        docker stats --no-stream | cat >> $LOGS_DIR/logs_${amount}.csv
    done
    docker compose down
done

exit 0
