#!/usr/bin/env bash
set -eo pipefail

validate_input() {
  local -n __err_tag="$1"
  local input="$2"
  shift 2

  (( $# > 1 )) && { __err_tag=too_many_arguments; return 1; }
  [[ -n $input ]] || { __err_tag=no_input; return 1; }
  [[ $input != *[.]* ]] || { __err_tag=no_floats; return 1; }
  [[ $input != *[a-zA-Z]* ]] || { __err_tag=no_alpha; return 1; }
  [[ $input != *' '* ]] || { __err_tag=too_many_arguments; return 1; }

  return 0
}

explain_err() {
  local -r err_tag=$1
  case $err_tag in
    no_input) printf 'Usage: leap.sh <year>\n' ;;
    too_many_arguments) printf 'Usage: leap.sh <year>\n' ;;
    no_floats) printf 'Usage: leap.sh <year>\n' ;;
    no_alpha) printf 'Usage: leap.sh <year>\n' ;;
  esac
}

is_leap_year() {
  local -r input=$1
  case $input in
    *00) (( (input % 400) == 0 )) && printf 'true\n' || printf 'false\n' ;;
    *) (( (input % 4) == 0 )) && printf 'true\n' || printf 'false\n' ;;
  esac
}

main() {
  local -r input="$1"
  local err_tag

  if ! validate_input "err_tag" "$input"  "$@" ;
    then explain_err "$err_tag"
    return 1
  fi

  is_leap_year "$1"
}

main "$@"