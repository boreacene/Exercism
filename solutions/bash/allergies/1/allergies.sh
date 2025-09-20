#!/usr/bin/env bash
set -eo pipefail

declare -rA ALLERGIES=( \
  [1]="eggs" [2]="peanuts" \
  [4]="shellfish" [8]="strawberries" \
  [16]="tomatoes" [32]="chocolate" \
  [64]="pollen" [128]="cats" )


wrap8_score() {
  local score
  IFS= read -r score; local -r score
  [[ -v score ]] || { printf 'wrap8_score: score is unset\n' >&2; return 1; }

  printf "%s\n" "$(( score & 255 ))"
}

list_allergens() {
  local score 
  IFS= read -r score; local -r score
  [[ -v score ]] || { printf 'list_allergens: score is unset\n' >&2; return 1; }

  local -n allergy_ref=$1
  local -a allergy_list=()
  
  for index in $( printf '%s\n' "${!allergy_ref[@]}" | sort -n ); do
    (( score & index )) && allergy_list+=("${allergy_ref[$index]}") 
  done

  echo "${allergy_list[@]}"
}

is_allergic() {
  local -r score=$1 allergen=$2

  if ! [[ -v score && -v allergen ]]; then
    printf 'list_allergens: score or allergen is unset\n' >&2
    return 1
  fi
        
  local -n allergen_ref=$3
  local -r mask=$( \
    for m in "${!allergen_ref[@]}"; do
      [[ $allergen == "${allergen_ref[$m]}" ]] \
      && { printf "%s" "$m"; break; }
    done )
    
    (( score & mask )) && printf "true\n" || printf "false\n"
}

main() {
  local -r score=$1 mode=$2 allergen=$3

  case $mode in
    allergic_to)
      is_allergic "$score" "$allergen" "ALLERGIES"
      ;;
    list)  
      printf "%s\n" "$score" | wrap8_score | list_allergens "ALLERGIES"
      ;;
    *)
      printf ""
      ;;      
  esac
}

main "$@"