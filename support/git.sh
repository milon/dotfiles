#!/bin/zsh

echo 'Configuring git'
echo ''

git config --global user.name "Nuruzzaman Milon"
git config --global user.email "contact@milon.im"
git config --global core.excludesfile $HOME/.gitignore

echo 'XX -- Git done.'
