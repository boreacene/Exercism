#!/usr/bin/env bash
set -euo pipefail

validate_input() {
  local -r input=$1
  [[ "$input" =~ ^0+.+$ ]] && return 1
  [[ "$input" =~ ^[1-9]$ || "$input" =~ ^[1-5][0-9]$ || "$input" =~ ^6[0-4]$ || "$input" =~ ^total$ ]] || return 1
  return 0
}

calc_grains() {
  local -r input=$1

  case "$input" in
    total)
      printf '%s\n' "$(bc <<<"((2 ^ 64)-1)")"
      ;;
    *)
      printf '%s\n' "$(bc <<<"((2 ^ ($input - 1)))")"
      ;;
  esac
}

function main {
  local -r input=${1-0}

  if ! validate_input "$input"; then
    printf 'Error: invalid input' 1>&2
    return 1
  fi

  calc_grains "$input"
}

main "$@"
