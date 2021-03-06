#!/bin/bash

PARENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ROOT_DIR="$( cd $PARENT_DIR/.. >/dev/null 2>&1 && pwd )"
MANIFEST_DIR="$( cd $ROOT_DIR/manifest >/dev/null 2>&1 && pwd )"

set -e

COMMANDS=kind,docker
IFS=',' read -a commands <<< ${COMMANDS}
for COMMAND in ${commands[@]}; do
    if ! command -v ${COMMAND} &> /dev/null; then
        echo "Command could not be found: ${COMMAND}"
        exit 1
    fi
done

set -x

kind delete cluster

# delete the nfs server 
docker stop ${NFS_CONTAINER_NAME}
rm -rf ${ROOT_DIR}/${NFS_DATA_DIR}