#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    for cmd in php pie composer; do
        if ! command_exists "$cmd"; then
            print_error "$cmd not found — run: dot brew"
            return 1
        fi
    done
    print_info "PHP: $(php --version | head -n 1)"
    print_info "pie: $(pie --version | head -n 1)"
    print_info "Composer: $(composer --version | head -n 1)"

    dot_load_composer_packages
    if (( ${#reply_composer_packages} == 0 )); then
        reply_composer_packages=(psy/psysh)
    fi
    print_step "Installing global Composer packages..."
    if composer global require "${reply_composer_packages[@]}"; then
        print_success "Global Composer packages installed"
    else
        print_error "Composer global require failed"
        return 1
    fi
}

cmd_check() {
    typeset -i err=0
    for cmd in php composer pie; do
        if command_exists "$cmd"; then
            print_success "$cmd on PATH"
        else
            print_warn "$cmd not on PATH — run: dot brew && dot php"
            err=1
        fi
    done
    if command_exists composer && composer global show tightenco/takeout &>/dev/null; then
        print_warn "tightenco/takeout still installed — remove with: composer global remove tightenco/takeout"
    fi
    (( err == 0 ))
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: php.zsh apply|check"; exit 1 ;;
esac
