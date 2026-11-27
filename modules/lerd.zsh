#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

# lerd install appends "# Lerd completions" + fpath/compinit to ~/.zshrc.
# ~/.zshrc is a symlink into this repo, so that dirties git on every apply.
# Completions already load via config/zsh/compinit.zsh → site-functions.
lerd_strip_zshrc_completions() {
    local zshrc="${HOME}/.zshrc"
    [[ -e $zshrc ]] || return 0
    grep -q '^# Lerd completions' "$zshrc" 2>/dev/null || return 0

    local tmp
    tmp=$(mktemp)
    # Drop the injected block, then trim trailing blank lines (keep one final \n).
    awk '
        /^# Lerd completions$/ { skip=1; next }
        skip && /^fpath=/ { next }
        skip && /compinit/ { next }
        skip && /^[[:space:]]*$/ { skip=0; next }
        skip { next }
        { print }
    ' "$zshrc" | awk '
        NF { for (; blank > 0; blank--) print ""; print; next }
        { blank++ }
    ' > "$tmp"

    if ! cmp -s "$zshrc" "$tmp"; then
        cat "$tmp" > "$zshrc"
        print_info "Removed Lerd-injected zshrc snippet (completions via sheldon/compinit)"
    fi
    rm -f "$tmp"
}

lerd_ensure_completions() {
    local dir="${HOME}/.local/share/zsh/site-functions"
    mkdir -p "$dir"
    if lerd completion zsh > "${dir}/_lerd" 2>/dev/null; then
        print_success "Lerd zsh completions → ${dir}/_lerd"
    else
        print_warn "Could not refresh Lerd zsh completions"
    fi
}

cmd_apply() {
    if ! command_exists lerd; then
        print_error "lerd not found — run: dot brew"
        return 1
    fi

    if [[ -f "${HOME}/.config/lerd/config.yaml" ]]; then
        print_info "Lerd already installed — skipping install"
    else
        print_step "Installing Lerd services..."
        if lerd install; then
            print_success "Lerd installed"
        else
            print_error "Lerd installation failed"
            return 1
        fi
    fi

    lerd path:disable >/dev/null || true
    lerd_strip_zshrc_completions
    lerd_ensure_completions

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
    if grep -q '^# Lerd completions' "${HOME}/.zshrc" 2>/dev/null; then
        print_warn "Lerd snippet still in zshrc — run: dot lerd"
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: lerd.zsh apply|check"; exit 1 ;;
esac
