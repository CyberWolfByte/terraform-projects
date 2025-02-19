#!/bin/bash

# Always unset the GitHub-provided token from the environment
unset GITHUB_TOKEN
echo "Unset GITHUB_TOKEN to force manual authentication."

# Check if authentication is needed (if delete_repo scope is missing)
if ! gh auth status 2>&1 | grep -q 'delete_repo'; then
    echo "Logging into GitHub CLI..."
    gh auth login -h github.com -p https -s delete_repo -w
else
    echo "Already authenticated with required scopes."
fi