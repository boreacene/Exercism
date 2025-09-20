#!/usr/bin/env bash
set -eo pipefail

validate_input() {
  local -r input="$1"
  shift
  
  (( $# > 0 )) && return 10
  [[ -n "$input" ]] || return 11
  [[ "$input" =~ ^[+-]?[0-9]+$ ]] || return 12

  return 0
}

explain_err() {
  local -r exit_status="$1"

  case "$exit_status" in
    10) printf 'Error: too many arguments provided\n' >&2 ; return "$exit_status" ;;
    11) printf 'Error: input not given\n' >&2; return "$exit_status" ;;
    12) printf 'Error: input not an integer\n' >&2; return "$exit_status" ;;
    *) printf 'Error: unknown error type (%d)\n' "$exit_status" >&2; return "$exit_status" ;;
  esac
}

plingplangplong() {
  local -r input="$1"
  local result

  result=""
  (( input % 3 == 0 )) && result+="Pling"
  (( input % 5 == 0 )) && result+="Plang"
  (( input % 7 == 0 )) && result+="Plong"

  [[ -n "$result" ]] && printf '%s\n' "$result" || printf '%s\n' "$input"
}


main() {
  local -r input="$1"

  validate_input "$input" "${@:2}" || { explain_err $? ; return $?; }
  
  plingplangplong "$input"
}

main "$@"