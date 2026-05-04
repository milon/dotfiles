#!/bin/zsh

source "$support_dir/functions.sh"
source "$support_dir/symlinks_map.sh"

symlinks_ok=1
# (ko): iterate keys in sorted order for stable logs and diffs
for key in ${(ko)sym_links}; do
    val=${sym_links[$key]}
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
        symlinks_ok=0
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

(( symlinks_ok )) || return 1
