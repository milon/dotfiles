#!/bin/zsh

echo 'Configuring git'
echo 

git config --global user.name $git_user_name
git config --global user.email $git_user_email

git config --global core.excludesfile $HOME/.gitignore
git config --global core.editor vim
git config --global core.autocrlf input

git config --global init.defaultBranch master
git config --global pull.rebase false
git config --global push.default current

echo 'XX -- Git done.'
