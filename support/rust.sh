#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Checking if rustup is already installed..."
if command -v rustup &> /dev/null; then
    print_info "rustup is already installed"
    print_info "Rust version: $(rustc --version 2>/dev/null || echo 'Not available')"
else
    print_step "Installing Rust using rustup..."
    if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
        print_success "Rust installed"
        
        # Source cargo to make it available in current shell
        if [ -f "$HOME/.cargo/env" ]; then
            source "$HOME/.cargo/env"
            print_info "Rust version: $(rustc --version)"
            print_info "Cargo version: $(cargo --version)"
        fi
    else
        print_error "Rust installation failed"
        exit 1
    fi
fi
