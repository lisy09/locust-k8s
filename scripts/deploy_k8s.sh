#!/usr/bin/env bash

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
readonly ROOT_DIR="$( cd $SCRIPT_DIR/.. >/dev/null 2>&1 && pwd )"

environment_name=

usage() {
  echo -n "Usage: ${0} " >&2
  echo -n "--env ENVIRONMENT_NAME, local/production " >&2
  echo >&2
}

while [[ ${#} -gt 0 ]]; do
  parameter="${1}"

  case "${parameter}" in
    --env|-e)
      environment_name="${2}"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Invalid parameter: ${parameter}" >&2
      exit 1
      ;;
  esac

  shift
done

environment_name="${environment_name:-${ENVIRONMENT_NAME}}"

for parameter in environment_name; do
  if [[ -z ${!parameter} ]]; then
    echo "Missing ${parameter}" >&2
    echo >&2
    usage
    exit 1
  fi
done

set -e

source $ROOT_DIR/.env

readonly KUSTOMIZE_DIR=$ROOT_DIR/k8s/kustomize/overlays/${environment_name}

COMMANDS=kubectl,kustomize
IFS=',' read -a commands <<< ${COMMANDS}
for COMMAND in ${commands[@]}; do
    if ! command -v ${COMMAND} &> /dev/null; then
        echo "Command could not be found: ${COMMAND}"
        exit 1
    fi
done

echo ">> Creating k8s resources ..."
kustomize build ${KUSTOMIZE_DIR} | kubectl apply -f -

echo ">> Done!"