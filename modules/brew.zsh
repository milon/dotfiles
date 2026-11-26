#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

BREWFILE="${DOT_INVENTORY_DIR}/Brewfile"

cmd_apply() {
    if ! command_exists brew; then
        print_step "Homebrew not found, installing..."
        if dot_noninteractive; then
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        local brew_dir
        brew_dir=$(brew_prefix) || {
            print_error "Homebrew install completed but brew binary not found"
            return 1
        }
        if ! grep -q "brew shellenv" "$HOME/.zprofile" 2>/dev/null; then
            echo "eval \"\$(${brew_dir}/bin/brew shellenv)\"" >> "$HOME/.zprofile"
        fi
        eval "$(${brew_dir}/bin/brew shellenv)"
        print_success "Homebrew installed (prefix: ${brew_dir})"
    else
        print_info "Homebrew already installed"
    fi

    print_step "Installing from inventory/Brewfile..."
    if brew bundle --file "$BREWFILE"; then
        print_success "Shared Homebrew dependencies installed"
    else
        print_error "Some Homebrew dependencies failed"
        return 1
    fi

    local local_brewfile="$HOME/.Brewfile.local"
    if [[ -f $local_brewfile ]]; then
        print_step "Installing from ~/.Brewfile.local..."
        if brew bundle --file "$local_brewfile"; then
            print_success "Per-machine Homebrew dependencies installed"
        else
            print_error "Some per-machine Homebrew dependencies failed"
            return 1
        fi
    else
        print_warn "No ~/.Brewfile.local — skipping per-machine packages"
    fi
}

cmd_check() {
    if ! command_exists brew; then
        print_error "brew not on PATH — run: dot brew"
        return 1
    fi
    print_success "brew on PATH ($(brew --version | head -n 1))"
    if brew bundle check --file "$BREWFILE" --no-upgrade &>/dev/null; then
        print_success "Brewfile satisfied"
    else
        print_warn "Brewfile drift — run: dot brew"
        brew bundle check --file "$BREWFILE" --no-upgrade --verbose 2>&1 | print_stream || true
    fi
    if [[ -f "$HOME/.Brewfile.local" ]]; then
        if brew bundle check --file "$HOME/.Brewfile.local" --no-upgrade &>/dev/null; then
            print_success "~/.Brewfile.local satisfied"
        else
            print_warn "Per-machine Brewfile drift — run: dot brew"
        fi
    else
        print_warn "~/.Brewfile.local missing — run: dot precheck"
    fi
    return 0
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: brew.zsh apply|check"; exit 1 ;;
esac
