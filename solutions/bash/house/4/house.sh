#!/usr/bin/env bash
set -euo pipefail

declare -ra THIS_LINES=( \
'This is the house that Jack built.' 'This is the malt' \
'This is the rat' 'This is the cat' 'This is the dog' \
'This is the cow with the crumpled horn' \
'This is the maiden all forlorn' \
'This is the man all tattered and torn' \
'This is the priest all shaven and shorn' \
'This is the rooster that crowed in the morn' \
'This is the farmer sowing his corn' \
'This is the horse and the hound and the horn' )

declare -ra THAT_LINES=( \
'' 'that lay in the house that Jack built.' \
'that ate the malt' 'that killed the rat' \
'that worried the cat' 'that tossed the dog' \
'that milked the cow with the crumpled horn' \
'that kissed the maiden all forlorn' \
'that married the man all tattered and torn' \
'that woke the priest all shaven and shorn' \
'that kept the rooster that crowed in the morn' \
'that belonged to the farmer sowing his corn' )

generate_verse() {
    local -ri verse=$1 
    local -ri input_to_index=$((verse-1))
    local -rn this_lines=THIS_LINES that_lines=THAT_LINES
    
    printf '%s\n' "${this_lines[input_to_index]}"
    for ((line_no = input_to_index ; line_no >= 0; line_no--)); do
        printf '%s\n' "${that_lines[$line_no]}"
    done
}

generate_rhyme() {
    local -ri start=$1 end=$2
    
    for ((verse = start; verse <= end; verse++)); do
        generate_verse "$verse"
    done
}

explain_err() {
  case "$1" in
    out_of_range) printf '%s\n' "invalid" ;;
    start_gt_end) printf '%s\n' "invalid" ;;
  esac
}

validate_input() {
  local -r start=$1 end=$2
  local -n __err_tag=$3
  local -ri array_upper_bound=${#THIS_LINES[@]}
  __err_tag=""
  
  (( "$start" < 1 || "$start" > array_upper_bound )) && { __err_tag=out_of_range; return 1; }
  (( "$end" < 1 || "$end" > array_upper_bound )) && { __err_tag=out_of_range; return 1; }
  (( "$start" > "$end" )) && { __err_tag=start_gt_end; return 1; }
  return 0
}

main() {
  local start=$1 end=$2
  
  local err_tag
  if ! validate_input "$start" "$end" "err_tag"; then
    explain_err "$err_tag" >&2
    return 1
  fi
  
  generate_rhyme "$start" "$end"
}

main "$@"