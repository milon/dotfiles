#!/bin/zsh

source "$support_dir/functions.sh"

repo_config="${dotfiles_dir:A}/files/config/topgrade.toml"
user_config="${HOME}/.config/topgrade.toml"

if [[ -f $user_config ]]; then
    TOPGRADE_CONFIG=$user_config
else
    TOPGRADE_CONFIG=$repo_config
fi

if [[ "$TOPGRADE_CONFIG" == "$repo_config" ]]; then
    print_step "Running topgrade with repo config (${TOPGRADE_CONFIG#$HOME/})..."
else
    print_step "Running topgrade with ${TOPGRADE_CONFIG#$HOME/}..."
fi

if ! command_exists topgrade; then
    print_info "topgrade not installed (install with: brew install topgrade)"
    return 1
fi

if [[ ! -f $TOPGRADE_CONFIG ]]; then
    print_error "Config not found: $TOPGRADE_CONFIG"
    return 1
fi

if topgrade --config "$TOPGRADE_CONFIG"; then
    echo
    print_success "All package updates completed"
else
    echo
    print_error "topgrade reported failures (see output above)"
    return 1
fi
