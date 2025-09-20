#!/usr/bin/env bash
set -euo pipefail

validate_input() {
	local input
	read -r input

  [[ $input =~ ^0{1,}\w.* ]] \
    &&{ printf "validate_input(): remove leading zeroes from input.\n" >&2
        return 1; }
  [[ $input =~ ^[0-9]+$ && $input -ge 0 ]] \
    ||{ printf "validate_input(): input must be a number greater or equal to zero.\n" >&2
        return 1; }
	
	printf '%s\0' "$input"
}

input_to_expr() {
  local input expression exponent
	read -r -d '' input
	exponent=${#input}; readonly exponent
  expression=${input//?/(&**$exponent)+}

  printf '%s\0%s\0' "$input" "${expression%+}"
}

check_if_armstrong() {
	local input expression
	read -r -d '' input
	read -r -d '' expression
	readonly input expression

 	(( (expression) == input )) \
 		&& printf 'true\n' || printf 'false\n'
}

main() {
  local -r input=$1

  validate_input <<< "$input" \
  	| input_to_expr \
  	| check_if_armstrong
}

main "$@"