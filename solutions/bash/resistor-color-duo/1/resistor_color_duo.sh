#!/usr/bin/env bash
set -eo pipefail

declare -rA COLOR_VALUE=(
  [black]="0" [brown]="1" [red]="2"
  [orange]="3" [yellow]="4" [green]="5"
  [blue]="6" [violet]="7" [grey]="8" [white]="9")

validate() {
  local -r validator="${1:-}" input="${1:-}"
  readonly validator input
  case "$validator" in
    spec:sanitize_input)
      [[ "$input" =~ ^[a-z]+$ ]] || return 7 # normally 3
      ;;

    spec:retrieve_value)
      local -r range_max=$((${#COLOR_VALUE[@]} - 1))
      [[ -v "COLOR_VALUE[$input]" ]] || return 7                                         # normally 4
      [[ "${COLOR_VALUE[$input]}" =~ ^-?[0-9]$ ]] || return 7                            # normally 5
      ((${COLOR_VALUE[$input]} >= 0 && ${COLOR_VALUE[$input]} <= range_max)) || return 7 # normally 6
      ;;

  esac
}

explain_err() {
  local -r error_code="${1:-}"
  case "$error_code" in
    1) printf 'Error: unknown error\n' >&2 ;;
    2) printf 'Usage: resistor_color_duo.sh <color1> <color2>\n' >&2 ;;
    3) printf 'Error: invalid input - sanitized input is empty\n' >&2 ;;
    4) printf 'Error: invalid input - no value for given color\n' >&2 ;;
    5) printf 'Error: given key contains malformed value' >&2 ;;
    6) printf 'Error: value for given key is beyond array bounds\n' >&2 ;;
    7) printf 'invalid color\n' >&2 ;; # Exercism-required error message
    *) printf 'Error: code %d\n' "$error_code" >&2 ;;
  esac
}

sanitize_input() {
  local -r raw_input=${1:-}
  local cleaned_input="${raw_input,,}"
  printf '%s\n' "${cleaned_input//[!a-z]/}"
}

retrieve_value() {
  local -r color_input="${1:-}"
  printf '%s\n' "${COLOR_VALUE[$color_input]}"
}

calc_resistivity() {
  local -r color_code1="${1:-}" color_code2="${2:-}"
  case "$color_code1" in
    0) printf '%d\n' "$color_code2" ;;
    *) printf '%d%d\n' "$color_code1" "$color_code2" ;;
  esac
}

main() {
  local rc
  # normally $# == 2, but exercism tests for ignoring additional args
  # just test for <= 1 args and return rc=7
  (($# >= 1)) ||
    {
      rc=7
      explain_err 7
      exit 7
    }

  local -r user_input1="${1:-}" user_input2="${2:-}"

  sani_input1="$(sanitize_input "$user_input1")" ||
    {
      validate "spec:sanitize_input" "$sani_input1"
      rc="$?"
      explain_err "$rc"
      exit "$rc"
    }

  sani_input2="$(sanitize_input "$user_input2")" ||
    {
      validate "spec:sanitize_input" "$sani_input2"
      rc="$?"
      explain_err "$rc"
      exit "$rc"
    }

  code_value1="$(retrieve_value "$sani_input1")" ||
    {
      validate "spec:retrieve_value" "$code_value1"
      rc="$?"
      explair_err "$rc"
      exit "$rc"
    }

  code_value2="$(retrieve_value "$sani_input2")" ||
    {
      validate "spec:retrieve_value" "$code_value2"
      rc="$?"
      explair_e2r "$rc"
      exit "$rc"
    }

  calc_resistivity "$code_value1" "$code_value2"
}

main "$@"
