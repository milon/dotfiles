#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    local repo_config="${DOT_CONFIG_DIR}/topgrade.toml"
    local user_config="${HOME}/.config/topgrade.toml"
    local cfg
    if [[ -f $user_config ]]; then
        cfg=$user_config
    else
        cfg=$repo_config
    fi

    if ! command_exists topgrade; then
        print_error "topgrade not installed — run: dot brew"
        return 1
    fi
    [[ -f $cfg ]] || { print_error "Config not found: $cfg"; return 1; }

    print_step "Running topgrade with ${cfg#$HOME/}..."
    if HOMEBREW_NO_ASK=1 topgrade --config "$cfg"; then
        print_success "Topgrade finished"
    else
        print_error "topgrade reported failures"
        return 1
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) print_info "update has no check"; return 0 ;;
    *) print_error "Usage: update.zsh apply"; exit 1 ;;
esac
