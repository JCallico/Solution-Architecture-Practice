#!/bin/bash

echo "Checking for broken links..."
broken=0

# Get all markdown files
find . -name "*.md" -type f | while read file; do
    # Get directory of the current file
    dir=$(dirname "$file")
    
    # Extract all relative markdown links from the file
    grep -o '\[.*\](\..*\.md)' "$file" 2>/dev/null | grep -o '(\..*\.md)' | tr -d '()' | while read link; do
        # Resolve the link relative to the file's directory
        target="$dir/$link"
        
        # Normalize the path
        target=$(cd "$(dirname "$target")" 2>/dev/null && pwd)/$(basename "$target") 2>/dev/null
        
        # Check if the file exists
        if [ ! -f "$target" ]; then
            echo "BROKEN: $file -> $link (resolved to $target)"
            broken=$((broken + 1))
        fi
    done
done

if [ $broken -eq 0 ]; then
    echo "No broken links found!"
else
    echo "Found $broken broken links"
fi
