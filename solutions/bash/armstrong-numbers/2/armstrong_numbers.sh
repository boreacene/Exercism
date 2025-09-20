#!/usr/bin/env bash
set -eo pipefail

input_to_expr() {
  local expr=$1 number_to_split=$2
  number_to_split=${number_to_split//?/(&**exponent)+} 

  printf -v "$expr" '%s' "${number_to_split%+}"
}

main() {
  local -r input=$1
  [[ $input =~ ^[0-9]+$ && $input -ge 0 ]] \
    ||{ printf "main(): input must be a number greater or equal to zero.\n" >&2
        exit 1; }

  local expression exponent
  input_to_expr expression "$input"

  exponent=${#input}
  expression=${expression//exponent/$exponent}
  
  (( (expression) == input )) && printf 'true\n' || printf 'false\n'
}

main "$@"
