#!/bin/bash
# Author: Davide Correia
# Description: Reads all MD5 files from a folder (recursive), parses them onto a new file and verifies content
# Use: md5_parser <absolute path of folder to verify>

# Check if all arguments have been passed
if [[ "${#}" -lt 1 ]]
then
    echo "Missing arguments..."
    echo "Usage: md5_parser <absolute path of folder to verify>"
    echo "Example: md5_parser /co3fs/Projects/project_a/synapse/s3_uploads/712345L7/"
fi

# Create Variables
SOURCE="${1}"

# Find MD5 files and store them in an array
readarray -t MD5_LIST <<< $(find "${1}" -iname "*.md5" -type f)

# Iterate Array
for file in "${!MD5_LIST[@]}"
    do
        # Remove "./" from each entry, add absolute path to each checksum and store all entries on "${SOURCE}" as collated_file.md5
        cat "${MD5_LIST[file]}" | sed 's\./\\' | awk -v source="${SOURCE}" '{$2=source$2; print $1 "  " $2}' >> "${SOURCE}"collated_file.md5
    done

# Run md5sum -c on collated_file
md5sum -c "${SOURCE}"collated_file.md5