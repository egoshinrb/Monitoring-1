#!/bin/bash

if [[ -n $1 ]]; then
    if [[ "$1" =~ ^[+-]?[0-9]+([.][0-9]+)?$ ]]; then
        echo "Incorrect input"
    else
        echo "$1"
    fi
else
    echo "The parameter are set incorrectly or missing"
fi