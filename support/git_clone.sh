#!/bin/zsh

echo 'Cloning git repositories'
echo 

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
        cd $dir
        git pull
        echo "Pull successful - ($repo)"
        cd $CODE_DIR
    fi
done

echo 'XX -- Git repositories clone done.'
