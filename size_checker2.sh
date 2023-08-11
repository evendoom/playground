#!/bin/bash

# Author: Davide Correia
# Date: 2023/06/07
# Description: This script runs a size check on all subfolders of all projects located in
# /co3fs/Projects

# *** Declare variables ***
# Get absolute path of Projects Root
ABS_PATH='/workspace/playground/ads/volume_2/projects/'
# Create an array with all project folders
readarray -t PROJECT_LIST <<< $(ls -l /workspace/playground/ads/volume_2/projects/ | grep -v 'total' | awk '{print $9}')

# *** Declare functions ***
# CD onto project folder, size check each folder and output it to TXT and CSV
# 2 TXT files: one with the full history and another per project
# CSV contains name, size and absolute path of project
check_size() {
    PROJECT_ROOT="${1}"
    TOTAL_PATH="${ABS_PATH}${PROJECT_ROOT}"
    readarray -t LIST_OF_SUBFOLDERS <<< $(ls -l "${TOTAL_PATH}" | grep -v 'total' | awk '{print $9}')
    
    # Check level 1 of subfolders
    echo "Size checking ${PROJECT_ROOT}..."

    cd "${TOTAL_PATH}"
    echo "You're in $(pwd)" | tee -a /workspace/playground/ads/volume_2/projects/results_"${PROJECT_ROOT}".txt
    du -skhc * | tee -a /workspace/playground/ads/volume_2/projects/results_"${PROJECT_ROOT}".txt
    FOLDER_TOTAL=$(grep -i "total" /workspace/playground/ads/volume_2/projects/results_"${PROJECT_ROOT}".txt | awk '{print $1}')
    echo "${PROJECT_ROOT},${FOLDER_TOTAL},${TOTAL_PATH}" >> /workspace/playground/ads/volume_2/projects/results.csv

    # Check level 2 of subfolders
    for subfolder in "${!LIST_OF_SUBFOLDERS[@]}"
        do
            if [[ -d "${TOTAL_PATH}${LIST_OF_SUBFOLDERS[subfolder]}" ]]
            then
                cd "${TOTAL_PATH}${LIST_OF_SUBFOLDERS[subfolder]}"
                echo "You're in $(pwd)" | tee -a /workspace/playground/ads/volume_2/projects/results_"${PROJECT_ROOT}".txt
                du -skhc * | tee -a /workspace/playground/ads/volume_2/projects/results_"${PROJECT_ROOT}".txt
            else
                echo "Couldn't find ${TOTAL_PATH}${LIST_OF_SUBFOLDERS[subfolder]}"
                echo "Skipping..."
                continue
            fi
        done
}

# Initiate CSV file
touch /workspace/playground/ads/volume_1/projects/results.csv
echo "project_name,size,path" >> /workspace/playground/ads/volume_1/projects/results.csv

# Loop through PROJECT LIST array
for project in "${!PROJECT_LIST[@]}"
    do
        check_size "${PROJECT_LIST[project]}"
    done
