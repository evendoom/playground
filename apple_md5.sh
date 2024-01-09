#!/bin/bash
# Author: Davide Correia
# Description: Creates MD5 hash file and parses it to meet Apple spec
# Use: ./apple_md5.sh {absolute SAN path of source folder} {name of MD5}
# Example: ./apple_md5.sh /ads/Projects/my_project/NAM/ my_project

# Check if all required arguments have been passed
if [[ "${#}" -lt 2 ]]
then
    echo "Not enough arguments"
    echo "Use: ./apple_md5.sh {absolute SAN path of source folder} {name of MD5}"
    echo "Example: ./apple_md5.sh /ads/Projects/my_project/NAM/ my_project.md5"
    exit 1
fi

# Create functions
# Check if exit status is 0
check_status() {
    MESSAGE="${1}"
    if [[ "${?}" -ne 0 ]]
    then
        echo "${MESSAGE}"
        exit 1
    fi
}

# Create variables
SOURCE_PATH="${1}"
MD5_NAME="${2}"

# CD onto top level
cd "${1}"/../
echo "You're in $(pwd)"

# Create standard MD5
echo "Creating MD5 file..."
find "${1}" -type f -exec md5sum {} >> ./"${2}_standard.md5" \;

# Check if exit status is 0
check_status "Something went wrong creating MD5, aborting..."

# Parse MD5 to meet Apple standards
cat "${1}/../${2}_standard.md5" | sort -k 2 | awk '{print $2"|"$1}' >> ./"${2}.md5"

# Check if exit status is 0
check_status "Failed parsing, aborting..."

# Clean up
rm -vf "${1}/../${2}_standard.md5"

exit 0