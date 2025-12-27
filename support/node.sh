#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Creating NVM directory..."
if [ ! -d "$HOME/.nvm" ]; then
    mkdir -p "$HOME/.nvm"
    print_success "NVM directory created"
else
    print_info "NVM directory already exists"
fi

print_step "Loading NVM..."
if [ -f "$(brew --prefix nvm)/nvm.sh" ]; then
    source "$(brew --prefix nvm)/nvm.sh"
    export NVM_DIR="$HOME/.nvm"
    print_success "NVM loaded"
else
    print_error "NVM not found. Please install nvm via Homebrew first."
    exit 1
fi

print_step "Installing latest Node.js..."
if nvm install node; then
    print_success "Node.js installed"
    print_info "Node.js version: $(node --version)"
else
    print_error "Node.js installation failed"
    exit 1
fi
