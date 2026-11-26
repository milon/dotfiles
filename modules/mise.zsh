#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    if ! command_exists mise; then
        print_error "mise not found — run: dot brew"
        return 1
    fi
    print_success "mise ($(mise --version))"
    print_step "Installing tools from config/mise..."
    if ( cd "$DOTFILES_ROOT" && mise install ); then
        print_success "All mise tools installed"
    else
        print_error "Some mise tools failed"
        return 1
    fi
    mise ls | print_stream
}

cmd_check() {
    if ! command_exists mise; then
        print_error "mise not on PATH — run: dot brew"
        return 1
    fi
    print_success "mise installed ($(mise --version))"
    local missing
    if missing=$(mise ls --missing 2>/dev/null) && [[ -n "$missing" ]]; then
        print_warn "Some mise tools missing — run: dot mise"
        print -r -- "$missing" | print_stream
    else
        print_success "All configured mise tools installed"
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: mise.zsh apply|check"; exit 1 ;;
esac
