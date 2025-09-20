#!/usr/bin/env bash

validate_input() {
  local input
  read -r input

  [[ $input =~ ^0+\w+$ ]] &&
    {
      printf "validate_input(): Reenter the number without leading zeroes." >&2
      return 1
    }

  [[ $input =~ ^[0-9]+$ && $input -ge 0 ]] ||
    {
      printf "validate_input(): Number must be a number greater than zero." >&2
      return 1
    }
}

square_of_sums() {
  local input
  read -r input

  sum=$(seq -s' ' 1 "$input")
  sum=${sum// /+}

  printf '%s\n' "$(((sum) ** 2))"
}

sum_of_squares() {
  local input
  read -r input

  sum=$(seq -s' ' 1 "$input")
  sum=${sum//+([0-9])/(&**2)+}
  printf '%s\n' "$((${sum%+}))"
}

difference_of_squares() {
  local input
  read -r input

  printf '%s\n' "$(($(square_of_sums <<<"$input") - $(sum_of_squares <<<"$input")))"
}

main() {
  local mode=$1 input=$2
  shopt -s extglob

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

  shopt -u extglob
}

main "$@"
