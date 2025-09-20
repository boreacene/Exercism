#!/usr/bin/env bash
set -euo pipefail

validate_input() {
  local -r input=$1 span=$2
  
  local -n __err_tag=$3
  [[ $# == 3 ]] || { __err_tag=missing_arg; return 1; }
  [[ $input =~ ^[0-9]*$ && $span =~ ^[0-9\-]*$ ]] || { __err_tag=invalid_char; return 1; }
  [[ $span -lt 0 ]] && { __err_tag=span_negative; return 1; }
  [[ $span -gt 0 ]] || { __err_tag=span_too_small; return 1; }
  [[ ${#input} -ge $span ]] || { __err_tag=span_gt_input; return 1; }
  return 0
}

explain_error() {
  local -r input=$1 span=$2 
  local error_type=$3
  case $error_type in
  #  missing_arg) printf 'Error: too few arguments\n' ;;
  #  invalid_char) printf 'Error: arguments (input: %s; span: %s) must only contain integers\n' "${input:-no input}" "${span:-no input}" ;;
  #  span_too_small) printf 'Error: span (%s) must be greater than 0\n' "$span" ;;
  #  span_gt_input) printf 'Error: length of input (%s) must be greater than span (%s)\n' "${input:-no input}" "${span:-no input}" ;;
    missing_arg) printf 'span must not exceed string length\n' ;;
    invalid_char) printf 'input must only contain digits\n' ;;
    span_too_small) printf 'span must not be negative\n' ;;
    span_gt_input) printf 'span must not exceed string length\n' ;;
    span_negative) printf 'span must not be negative\n'
  esac
}

split_input_by_span() {
  local -r input=$1 span=$2
  local -i series_count

  series_count=${#input}
  series_count=$((series_count - span + 1))
  for ((i = 0; i < series_count; i++)); do
    printf '%s\n' "${input:i:$span}"
  done
}

calc_series_product() {
  local series series_product multiplicator
  while read -r series; do
    case $series in
      *0*) printf '%s\0%s\0' "0" "$series";;
      *)
        series_product=1
        for ((i=0; i < ${#series}; i++)); do
          multiplicator=${series:$i:1}
          series_product=$((series_product * multiplicator))
        done
        printf '%s\0%s\0' "$((series_product))" "$series"
        ;;
    esac
  done
}

keep_highest_product() {
  local new_sp new_series best_sp=0 best_series=0
  while { read -r -d '' new_sp; read -r -d '' new_series; }; do
    [[ $new_sp -gt $best_sp ]] && {
      best_sp="$new_sp"
      best_series="$new_series"
    }
  done
  printf '%s\n' "$best_sp"
  # printf 'Highest Series Product: %s; Series Sequence: %s\n' "$best_sp" "$best_series" >&2
}

main() {
  local -r input=$1 span=$2
  
  local err_tag
  if ! validate_input "$input" "$span" "err_tag"; then
    explain_error "$input" "$span" "$err_tag"
    return 1
  fi
  
  split_input_by_span "$input" "$span" \
  | calc_series_product \
  | keep_highest_product
}

main "$@"