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

explain_err() {
  case "$1" in
    out_of_range) printf '%s\n' "invalid" ;;
    start_gt_end) printf '%s\n' "invalid" ;;
  esac
}

validate_input() {
  local -r start=$1 end=$2
  local -n __err_tag=$3
  __err_tag=""
  [[ "$start" -lt 1 || "$start" -gt 12 ]] && { __err_tag=out_of_range; return 1; }
  [[ "$end" -lt 1 || "$end" -gt 12 ]] && { __err_tag=out_of_range; return 1; }
  [[ "$start" -gt "$end" ]] && { __err_tag=start_gt_end; return 1; }
  return 0
}

generate_verse() {
    local -ri verse=$1
    local -rn this_lines=$2 that_lines=$3
    local line_to_get body_range collected_verse
    
    collected_verse=""
    line_to_get=$((verse - 1)) #align terminal input to array indexing
    body_range=$(seq $line_to_get -1 0)
    
    collected_verse+="${this_lines[line_to_get]}"$'\n'
    for line_no in $body_range; do
        collected_verse+="${that_lines[$line_no]}"$'\n'
    done

    printf '%s\n' "$collected_verse" 
}

generate_rhyme() {
    local -ri start=$1 end=$2
    local -rn these_lines=$3 those_lines=$4
    local collected_rhyme verse_range
    
    collected_rhyme=""
    verse_range=$(seq $start $end)
    
    for verse in $verse_range; do
        collected_rhyme+="$(generate_verse "$verse" these_lines those_lines)"$'\n\n'
    done
    
    printf '%s\n' "${collected_rhyme%\n}"
}

main() {
  local start=$1 end=$2
  
  local err_tag
  if ! validate_input "$start" "$end" "err_tag"; then
    explain_err "$err_tag" >&2
    return 1
  fi
  
  generate_rhyme "$start" "$end" THIS_LINES THAT_LINES
}

main "$@"