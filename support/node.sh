#!/bin/zsh

echo 'Installing NVM and Node'
echo ''

if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | bash
    export NVM_DIR=$HOME/.nvm;
    source $NVM_DIR/nvm.sh;
    nvm install node
fi

# @todo all global npm deps

echo 'XX -- NVM and Node done.'
