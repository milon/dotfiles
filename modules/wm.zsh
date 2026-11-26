#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

write_skhd_stub() {
    mkdir -p "$DOT_GENERATED_DIR"
    local stub="${DOT_GENERATED_DIR}/skhd-bin"
    # Absolute path to repo bin/ for LaunchAgent-safe skhd bindings
    print -r -- "${DOTFILES_ROOT}/bin" > "$stub"
    chmod 644 "$stub"
    print_success "Wrote generated/skhd-bin → ${DOTFILES_ROOT}/bin"
}

manage_service() {
    local cmd=$1
    if ! command_exists "$cmd"; then
        print_step "Installing ${cmd}..."
        brew install "koekeishiya/formulae/${cmd}"
        print_success "${cmd} installed"
    fi
    print_step "Reloading ${cmd}..."
    if "${cmd}" --restart-service >/dev/null 2>&1; then
        print_success "${cmd} restarted"
        return 0
    fi
    if "${cmd}" --start-service; then
        print_success "${cmd} started"
    else
        print_error "Failed to start ${cmd}"
        return 1
    fi
}

cmd_apply() {
    write_skhd_stub
    manage_service yabai
    manage_service skhd
}

cmd_check() {
    local stub="${DOT_GENERATED_DIR}/skhd-bin"
    if [[ -f $stub ]]; then
        print_success "generated/skhd-bin present"
    else
        print_warn "generated/skhd-bin missing — run: dot wm"
    fi
    local cmd
    for cmd in yabai skhd; do
        if ! command_exists "$cmd"; then
            print_warn "$cmd not installed — run: dot brew && dot wm"
            continue
        fi
        if pgrep -x "$cmd" >/dev/null 2>&1; then
            print_success "$cmd running"
        else
            print_warn "$cmd installed but not running — run: dot wm"
        fi
    done
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: wm.zsh apply|check"; exit 1 ;;
esac
