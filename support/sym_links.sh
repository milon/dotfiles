#!/bin/zsh

declare -A sym_links
sym_links=(
    [zshrc]=$HOME/.zshrc
    [vimrc]=$HOME/.vimrc
    [antigenrc]=$HOME/.antigenrc
    [plugins.vim]=$HOME/.vim/plugins.vim
    [gitignore]=$HOME/.gitignore
    [mackup.cfg]=$HOME/.mackup.cfg
    [nvim]=$HOME/.config/nvim
    [wezterm.lua]=$HOME/.wezterm.lua
    [ghostty]=$HOME/.config/ghostty/config
)

for key val in ${(kv)sym_links}; do
    if test -f "$val"; then
        echo "$val already exists; skipping symlink."
    else
        if [ -d "$val" ]; then
            echo "$val already exists; skipping symlink."
        else
            mkdir -p "$(dirname "$val")"
            ln -s $dotfiles_dir/files/$key $val
        fi
    fi
done

echo 'XX -- Symlinks done.'
