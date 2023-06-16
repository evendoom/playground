#!/bin/bash
# Author: Davide Correia
# Description: Link a list of files onto a specific destination

# *** Declare Variables ***
readarray -t ITEM_LIST <<< $(cat test.txt)

for item in "${!ITEM_LIST[@]}"
    do
        echo "${ITEM_LIST[item]}"
    done