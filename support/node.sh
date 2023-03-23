#!/bin/zsh

echo 'Configuring node'

if [ ! -d "$HOME/.nvm" ]; then
    mkdir .nvm
fi

source $(brew --prefix nvm)/nvm.sh
export NVM_DIR="$HOME/.nvm"

nvm install node

echo 'Node done.'
