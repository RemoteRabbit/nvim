#!/bin/bash

# Get current branch and commit range
BRANCH=$(git branch --show-current)
COMMITS=$(git log --format="%h %s%n%b" --no-merges origin/main..$BRANCH)

# Initialize sections
FEATURES=""
FIXES=""
BREAKING=""
OTHERS=""

# Parse commits
while IFS= read -r line; do
    if [[ $line =~ ^[a-f0-9]{7}\ feat ]]; then
        FEAT=$(echo "$line" | sed 's/^[a-f0-9]* feat[^:]*: *//')
        FEATURES="$FEATURES- $FEAT\n"
    elif [[ $line =~ ^[a-f0-9]{7}\ fix ]]; then
        FIX=$(echo "$line" | sed 's/^[a-f0-9]* fix[^:]*: *//')
        FIXES="$FIXES- $FIX\n"
    elif [[ $line =~ BREAKING\ CHANGE ]]; then
        BREAK=$(echo "$line" | sed 's/BREAKING CHANGE: *//')
        BREAKING="$BREAKING- $BREAK\n"
    elif [[ $line =~ ^[a-f0-9]{7} ]]; then
        OTHER=$(echo "$line" | sed 's/^[a-f0-9]* //')
        OTHERS="$OTHERS- $OTHER\n"
    fi
done <<< "$COMMITS"

# Build PR body
BODY=""
[[ -n "$FEATURES" ]] && BODY="$BODY## ✨ Features\n$FEATURES\n"
[[ -n "$FIXES" ]] && BODY="$BODY## 🐛 Bug Fixes\n$FIXES\n"
[[ -n "$BREAKING" ]] && BODY="$BODY## 💥 Breaking Changes\n$BREAKING\n"
[[ -n "$OTHERS" ]] && BODY="$BODY## 🔧 Other Changes\n$OTHERS\n"

# Create PR with structured body
gh pr create --title "$1" --body "$(echo -e "$BODY")" --head $BRANCH --base main
