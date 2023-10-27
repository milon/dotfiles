#!/bin/zsh

echo 'Pulling updates from git repositories'
echo 

CODE_DIR=$HOME/Code

declare -A git_repos
git_repos=(
    [resume]=$CODE_DIR/resume
    [recipes]=$CODE_DIR/recipes
    [one-problem-a-day]=$CODE_DIR/one-problem-a-day
    [system-design]=$CODE_DIR/system-design
)

cd $CODE_DIR
for dir repo in ${(kv)git_repos}; do
    cd $repo
    git pull
    echo "Pull successful - ($dir)"
    cd $CODE_DIR
done

echo 'XX -- Git repositories pull done.'