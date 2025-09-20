#!/usr/bin/env bash

main() {
    local arg=${1}
    
    printf "%s" "$arg" | rev
}

main "$@"