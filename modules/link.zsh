#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

backup_existing_dest() {
    local dest=$1
    local stamp base dest_backup
    mkdir -p "$DOT_BACKUP_DIR"
    stamp=$(date +%Y%m%d%H%M%S)
    base=$(basename "$dest")
    dest_backup="${DOT_BACKUP_DIR}/${base}.${stamp}"
    [[ -e $dest_backup ]] && dest_backup="${dest_backup}.$$"
    if mv "$dest" "$dest_backup"; then
        print_info "Backed up ${dest} → ${dest_backup}"
        return 0
    fi
    print_error "Failed to back up: $dest"
    return 1
}

cmd_apply() {
    dot_load_links
    typeset -i ok=1
    local key src dest
    for key in ${(ko)reply_links}; do
        dest=$reply_links[$key]
        src="${DOT_CONFIG_DIR}/${key}"
        print_step "Linking $(basename "$dest")..."
        if [[ ! -e $src ]]; then
            print_error "Source missing: $src"
            ok=0
            continue
        fi
        mkdir -p "$(dirname "$dest")"
        if [[ -L $dest && ${dest:A} == ${src:A} ]]; then
            print_success "Already correct: $dest"
            continue
        fi
        if [[ -e $dest || -L $dest ]]; then
            backup_existing_dest "$dest" || { ok=0; continue; }
        fi
        if ln -sfn "$src" "$dest"; then
            print_success "Created: $dest"
        else
            print_error "Failed: $dest"
            ok=0
        fi
    done
    (( ok ))
}

cmd_check() {
    dot_load_links
    typeset -i ok=0 total=0 errors=0
    local key src dest
    for key in ${(ko)reply_links}; do
        total+=1
        dest=$reply_links[$key]
        src="${DOT_CONFIG_DIR}/${key}"
        if [[ ! -e $src ]]; then
            print_error "Source missing in repo: $src"
            errors+=1
            continue
        fi
        if [[ -L $dest && ${dest:A} == ${src:A} ]]; then
            ok+=1
        elif [[ -L $dest ]]; then
            print_error "Wrong target: $dest -> ${dest:A}"
            errors+=1
        elif [[ -e $dest ]]; then
            print_error "Exists but not a symlink: $dest"
            errors+=1
        else
            print_error "Missing: $dest (run: dot link)"
            errors+=1
        fi
    done
    print_info "$ok / $total symlinks OK"
    (( errors == 0 ))
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: link.zsh apply|check"; exit 1 ;;
esac
