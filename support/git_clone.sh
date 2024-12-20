#!/bin/zsh

echo 'Cloning git repositories'
echo 

CODE_DIR=$HOME/Code

declare -A git_repos
git_repos=(
    [resume]="git@github.com:milon/milon.github.io.git"
    [recipes]="git@github.com:milon/recipes.git"
    [takakori]="git@github.com:milon/takakori.git"
    [one-problem-a-day]="git@github.com:milon/one-problem-a-day.git"
    [system-design]="git@github.com:milon/system-design.git"
    [cv]="git@github.com:milon/cv.git"
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
