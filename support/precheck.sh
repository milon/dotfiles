#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Checking for ~/.zshrc.local (per-machine overrides)..."
if [ ! -f "$HOME/.zshrc.local" ]; then
    cat > "$HOME/.zshrc.local" <<'EOF'
# ~/.zshrc.local — per-machine overrides (NOT tracked by dotfiles)
#
# This file is sourced at the end of ~/.zshrc, so anything you put here
# overrides settings from the dotfiles repo. Use it for:
#   - personal aliases you don't want in version control
#   - work-only secrets / API tokens
#   - host-specific PATH entries
#   - proxies, AWS profiles, kubeconfigs
#
# Example:
#   alias work='cd ~/work'
#   export OPENAI_API_KEY="..."
#   export PATH="$HOME/work/bin:$PATH"
EOF
    print_success "Created ~/.zshrc.local with a getting-started header"
else
    print_info "~/.zshrc.local already exists"
fi

# Check for SSH keys (RSA, ED25519, or ECDSA)
print_step "Checking for SSH keys..."
has_ssh_key=false
ssh_key_type=""

if [ -f "$HOME/.ssh/id_rsa" ] && [ -f "$HOME/.ssh/id_rsa.pub" ]; then
    has_ssh_key=true
    ssh_key_type="RSA"
elif [ -f "$HOME/.ssh/id_ed25519" ] && [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    has_ssh_key=true
    ssh_key_type="ED25519"
elif [ -f "$HOME/.ssh/id_ecdsa" ] && [ -f "$HOME/.ssh/id_ecdsa.pub" ]; then
    has_ssh_key=true
    ssh_key_type="ECDSA"
fi

if [ "$has_ssh_key" = true ]; then
    print_success "SSH key found (${ssh_key_type})"
else
    print_info "No SSH keys found"
    echo
    
    if read -q "choice?Would you like to generate a new ED25519 SSH key? (y/n) "; then
        echo
        echo
        
        print_step "Creating .ssh directory..."
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
        print_success ".ssh directory created"
        
        print_step "Enter your email address for the SSH key:"
        read email
        
        print_step "Generating ED25519 SSH key..."
        if ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519" -N ""; then
            chmod 600 "$HOME/.ssh/id_ed25519"
            chmod 644 "$HOME/.ssh/id_ed25519.pub"
            print_success "SSH key generated successfully"
            print_info "Public key location: $HOME/.ssh/id_ed25519.pub"
            print_info "Remember to add this key to GitHub, GitLab, or your servers"
        else
            print_error "SSH key generation failed"
            return 1
        fi
    else
        echo
        print_error "SSH keys are required. Please generate them manually or copy from a previous computer."
        return 1
    fi
fi

echo
print_step "Verifying prerequisites..."
confirm_or_exit "Do you have SSH keys linked that have access to everything important?" || return 1
confirm_or_exit "Have you signed into the Mac App Store manually?" || return 1
