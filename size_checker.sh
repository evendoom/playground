#!/bin/bash

# Author: Davide Correia
# Date: 2023/06/07
# Description: This script runs a size check on all subfolders of all projects located in
# /co3fs/Projects

# Declare variables
FILE_PATH='/workspace/playground/ads/volume_1/projects/project_3/'
readarray -t PROJECT_LIST <<< $(ls -l /workspace/playground/ads/volume_1/projects/project_3 | grep -v 'total' | awk '{print $9}')

# Declare functions
check_size() {
    PROJECT_ROOT=$1

    echo "Size checking ${PROJECT_ROOT}..."

    cd ${FILE_PATH}/${PROJECT_ROOT}
    echo "You're in $(pwd)" >> /workspace/playground/ads/volume_1/projects/results.txt
    du -skhc * >> /workspace/playground/ads/volume_1/projects/results.txt
}

# Loop through PROJECT LIST array
for project in ${!PROJECT_LIST[@]}
    do
        check_size ${PROJECT_LIST[project]}
    done
