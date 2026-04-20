#!/usr/bin/env bash

# -----------------------------
# CONFIGURATION
# -----------------------------
ORG_NAME=$1
PROJECT=$2
ORG="https://dev.azure.com/$ORG_NAME"

if [ -z "$ORG_NAME" ] || [ -z "$PROJECT" ]; then
    echo "Usage: $0 <organization_name> <project_name>"
    exit 1
fi

# -----------------------------
# SCRIPT
# -----------------------------
API_URL="$ORG/$PROJECT/_apis/git/repositories?api-version=7.0"

echo "Fetching repository list from Azure DevOps..."

# Get repo list
REPOS=$(curl -s -u ":$AZURE_DEVOPS_PAT" "$API_URL" | jq -r '.value[] | .name + " " + .remoteUrl')

echo "Cloning repositories..."
echo

while read -r NAME URL; do
    if [ -z "$NAME" ]; then
        continue
    fi

    echo "Cloning: $NAME"
    git clone "$URL"
    echo
done <<< "$REPOS"

echo "Done!"
