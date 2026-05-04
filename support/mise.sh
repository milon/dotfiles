#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Checking if mise is installed..."
if ! command_exists mise; then
    print_error "mise not found. Please install Homebrew and run 'dotfiles brew' first."
    return 1
fi

print_success "mise is installed"
print_info "mise version: $(mise --version)"

print_step "Installing tools from mise config..."
if mise install; then
    print_success "All mise tools installed"
else
    print_error "Some mise tools failed to install"
    return 1
fi

print_step "Verifying installed tools..."
mise ls
