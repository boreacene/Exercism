#!/usr/bin/env bash

main() {
    name=${1:-you}

    printf "One for %s, one for me." "$name"
}

main "$@"