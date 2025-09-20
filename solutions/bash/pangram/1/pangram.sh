#!/usr/bin/env bash
set -eo pipefail

validate_input() {
  local -n __err_tag="$1"
  local input="$2"
  shift 2
  
  (( $# > 1 )) && { __err_tag=too_many_arguments; return 1; }

  return 0
}

explain_err() {
  local err_tag="$1"

  case "$err_tag" in
    too_many_arguments) printf 'Error: too many arguments provided' ;;
    *) printf 'Error: unknown error type' ;;
  esac
}

sanitize_input() {
  local -r input=$1
  sentence=${input^^}
  sentence=${sentence//[!A-Z]}
  
  printf '%s\n' "$sentence"
}

check_pangram() {
  local sentence
  read -r sentence

  local char unique_count
  local -A seen

  for ((i=0; i < ${#sentence}; i++)); do
    char=${sentence:i:1}
    seen[$char]="1"
  done

  unique_count=${#seen[@]}
  (( unique_count >= 26 )) && printf 'true\n' || printf 'false\n'
}

main() {
  local -r input="$1"
  local err_tag

  if ! validate_input "err_tag" "$input" "$@"; then 
      explain_err "$err_tag"
      return 1
  fi
  
  sanitize_input "$input" | check_pangram
}

main "$@"