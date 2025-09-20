#!/usr/bin/env bash
set -eo pipefail


function usage_exit {
  printf '%s\n' "Usage: error_handling.sh <person>"
  exit 1
}

function validate_arguments {
  [[ $# -gt 1 || $# == 0 ]] && usage_exit
  
  return 0  
}

function main {
  local input=$1

  validate_arguments "$@"

  printf '%s\n' "Hello, $input"
}

main "$@"