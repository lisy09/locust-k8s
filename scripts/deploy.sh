#!/usr/bin/env bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly ROOT_DIR="$( cd $SCRIPT_DIR/.. >/dev/null 2>&1 && pwd )"

readonly ENV_FILE=$ROOT_DIR/.env
source $ENV_FILE

COMMANDS=docker-compose
IFS=',' read -a commands <<< ${COMMANDS}
for COMMAND in ${commands[@]}; do
    if ! command -v ${COMMAND} &> /dev/null; then
        echo "Command could not be found: ${COMMAND}"
        exit 1
    fi
done

set -e
set -x

NUM_LOCUST_WORKERS=${worker:-1}

cd ${ROOT_DIR} && docker-compose --env-file $ENV_FILE \
    -f docker-compose.yml up -d \
    --scale locust-worker=${NUM_LOCUST_WORKERS}