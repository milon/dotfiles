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

UPDATE=false
if [[ "$1" == "--update" || "$1" == "-u" ]]; then
    UPDATE=true
fi

cd $CODE_DIR
for dir repo in ${(kv)git_repos}; do
    cd $repo
    git pull --rebase
    echo "${GREEN}Pull successful - ($dir)${NC}"
    echo
    cd $CODE_DIR
done

echo 'XX -- Git repositories pull done.'

if [ "$UPDATE" = true ]; then
    for dir repo in ${(kv)git_repos}; do
        cd $repo
        if [ -f "composer.json" ]; then
            composer update
            if [ -n "$(git status --porcelain)" ]; then
                git add .
                git commit -m "Updates dependencies"
                echo "${GREEN}Dependencies updated and committed - ($dir)${NC}"
            else
                echo "${GREEN}No dependency updates - ($dir)${NC}"
            fi
        else
            echo "${YELLOW}Not a php project, no composer.json found - ($dir)${NC}"
        fi
        echo
        cd $CODE_DIR
    done

    echo 'XX -- Composer update and commit done.'
fi
