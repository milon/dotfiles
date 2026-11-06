#!/bin/zsh

source "$support_dir/functions.sh"

if ! command_exists mise; then
    print_error "mise not found — run: dotfiles brew"
    return 1
fi

print_success "mise installed ($(mise --version))"

print_step "Installing tools from mise config..."
if mise install; then
    print_success "All mise tools installed"
else
    print_error "Some mise tools failed to install"
    return 1
fi

print_step "Installed tools"
mise ls | print_stream
