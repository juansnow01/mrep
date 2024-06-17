#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage $0 <man-page> <search-string>"
    exit 1
fi

man $1 | grep --color=always -i -C 3 "$2"
