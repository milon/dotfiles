#!/bin/zsh

source "$support_dir/functions.sh"

declare -A sym_links
# Organized by destination: home, .vim, .config/*
sym_links=(
    # $HOME root
    [home/zshrc]=$HOME/.zshrc
    [home/vimrc]=$HOME/.vimrc
    [home/antigenrc]=$HOME/.antigenrc
    [home/gitignore]=$HOME/.gitignore
    [home/skhdrc]=$HOME/.skhdrc
    # $HOME/.vim
    [vim/plugins.vim]=$HOME/.vim/plugins.vim
    # $HOME/.config
    [config/nvim]=$HOME/.config/nvim
    [config/ghostty/config]=$HOME/.config/ghostty/config
    [config/ghostty/Ghostty.icns]=$HOME/.config/ghostty/Ghostty.icns
    [config/fastfetch/config.jsonc]=$HOME/.config/fastfetch/config.jsonc
    [config/mise/config.toml]=$HOME/.config/mise/config.toml
    [config/topgrade.toml]=$HOME/.config/topgrade.toml
)

for key val in ${(kv)sym_links}; do
    print_step "Creating symlink for $(basename "$val")..."
    mkdir -p "$(dirname "$val")"
    if ln -sf "$dotfiles_dir/files/$key" "$val"; then
        print_success "Created symlink: $val"
    else
        print_error "Failed to create symlink: $val"
    fi
done
