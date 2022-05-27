#!/bin/zsh

declare -A sym_links
sym_links=(
    [zshrc]=$HOME/.zshrc
    [vimrc]=$HOME/.vimrc
    [antigenrc]=$HOME/.antigenrc
    [plugins.vim]=$HOME/.vim/plugins.vim
    [gitignore]=$HOME/.gitignore
    [mackup.cfg]=$HOME/.mackup.cfg
)

for key val in ${(kv)sym_links}; do
    if test -f "$val"; then
        echo "$val already exists; skipping symlink."
    else
        if [ -d "$val" ]; then
            echo "$val already exists; skipping symlink."
        else
            ln -s $my_dir/files/$key $val
        fi
    fi
done

echo 'XX -- Symlinks done.'
