#!/bin/bash

# Stage all changes
git add .

# Ask for a commit message
read -p "Enter commit message: " msg

# Commit with user message
git commit -m "$msg"

# Push to the current branch
git push
