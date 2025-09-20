#!/usr/bin/env bash
set -euo pipefail

function validate_input {
  local -r input=$1
  [[ "$input" =~ ^[1-9]$ || "$input" =~ ^[1-5][0-9]$ || "$input" =~ ^6[0-4]$ || "$input" =~ ^total$ ]] || return 1
  return 0
}

function calc_grains {
  local -r input=$1

  case "$input" in
    [1-9] | [1-5][0-9] | 6[0-4])
      printf '%s\n' "$(bc <<<"(2^($input-1))")"
      ;;
    total)
      printf '%s\n' "$(bc <<<"((2 ^ 64)-1)")"
      ;;
  esac
}

function main {
  local -r input=${1-0}

  if ! validate_input "$input"; then
    printf 'Error: invalid input'
    return 1
  fi

  if ! calc_grains "$input"; then
    printf 'Error: Invalid input'
    return 1
  fi
}

main "$@"
