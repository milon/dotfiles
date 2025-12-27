#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Installing Vim plugins..."
if vim +PluginInstall +qall; then
    print_success "Vim plugins installed"
else
    print_error "Vim plugin installation failed"
    exit 1
fi
