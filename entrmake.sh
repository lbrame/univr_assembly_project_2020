#!/bin/bash

find . -type f \( -iname '*.c' -o -iname '*.s' \) | \
    entr -nsc 'make'
