#!/bin/bash
set -e

cd "$(dirname "$0")"

while read path; do
	path=$(eval "echo $path")
    if [ -e "$path" ]; then
        exit 0
    fi
done <paths.txt

exit 65 # EX_DATAERR
