#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    if ! command_exists atuin; then
        print_error "atuin not installed — run: dot brew"
        return 1
    fi

    local hub="https://api.atuin.sh" status_output logged_in=false
    if status_output=$(atuin status 2>&1); then
        logged_in=true
    fi

    if [[ $logged_in == true ]]; then
        print_info "Already logged in to Atuin Hub"
    else
        if dot_noninteractive; then
            print_warn "Skipping Atuin Hub login — run: dot atuin"
            return 0
        fi
        print_step "1) Log in  2) Register  3) Skip"
        local choice=""
        while [[ $choice != 1 && $choice != 2 && $choice != 3 ]]; do
            read "choice?Choice (1/2/3): "
        done
        case $choice in
            1) atuin login || return 1 ;;
            2) atuin register || return 1 ;;
            3) print_warn "Skipping Atuin Hub login"; return 0 ;;
        esac
    fi

    if confirm_yn "Sync history with Atuin Hub now?"; then
        atuin sync || return 1
        print_success "Synced with Atuin Hub"
    else
        print_warn "Skipping sync"
    fi
}

cmd_check() {
    if ! command_exists atuin; then
        print_warn "atuin not installed"
        return 0
    fi
    if atuin status &>/dev/null; then
        print_success "Logged in to Atuin Hub"
    else
        print_warn "Not logged in — run: dot atuin"
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: atuin.zsh apply|check"; exit 1 ;;
esac
