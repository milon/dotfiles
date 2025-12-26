#!/bin/zsh

declare -A sym_links
sym_links=(
    [zshrc]=$HOME/.zshrc
    [vimrc]=$HOME/.vimrc
    [antigenrc]=$HOME/.antigenrc
    [plugins.vim]=$HOME/.vim/plugins.vim
    [gitignore]=$HOME/.gitignore
    [nvim]=$HOME/.config/nvim
    [ghostty]=$HOME/.config/ghostty/config
    [Ghostty.icns]=$HOME/.config/ghostty/Ghostty.icns
    [skhdrc]=$HOME/.skhdrc
    [fastfetch.jsonc]=$HOME/.config/fastfetch/config.jsonc
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
            echo "Created symlink: $val"
        fi
    fi
done

echo 'XX -- Symlinks done.'
