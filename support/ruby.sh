#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Installing Ruby 3.4.5..."
if frum install 3.4.5; then
    print_success "Ruby 3.4.5 installed"
else
    print_error "Ruby installation failed"
    exit 1
fi

print_step "Setting Ruby 3.4.5 as global version..."
if frum global 3.4.5; then
    print_success "Ruby 3.4.5 set as global version"
    print_info "Ruby version: $(ruby --version)"
else
    print_error "Failed to set global Ruby version"
    exit 1
fi

print_step "Verifying Ruby installation..."
frum versions