#!/bin/bash

# Author: Davide Correia
# Date: 2023/06/07
# Description: This script runs a size check on all subfolders of all projects located in
# /co3fs/Projects

# *** Declare variables ***
# Get absolute path of Projects Root
ABS_PATH='/workspace/playground/ads/volume_1/projects/project_3/'
# Create an array with all project folders
readarray -t PROJECT_LIST <<< $(ls -l /workspace/playground/ads/volume_1/projects/project_3 | grep -v 'total' | awk '{print $9}')

# *** Declare functions ***
# CD onto project folder, size check each folder and output it to TXT and CSV
# 2 TXT files: one with the full history and another per project
# CSV contains name, size and absolute path of project
check_size() {
    PROJECT_ROOT=$1
    TOTAL_PATH="${ABS_PATH}${PROJECT_ROOT}"


    echo "Size checking ${PROJECT_ROOT}..."

    cd "${TOTAL_PATH}"
    echo "You're in $(pwd)" | tee -a /workspace/playground/ads/volume_1/projects/results_history.txt /workspace/playground/ads/volume_1/projects/results_"${PROJECT_ROOT}".txt
    du -skhc * | tee -a /workspace/playground/ads/volume_1/projects/results_history.txt /workspace/playground/ads/volume_1/projects/results_"${PROJECT_ROOT}".txt
    FOLDER_TOTAL=$(grep -i "total" /workspace/playground/ads/volume_1/projects/results_"${PROJECT_ROOT}".txt | awk '{print $1}')
    echo "${PROJECT_ROOT},${FOLDER_TOTAL},${TOTAL_PATH}" >> /workspace/playground/ads/volume_1/projects/results.csv
    
}

# Initiate CSV file
touch /workspace/playground/ads/volume_1/projects/results.csv
echo "project_name,size,path" >> /workspace/playground/ads/volume_1/projects/results.csv

# Loop through PROJECT LIST array
for project in "${!PROJECT_LIST[@]}"
    do
        check_size "${PROJECT_LIST[project]}"
    done
