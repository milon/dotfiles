#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    print_step "Checking for ~/.zshrc.local..."
    if [[ ! -f "$HOME/.zshrc.local" ]]; then
        cat > "$HOME/.zshrc.local" <<'EOF'
# ~/.zshrc.local — per-machine overrides (NOT tracked)
# Sourced last by ~/.zshrc.
EOF
        chmod 600 "$HOME/.zshrc.local"
        print_success "Created ~/.zshrc.local (mode 600)"
    else
        print_info "~/.zshrc.local already exists"
    fi

    print_step "Checking for ~/.Brewfile.local..."
    if [[ ! -f "$HOME/.Brewfile.local" ]]; then
        cat > "$HOME/.Brewfile.local" <<'EOF'
# ~/.Brewfile.local — packages for this machine only (NOT tracked)
# brew 'some-cli'
# cask 'some-app'
EOF
        print_success "Created ~/.Brewfile.local"
    else
        print_info "~/.Brewfile.local already exists"
    fi

    print_step "Checking for SSH keys..."
    local ssh_key_type
    if ssh_key_type=$(detect_ssh_key); then
        print_success "SSH key found (${(U)ssh_key_type})"
    else
        if dot_noninteractive; then
            print_error "SSH keys required before --yes"
            return 1
        fi
        if confirm_yn "Generate a new ED25519 SSH key?"; then
            mkdir -p "$HOME/.ssh"
            chmod 700 "$HOME/.ssh"
            local email=""
            while [[ -z $email ]]; do
                print_step "Email for SSH key:"
                read email
            done
            ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""
            chmod 600 "$HOME/.ssh/id_ed25519"
            chmod 644 "$HOME/.ssh/id_ed25519.pub"
            print_success "SSH key generated — add the public key to GitHub"
        else
            print_error "SSH keys are required"
            return 1
        fi
    fi

    confirm_or_exit "SSH keys linked with access to everything important?" || return 1
    confirm_or_exit "Signed into the Mac App Store?" || return 1
}

cmd_check() {
    [[ -f "$HOME/.zshrc.local" ]] && print_success "~/.zshrc.local present" || print_warn "~/.zshrc.local missing"
    [[ -f "$HOME/.Brewfile.local" ]] && print_success "~/.Brewfile.local present" || print_warn "~/.Brewfile.local missing"
    if detect_ssh_key >/dev/null; then
        print_success "SSH key present"
    else
        print_error "No SSH key"
        return 1
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: precheck.zsh apply|check"; exit 1 ;;
esac
