#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    if ! command_exists sheldon; then
        print_error "sheldon not found — run: dot brew"
        return 1
    fi
    print_step "Refreshing Sheldon lock..."
    if sheldon lock; then
        print_success "sheldon lock updated"
    else
        print_error "sheldon lock failed"
        return 1
    fi
}

cmd_check() {
    local sheldon_toml="${HOME}/.config/sheldon/plugins.toml"
    local sheldon_lock="${HOME}/.local/share/sheldon/plugins.lock"
    if ! command_exists sheldon; then
        print_warn "sheldon not installed — run: dot brew"
        return 0
    fi
    if [[ ! -f $sheldon_toml ]]; then
        print_warn "sheldon plugins.toml missing — run: dot symlinks"
        return 0
    fi
    if [[ ! -f $sheldon_lock ]]; then
        print_warn "sheldon lock missing — run: dot shell"
        return 0
    fi
    if [[ $sheldon_toml -nt $sheldon_lock ]]; then
        print_warn "plugins.toml newer than lock — run: dot shell"
        return 0
    fi
    print_success "sheldon lock is up to date"

    if [[ -f "$HOME/.zshrc.local" ]]; then
        local mode
        mode=$(stat -f '%Lp' "$HOME/.zshrc.local" 2>/dev/null || true)
        if [[ -n $mode && "${mode[-2,-1]}" != "00" ]]; then
            print_warn "~/.zshrc.local is mode ${mode} — chmod 600 ~/.zshrc.local"
        else
            print_success "~/.zshrc.local permissions private"
        fi
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: shell.zsh apply|check"; exit 1 ;;
esac
