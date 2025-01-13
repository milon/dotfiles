#!/bin/zsh

echo 'Pulling updates from git repositories'
echo 

CODE_DIR=$HOME/Code

declare -A git_repos
git_repos=(
    [resume]=$CODE_DIR/resume
    [recipes]=$CODE_DIR/recipes
    [takakori]=$CODE_DIR/takakori
    [one-problem-a-day]=$CODE_DIR/one-problem-a-day
    [system-design]=$CODE_DIR/system-design
    [cv]=$CODE_DIR/cv
    [dotfiles]=$HOME/.dotfiles
)

cd $CODE_DIR
for dir repo in ${(kv)git_repos}; do
    cd $repo
    git pull --rebase
    echo "${GREEN}Pull successful - ($dir)${NC}"
    echo
    cd $CODE_DIR
done

echo 'XX -- Git repositories pull done.'