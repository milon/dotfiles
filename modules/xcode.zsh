#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    print_step "Updating existing software..."
    softwareupdate --install --all || print_info "No updates or update failed"

    print_step "Checking Xcode command line tools..."
    if xcode-select -p &>/dev/null; then
        print_info "CLT installed at $(xcode-select -p)"
    else
        print_step "Installing Xcode command line tools..."
        xcode-select --install
        print_success "CLT installation initiated"
    fi
}

cmd_check() {
    if xcode-select -p &>/dev/null; then
        print_success "CLT at $(xcode-select -p)"
    else
        print_error "CLT missing — run: xcode-select --install"
        return 1
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: xcode.zsh apply|check"; exit 1 ;;
esac
