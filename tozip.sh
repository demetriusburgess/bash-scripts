#!/bin/bash

# Usage: ./compress.sh [--overwrite] <target1> <target2> ...
# Example: ./compress.sh myfile.txt my-project --overwrite

overwrite=false

# Check for --overwrite flag
if [ "$1" == "--overwrite" ]; then
    overwrite=true
    shift
fi

# Check if at least one target was given
if [ $# -eq 0 ]; then
    echo "Usage: $0 [--overwrite] <target1> <target2> ..."
    exit 1
fi

# Loop through each target
for target in "$@"; do
    if [ ! -e "$target" ]; then
        echo "Error: '$target' does not exist."
        continue
    fi

    # Remove trailing slash if directory
    base_name=$(basename "${target%/}")

    # Add timestamp to the zip file name
    timestamp=$(date +"%Y%m%d_%H%M%S")
    zip_file="${base_name}_${timestamp}.zip"

    # If overwrite is false, check for existing file
    if [ -f "$zip_file" ] && [ "$overwrite" = false ]; then
        echo "Warning: '$zip_file' already exists. Use --overwrite to replace it."
        continue
    fi

    # Create zip archive
    zip -r "$zip_file" "$target" &> /dev/null
    echo "'$target' compressed into '$zip_file'."
done
