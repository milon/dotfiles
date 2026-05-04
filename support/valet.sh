#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Installing Valet..."
if valet install; then
    print_success "Valet installed"
else
    print_error "Valet installation failed"
    return 1
fi

print_step "Trusting Valet certificates..."
if valet trust; then
    print_success "Valet certificates trusted"
else
    print_error "Failed to trust Valet certificates"
    return 1
fi

print_step "Setting up Code directory..."
mkdir -p "$HOME/Code"
cd "$HOME/Code" || return 1

print_step "Parking Valet in Code directory..."
if valet park; then
    print_success "Valet parked in Code directory"
else
    print_error "Failed to park Valet"
    return 1
fi

cd "$dotfiles_dir" 2>/dev/null || true