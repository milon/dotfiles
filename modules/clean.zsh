#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    print_step "Cleaning Homebrew cache..."
    brew cleanup && print_success "Homebrew cache cleaned" || true
    print_step "Removing unused Homebrew deps..."
    brew autoremove --quiet && print_success "Homebrew autoremove done" || true

    print_step "Cleaning npm cache..."
    if npm cache clean --force 2>/dev/null; then
        print_success "npm cache cleaned"
    else
        print_warn "npm not available — skipping"
    fi

    print_step "Cleaning Composer cache..."
    if composer clear-cache 2>/dev/null; then
        print_success "Composer cache cleaned"
    else
        print_warn "Composer not available — skipping"
    fi

    print_step "Cleaning mise cache..."
    if command_exists mise && mise cache prune; then
        print_success "mise cache pruned"
    else
        print_warn "mise not available — skipping"
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) print_info "clean has no check"; return 0 ;;
    *) print_error "Usage: clean.zsh apply"; exit 1 ;;
esac
