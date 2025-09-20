#!/usr/bin/env bash
set -eo pipefail

number_to_stream() {
  local split_number exponent
  read -r split_number

  split_number=${split_number//?/& }; exponent=$(wc -w <<< "$split_number")
  split_number=${split_number//? /(&** $exponent) }
  split_number=${split_number//') ('/')+('}

  printf "%s\0" "$split_number"
}

check_armstrong() {
  local -ri input=$1
  read -r -d '' armstrong_sum

  armstrong_sum="$(( armstrong_sum ))"
  [[ "$armstrong_sum" == "$input" ]] && printf 'true\n' || printf 'false\n'
}

main() {
  local -ri input=$1

  [[ $input =~ ^[0-9]+$ && $input -ge 0 ]] \
    || { printf "main(): input must be a number greater or equal to zero.\n" >&2
         exit 1; }

 printf '%s\n' "$input" \
   | number_to_stream \
   | check_armstrong "$input"
}

main "$@"