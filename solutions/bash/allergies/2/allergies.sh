#!/usr/bin/env bash
set -eo pipefail

declare -rA MASK_TO_ALLERGIES=( \
  [1]="eggs" [2]="peanuts" \
  [4]="shellfish" [8]="strawberries" \
  [16]="tomatoes" [32]="chocolate" \
  [64]="pollen" [128]="cats" )

declare -rA ALLERGIES_TO_MASK=( \
  [eggs]="1" [peanuts]="2" \
  [shellfish]="4" [strawberries]="8" \
  [tomatoes]="16" [chocolate]="32" \
  [pollen]="64" [cats]="128")

wrap8_score() {
  local score
  IFS= read -r score; local -r score

  printf "%s\n" "$(( score & 255 ))"
}

list_allergens() {
  local score 
  IFS= read -r score; local -r score

  local -n allergy_ref=$1
  
  local -a allergy_list=()
  for mask in $( printf '%s\n' "${!allergy_ref[@]}" | sort -n ); do
    (( score & mask )) && allergy_list+=("${allergy_ref[$mask]}") 
  done

  echo "${allergy_list[@]}"
}

is_allergic_to() {
  local score 
  IFS= read -r score; local -r score

  local -r allergen=${1,,}
  local -n allergen_ref=$2
  local -r mask=${allergen_ref[$allergen]}

  (( score & mask )) && printf "true\n" || printf "false\n"
}

main() {
  local -r score=$1 mode=$2 allergen=$3
  [[ score -ge 0 ]] || { printf 'main(): score must be greater than 0\n' >&2; exit 1; }
  [[ -n $mode ]] || { printf 'main(): mode is empty\n' >&2; exit 1; }
  [[ $2 == allergic_to && -z $3 ]] && { printf 'main(): allergen is required for allergic_to\n' >&2; exit 1; }
  
  case $mode in
    allergic_to)
      printf "%s\n" "$score" \
        | wrap8_score \
        | is_allergic_to "$allergen" "ALLERGIES_TO_MASK"
      ;;
    list)  
      printf "%s\n" "$score" \
        | wrap8_score \
        | list_allergens "MASK_TO_ALLERGIES"
      ;;
    *)
      printf 'main(): Invalid input, please try again.\n' >&2
      ;;
  esac
}

main "$@"