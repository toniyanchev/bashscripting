#!/bin/bash
cd $(dirname $0) || exit 1


BASE_DIR=$1
OUTPUT_FILE="repo_stats.csv"
SINCE_DATE="2025-01-01"
UNTIL_DATE="2025-12-31 23:59:59"

if [ -z "$BASE_DIR" ]; then
    echo "Usage: $0 <base_directory>"
    exit 1
fi

echo "project,repo,commits_number,lines_added,lines_removed" > "$OUTPUT_FILE"

# Find all git repos under projects/<project_name>/<repo_name>
find "$BASE_DIR" -type d -name ".git" | while read gitdir; do
    repo_path=$(dirname "$gitdir")
    repo_name=$(basename "$repo_path")
    project_name=$(basename "$(dirname "$repo_path")")

    # Count commits in 2025
    commits=$(git -C "$repo_path" rev-list --count \
        --since="$SINCE_DATE" --until="$UNTIL_DATE" HEAD)

    # Sum added and removed lines in 2025
    stats=$(git -C "$repo_path" log \
        --since="$SINCE_DATE" --until="$UNTIL_DATE" \
        --pretty=tformat: --numstat \
        | awk '{added+=$1; removed+=$2} END {print added "," removed}')

    added=$(echo "$stats" | cut -d',' -f1)
    removed=$(echo "$stats" | cut -d',' -f2)

    # Default to 0 if empty
    added=${added:-0}
    removed=${removed:-0}

    echo "$project_name,$repo_name,$commits,$added,$removed" >> "$OUTPUT_FILE"
done

echo "CSV generated: $OUTPUT_FILE"

exit 0
