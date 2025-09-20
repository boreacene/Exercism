#!/usr/bin/env bash
set -eo pipefail

validate_input() {
  local input="$1"
  shift
  
  (( $# > 0 )) && return 10
  # [[ -n "$input" ]] || return 11

  return 0
}

explain_err() {
  local err_tag="$1"

  case "$err_tag" in
    10) printf 'Error: too many arguments provided\n' ;;
    11) printf 'Error: input not given\n' ;;
    *) printf 'Error: unknown error type\n' ;;
  esac
}

sanitize_input() {
  local -r input="$1"
  local sentence
  sentence="${input^^}"
  sentence="${sentence//[!A-Z]}"
  
  printf '%s\n' "$sentence"
}

check_pangram() {
  local sentence
  read -r sentence

  local char unique_count
  local -A seen

  for ((i=0; i < ${#sentence}; i++)); do
    char="${sentence:i:1}"
    seen[$char]="1"
  done

  unique_count="${#seen[@]}"
  (( unique_count >= 26 )) && printf 'true\n' || printf 'false\n'
}

main() {
  local -r input="$1"
  local err_tag

  validate_input "$input" "${@:2}" || { explain_err $?; return 1; }
  sanitize_input "$input" | check_pangram
}

main "$@"