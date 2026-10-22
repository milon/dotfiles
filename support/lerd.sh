#!/bin/zsh

# Lerd serves .test on both machines. PHP and static projects in ~/Code are
# parked. A Docker Compose app stays on 127.0.0.1 and gets a proxy block in
# its own .lerd.yaml, then `lerd link`. Host PHP stays installed for CLI tools.

source "$support_dir/functions.sh"

if ! command_exists lerd; then
    print_error "lerd not found — run 'dotfiles brew' to install it from the Brewfile"
    return 1
fi

print_step "Installing Lerd services..."
if lerd install; then
    print_success "Lerd installed"
    lerd path:disable >/dev/null || true
else
    print_error "Lerd installation failed"
    return 1
fi

print_step "Setting up Code directory..."
mkdir -p "$HOME/Code"

print_step "Parking Lerd in the Code directory..."
if lerd park "$HOME/Code"; then
    print_success "Lerd parked in ~/Code"
else
    print_error "Failed to park Lerd"
    return 1
fi

print_info "Projects in ~/Code are served at <folder>.test."
print_info "A Compose app needs proxy.port in its .lerd.yaml, then: lerd link"
