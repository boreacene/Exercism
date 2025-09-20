#!/usr/bin/env bash

validate_input() {
  local input
  read -r input

  [[ $input =~ ^[0-9]+$ ]] ||
    {
      printf "validate_input(): Number must be a positive integer." >&2
      exit 1
    }

  [[ $input =~ ^0+[a-zA-Z0-9]+$ ]] &&
    {
      printf "validate_input(): Enter a number without leading zeroes." >&2
      exit 1
    }
}

square_of_sums() {
  local input sq_sm
  read -r input

  sq_sm=$(seq -s+ 1 "$input")
  printf '%s\n' "$(((sq_sm) ** 2))"
}

sum_of_squares() {
  local input sm_sq
  read -r input

  sm_sq=$(seq -s**2+ 1 "$input")
  printf '%s\n' "$((${sm_sq/%?/&**2}))"
}

difference_of_squares() {
  local input
  read -r input

  printf '%s\n' "$(($(square_of_sums <<<"$input") - $(sum_of_squares <<<"$input")))"
}

main() {
  local mode=$1 input=$2
  validate_input <<<"$input"

  case $mode in
    square_of_sum) square_of_sums <<<"$input" ;;
    sum_of_squares) sum_of_squares <<<"$input" ;;
    difference) difference_of_squares <<<"$input" ;;
    *)
      printf 'main(): Invalid mode entered.' >&2
      exit 1
      ;;
  esac
}

main "$@"