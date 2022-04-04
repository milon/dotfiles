#!/bin/zsh

echo 'Cloning git repositories'
echo ''

CODE_DIR=$HOME/Code

declare -A git_repos
git_repos=(
    [resume]="git@github.com:milon/milon.github.io.git"
    [recipe]="git@github.com:milon/recipe.git"
)

cd $CODE_DIR
for dir repo in ${(kv)git_repos}; do
    git clone $repo $dir > /dev/null 2>&1
    CLONE_SUCCESS=$?

    if [[ $CLONE_SUCCESS == 0 ]]
    then
        echo "Clone successful - ($repo)"
    fi

    if [[ $CLONE_SUCCESS == 128 ]]
    then
        echo "Clone fail - $repo (sorry, can't handle that case right now)"
        # If folder already exists, CD in and pull the latest?
        # @todo figure out the folder by parsing the repo :grimace:
        # @todo cd into that folder and git pull
    fi
done

echo 'XX -- Git repositories clone done.'
