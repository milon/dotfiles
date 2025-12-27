#!/bin/zsh

source "$support_dir/functions.sh"

declare -A GIT_DEPENDENCIES
GIT_DEPENDENCIES=(
    ["$HOME/.vim/bundle"]="https://github.com/VundleVim/Vundle.vim.git"
    ["$HOME/.config/nvim"]="https://github.com/NvChad/NvChad.git"
)

for dir repo in ${(kv)GIT_DEPENDENCIES}; do
    print_step "Installing $(basename "$repo")..."
    mkdir -p "$dir"
    
    if [ -d "$dir/.git" ]; then
        print_info "$(basename "$repo") already exists, skipping"
        continue
    fi
    
    cd "$dir" || continue
    
    if git clone "$repo" . > /dev/null 2>&1; then
        print_success "Installed $(basename "$repo")"
    else
        print_error "Failed to install $(basename "$repo")"
    fi
done
