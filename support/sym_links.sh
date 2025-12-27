#!/bin/zsh

source "$support_dir/functions.sh"

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
    if [ -f "$val" ] || [ -d "$val" ]; then
        print_info "$(basename "$val") already exists, skipping"
    else
        print_step "Creating symlink for $(basename "$val")..."
        mkdir -p "$(dirname "$val")"
        if ln -s "$dotfiles_dir/files/$key" "$val"; then
            print_success "Created symlink: $val"
        else
            print_error "Failed to create symlink: $val"
        fi
    fi
done
