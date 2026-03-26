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
    src="${dotfiles_dir:A}/files/${key}"
    # If dest is already a symlink to src, skip ln. On macOS, ln -sf when both
    # paths resolve to the same directory can create a nested nvim -> nvim link
    # inside the repo (see files/config/nvim/nvim).
    if [[ -L $val && ${val:A} == ${src:A} ]]; then
        print_success "Symlink already correct: $val"
        continue
    fi
    if ln -sf "$src" "$val"; then
        print_success "Created symlink: $val"
    else
        print_error "Failed to create symlink: $val"
    fi
done

# Remove legacy self-referential nvim/nvim symlink if present
nvim_cfg="${dotfiles_dir:A}/files/config/nvim"
nvim_nested="${nvim_cfg}/nvim"
if [[ -L $nvim_nested && ${nvim_nested:A} == ${nvim_cfg:A} ]]; then
    rm "$nvim_nested"
    print_info "Removed circular files/config/nvim/nvim symlink"
fi
unset nvim_cfg nvim_nested src
