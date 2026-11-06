#!/bin/zsh

source "$support_dir/functions.sh"
source "$support_dir/symlinks_map.sh"

# Move an existing destination aside before replacing it with a symlink.
# Backups land in ~/.dotfiles-backup/<basename>.<timestamp>.
backup_existing_dest() {
    local dest=$1
    local backup_root="${HOME}/.dotfiles-backup"
    local stamp base dest_backup

    mkdir -p "$backup_root"
    stamp=$(date +%Y%m%d%H%M%S)
    base=$(basename "$dest")
    dest_backup="${backup_root}/${base}.${stamp}"

    # Avoid colliding with an earlier backup from the same second
    if [[ -e $dest_backup ]]; then
        dest_backup="${dest_backup}.$$"
    fi

    if mv "$dest" "$dest_backup"; then
        print_info "Backed up existing ${dest} → ${dest_backup}"
        return 0
    fi
    print_error "Failed to back up existing destination: $dest"
    return 1
}

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

    # Anything already at the destination (wrong symlink, file, or directory)
    # is moved aside instead of being deleted in place.
    if [[ -e $val || -L $val ]]; then
        if ! backup_existing_dest "$val"; then
            symlinks_ok=0
            continue
        fi
    fi

    if ln -sfn "$src" "$val"; then
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
