#!/bin/zsh

# install vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# install vundle or whatever other vim bundler
vim +PluginInstall +qall
