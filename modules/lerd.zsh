#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    if ! command_exists lerd; then
        print_error "lerd not found — run: dot brew"
        return 1
    fi
    print_step "Installing Lerd services..."
    if lerd install; then
        print_success "Lerd installed"
        lerd path:disable >/dev/null || true
    else
        print_error "Lerd installation failed"
        return 1
    fi
    mkdir -p "$HOME/Code"
    print_step "Parking Lerd in ~/Code..."
    if lerd park "$HOME/Code"; then
        print_success "Lerd parked in ~/Code"
    else
        print_error "Failed to park Lerd"
        return 1
    fi
    print_info "Projects in ~/Code are served at <folder>.test"
}

cmd_check() {
    if ! command_exists podman; then
        print_warn "podman not on PATH — Lerd needs Podman"
    elif podman info &>/dev/null; then
        print_success "podman reachable"
    else
        print_warn "podman not reachable — run: lerd start"
    fi
    if ! command_exists lerd; then
        print_warn "lerd not installed — run: dot brew && dot lerd"
        return 0
    fi
    if lerd status &>/dev/null; then
        print_success "lerd status OK"
    else
        print_warn "lerd status reported problems — run: lerd status / lerd start"
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: lerd.zsh apply|check"; exit 1 ;;
esac
