#!/bin/zsh

echo 'Configuring python'

pyenv install 3.11
pyenv install 2.7

pyenv global 3.11 2.7

echo 'Python done.'
