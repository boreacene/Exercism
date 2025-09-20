#!/usr/bin/env bash
set -eo pipefail

explain_err() {
  case "$1" in
    bad_seq) printf 'strands must be empty or contain only the characters ACGT\n' ;;
    bad_arg_count) printf 'Usage: hamming.sh <string1> <string2>\n' ;;
    seq_len_miss) printf 'strands must be of equal length\n' ;;
  esac
}

validate_input() {
  local -r dna_seq1=$1 dna_seq2=$2
  local -n _err_tag="$3"
  _err_tag=""

  # uncomment for strict DNA checks
  # [[ "$dna_seq1" = *[!ACGT]* || "$dna_seq2" = *[!ACGT]* ]] && {
  #   _err_tag=bad_seq
  #   return 1
  # }
  [[ "${#dna_seq1}" -ne "${#dna_seq2}" ]] && {
    _err_tag=seq_len_miss
    return 1
  }
  return 0
}

compare_dna_sequences() {
  local -ri fd1=$1 fd2=$2
  local dna_seq1 dna_seq2
  local -i hamming_dist=0

  set +e
  while :; do
    IFS= read -rN1 -u $fd1 dna_seq1
    read_status1=$?
    IFS= read -rN1 -u $fd2 dna_seq2
    read_status2=$?

    [[ "$dna_seq1" != "$dna_seq2" ]] && hamming_dist+=1
    [[ "$read_status1" != 0 && "$read_status2" != 0 ]] && {
      printf '%s\n' "$hamming_dist"
      break
    }
  done
  set +e
}

main() {
  local -r dna_seq1=$1 dna_seq2=$2
  local err_tag
  if [[ $# -ne 2 ]]; then
    explain_err "bad_arg_count"
    return 1
  fi

  if ! validate_input "$dna_seq1" "$dna_seq2" "err_tag"; then
    explain_err "$err_tag" >&2
    return 1
  fi

  exec {fd1}< <(printf '%s' "$dna_seq1")
  exec {fd2}< <(printf '%s' "$dna_seq2")

  compare_dna_sequences "$fd1" "$fd2"

  exec {fd1}<&-
  exec {fd2}<&-
}

main "$@"
