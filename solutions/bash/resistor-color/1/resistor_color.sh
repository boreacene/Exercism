#!/usr/bin/env bash
set -euo pipefail

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
      local valid_modes='^(code|colors)$'
      declare -r valid_modes
      [[ "$input" =~ $valid_modes ]] || { explain_err 2; return 2; }
      ;;
      
    _sanitize_input)
      [[ $input =~ ^[a-z]+$ ]] || { explain_err 4; return 4; }
      ;;
      
    _color_to_value)
      local valid_codes
      IFS='|' valid_codes="^(${VALUE_COLOR[*]})$"; unset IFS
      declare -r valid_codes
      [[ "$input" =~ $valid_codes ]] || { explain_err 3; return 3; }
      ;;
  esac
}

explain_err() {
  local return_code="${1:-0}"
  case "$return_code" in
    0) printf 'Success\n' >&2 ;;
    1) printf 'Error: unknown error\n' >&2 ;;
    2) printf 'Usage: "code <color>" | "colors"\n' >&2 ;;
    3) printf 'Error: invalid code color given\n' >&2 ;;
  esac
}

sanitize_input() {
  local input="${1:-}"
  input="${input,,}"
  input="${input//[^a-z]}"

  # check input before returning to stdout
  validate "_sanitize_input" "$input"
  printf '%s' "$input"
}

color_to_value() {
  local code_color="${1:-}"
  code_color="$(sanitize_input "$code_color")"

  # match code_color value to item in valid_codes before using
  validate "_color_to_value" "$code_color" 
  printf '%s\n' "${COLOR_VALUE[$code_color]}"
  }

value_to_color() {
  printf '%s\n' "${VALUE_COLOR[@]}"
}

main() {
  [[ "$#" -lt 1 || "$#" -gt 2 ]] && { explain_err 2; exit 2; }
    
  local mode="${1:-colors}" code="${2:-black}"
  
  validate "_main" "$mode"
  case $mode in
    colors) value_to_color ;;
    code) color_to_value "$code" ;;
  esac  
}

main "$@"
