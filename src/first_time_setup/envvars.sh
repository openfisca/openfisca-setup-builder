#!/bin/bash
# @name envvars
# @deps none
# @brief A package for setting the environment variables.

set -euo pipefail

if [[ -z ${JURISDICTION_NAME+A} ]]; then
  readonly JURISDICTION_NAME="${JURISDICTION_NAME:-}"
fi

if [[ -z ${REPOSITORY_URL+A} ]]; then
  readonly REPOSITORY_URL="${REPOSITORY_URL:-}"
fi

if [[ -z ${CI+A} ]]; then
  readonly CI="${CI:-}"
fi

if [[ -z ${DRY_MODE+A} ]]; then
  readonly DRY_MODE="${DRY_MODE:-}"
fi

if [[ -z ${SCRIPT_PATH+A} ]]; then
  readonly SCRIPT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
fi

if [[ -z ${DEV_MODE+A} ]]; then
  if [[ -f "${SCRIPT_PATH}/README.md" ]]; then
    readonly DEV_MODE='false'
  else
    readonly DEV_MODE='true'
  fi
fi

if [[ -z ${ROOT_PATH+A} ]]; then
  if ${DEV_MODE}; then
    readonly ROOT_PATH=$(cd "${SCRIPT_PATH}/../.." && pwd)
  else
    readonly ROOT_PATH=${SCRIPT_PATH}
  fi
fi

if [[ -z ${ROOT_DIR+A} ]]; then
  readonly ROOT_DIR=${ROOT_PATH##*/}
fi
