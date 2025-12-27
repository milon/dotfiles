#!/bin/zsh

source "$support_dir/functions.sh"

# Install Vundle.vim if not already installed
print_step "Installing Vundle.vim..."
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    mkdir -p "$HOME/.vim/bundle"
    if git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim" > /dev/null 2>&1; then
        print_success "Vundle.vim installed"
    else
        print_error "Failed to install Vundle.vim"
        exit 1
    fi
else
    print_info "Vundle.vim already installed, skipping"
fi

# Install Vim plugins
print_step "Installing Vim plugins..."
if vim +PluginInstall +qall; then
    print_success "Vim plugins installed"
else
    print_error "Vim plugin installation failed"
    exit 1
fi
