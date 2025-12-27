#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Installing Python 3.12..."
if pyenv install 3.12; then
    print_success "Python 3.12 installed"
else
    print_error "Python 3.12 installation failed"
    exit 1
fi

print_step "Setting Python 3.12 as global version..."
if pyenv global 3.12; then
    print_success "Python 3.12 set as global version"
    print_info "Python version: $(python --version 2>&1)"
else
    print_error "Failed to set global Python version"
    exit 1
fi
