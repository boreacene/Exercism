#!/usr/bin/env bash
set -eo pipefail

declare -ra VALUE_COLOR=( \
  "black" "brown" "red" \
  "orange" "yellow" "green" \
  "blue" "violet" "grey" "white" )
  
declare -rA COLOR_VALUE=( \
  [black]="0" [brown]="1" [red]="2" \
  [orange]="3" [yellow]="4" [green]="5" \
  [blue]="6" [violet]="7" [grey]="8" [white]="9" )

validate() {
   local -r caller="${1:-}" input="${2:-}"
   case "$caller" in
    _main)
      local -r valid_modes='^(code|colors)$'
      [[ "$input" =~ $valid_modes ]] || return 2
    ;;
      
    _sanitize_input)
      [[ -n "$input" ]] || return 5
      [[ "$input" =~ ^[a-z]+$ ]] || return 4
    ;;
      
    _color_to_value)
      (( ${COLOR_VALUE[$input]} >= 0 && ${COLOR_VALUE[$input]} <= 9 )) || return 3
    ;;
  esac
}

explain_err() {
  local return_code="${1:-0}"
  case "$return_code" in
    1) printf 'Error: unknown error\n' >&2 ;;
    2) printf 'Usage: resistor.sh [ code <color> | colors ]\n' >&2 ;;
    3) printf 'Error: invalid code color given\n' >&2 ;;
    4) printf 'Error: unable to sanitize input\n' >&2 ;;
    5) printf 'Error: sanitized input is empty\n' >&2 ;;
    *) printf 'Error: unknown error, unknown error code.\n' >&2 ;;
  esac
}

sanitize_input() {
  local input="${1:-}"
  input="${input,,}"
  input="${input//[^a-z]}"
  printf '%s' "$input"
}

color_to_value() {
  local code_color="${1:-}"
  printf '%s\n' "${COLOR_VALUE[$code_color]}"
  }

list_colors() {
  printf '%s\n' "${VALUE_COLOR[@]}"
}

main() {
  local rc
  (( $# <= 0 || $# >= 3 )) && { rc=2; explain_err "$rc"; exit "$rc"; }
  local -r mode_input="${1:-}" code_input="${2:-}"
  
  local mode_cleaned
  mode_cleaned="$(sanitize_input "$mode_input")"
  validate "_sanitize_input" "$mode_cleaned" || { rc=$?; explain_err "$rc"; exit "$rc"; }
  validate "_main" "$mode_cleaned" || { rc=$?; explain_err "$rc"; exit "$rc"; }
  
  case "$mode_cleaned" in
    colors) 
      (( "$#" == 1 )) || { rc=2; explain_err "$rc"; exit "$rc"; }
      list_colors 
    ;;
    
    code)
      (( "$#" == 2 )) || { rc=2; explain_err "$rc"; exit "$rc"; }
      local code_color
      code_color="$(sanitize_input "$code_input")"
      validate "_sanitize_input" "$code_color" || { rc=$?; explain_err "$rc"; exit "$rc"; }
      validate "_color_to_value" "$code_color" || { rc=$?; explain_err "$rc"; exit "$rc"; }
      color_to_value "$code_color" 
    ;;
    
    *) 
      rc=2
      explain_err "$rc"
      exit "$rc"
    ;;
  esac
}

main "$@"