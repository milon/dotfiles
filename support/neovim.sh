#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Checking Neovim health..."
if nvim +checkhealth +qall; then
    print_success "Neovim health check completed"
else
    print_error "Neovim health check failed"
    exit 1
fi
