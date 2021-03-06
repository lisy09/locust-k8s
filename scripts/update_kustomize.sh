#!/usr/bin/env bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly ROOT_DIR="$( cd $SCRIPT_DIR/.. >/dev/null 2>&1 && pwd )"
readonly KUSTOMIZE_DIR=$ROOT_DIR/k8s/kustomize
readonly KUSTOMIZE_BASE_DIR=$KUSTOMIZE_DIR/base
readonly CMFILES_DIR=configmap-from-files
readonly KUSTOMIZE_BASE_CMFILES_DIR=$KUSTOMIZE_BASE_DIR/$CMFILES_DIR

readonly ENV_FILE=$ROOT_DIR/.env
source $ENV_FILE

COMMANDS=kustomize
IFS=',' read -a commands <<< ${COMMANDS}
for COMMAND in ${commands[@]}; do
    if ! command -v ${COMMAND} &> /dev/null; then
        echo "Command could not be found: ${COMMAND}"
        exit 1
    fi
done

set -e
set -x

# update locust main file as configmap to avoid docker image update
cp $ROOT_DIR/locustfiles/main.py $KUSTOMIZE_BASE_CMFILES_DIR/locustfiles

cd ${KUSTOMIZE_BASE_DIR}
# reset generated base/kustomization.yaml
cp kustomization_base.yaml kustomization.yaml

# update base/kustomization.yaml with configmap auto generated from files
for dirpath in ${KUSTOMIZE_BASE_CMFILES_DIR}/*; do
    dirname="$(basename $dirpath)"
    kustomize edit add configmap $dirname --from-file=$CMFILES_DIR/$dirname/*
done

# update base/kustomization.yaml with resources
kustomize edit add resource configmap/*
kustomize edit add resource deployment/*
kustomize edit add resource statefulset/*
kustomize edit add resource service/*
kustomize edit add resource ingress/*