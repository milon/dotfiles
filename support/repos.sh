#!/bin/zsh

# Shared manifest of personal Git repositories.
# Sourced by support/git_clone.sh (initial clone) and support/pull.sh (updates).
# Add or remove entries here to change both flows in one place.

export CODE_DIR="${CODE_DIR:-$HOME/Code}"

typeset -gA git_repos
git_repos=(
    [resume]="git@github.com:milon/milon.github.io.git"
    [recipes]="git@github.com:milon/recipes.git"
    [one-problem-a-day]="git@github.com:milon/one-problem-a-day.git"
    [system-design]="git@github.com:milon/system-design.git"
    [cv]="git@github.com:milon/cv.git"
)
