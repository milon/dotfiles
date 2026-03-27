#!/bin/zsh

source "$support_dir/functions.sh"

readonly TOPGRADE_CONFIG="$HOME/.config/topgrade.toml"


print_step "Running topgrade with ${TOPGRADE_CONFIG#$HOME/}..."

if ! command_exists topgrade; then
    print_info "topgrade not installed (install with: brew install topgrade)"
    exit 1
fi

if [[ ! -f "$TOPGRADE_CONFIG" ]]; then
    print_error "Config not found: $TOPGRADE_CONFIG"
    exit 1
fi

if topgrade --config "$TOPGRADE_CONFIG"; then
    echo
    print_success "All package updates completed"
else
    echo
    print_error "topgrade reported failures (see output above)"
    exit 1
fi
