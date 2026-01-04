#!/bin/bash

# Usage: ./trim_dir.sh <number_of_chars> <directory_path>
# Example: ./trim_dir.sh 4 ./my_photos

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <number_of_chars> <directory>"
    exit 1
fi

CHARS_TO_REMOVE=$1
TARGET_DIR=$2

if ! [[ "$CHARS_TO_REMOVE" =~ ^[0-9]+$ ]]; then
    echo "Error: First argument must be a positive integer."
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

echo "Scanning directory: $TARGET_DIR"

count=0

for file_path in "$TARGET_DIR"/*; do
    
    # Skip if no files match
    [ -e "$file_path" ] || continue

    if [ -d "$file_path" ]; then
        echo "Skipping directory: $file_path"
        continue
    fi

    # Don't let the script rename itself if it's in the same folder
    if [ "$file_path" == "$0" ]; then
        continue
    fi

    # Get the filename and directory separate
    filename=$(basename "$file_path")
    dirname=$(dirname "$file_path")

    # Check length
    if [ ${#filename} -le "$CHARS_TO_REMOVE" ]; then
        echo "Skipping '$filename': Name too short."
        continue
    fi

    new_name="${filename:$CHARS_TO_REMOVE}"
    new_full_path="$dirname/$new_name"

    if [ -e "$new_full_path" ]; then
        echo "Skipping '$filename': Destination '$new_name' already exists."
    else
        mv "$file_path" "$new_full_path"
        echo "Renamed: $filename -> $new_name"
        ((count++))
    fi
done

echo "---"
echo "Operation complete. Renamed $count files."
