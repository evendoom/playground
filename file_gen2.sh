#!/bin/bash
# Author: Davide Correia
# Description: Generates a sequence of files with 8 digits padding
# Usage: file_gen <destination path> <first frame> <last frame>
# Example: file_gen /workspace/playground/ads/volume_1/projects/project_4/ 0 500

# *** Declare Variables ***
SRC="${1}"
FIRST_FRAME="${2}"
LAST_FRAME="${3}"

# *** Create file sequence ***
for file in $(seq -f "%08g" "${FIRST_FRAME}" "${LAST_FRAME}")
    do
        head -c 50MB /dev/random > "${SRC}"/test."${file}".tiff
    done