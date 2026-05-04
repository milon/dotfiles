#!/bin/zsh

source "$support_dir/functions.sh"

PLUG_VIM="$HOME/.vim/autoload/plug.vim"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

print_step "Installing vim-plug..."
if [ ! -f "$PLUG_VIM" ]; then
    if curl -fsSLo "$PLUG_VIM" --create-dirs "$PLUG_URL"; then
        print_success "vim-plug installed"
    else
        print_error "Failed to download vim-plug from $PLUG_URL"
        return 1
    fi
else
    print_info "vim-plug already installed, skipping download"
fi

print_step "Installing Vim plugins via vim-plug..."
if vim +'PlugInstall --sync' +qall; then
    print_success "Vim plugins installed"
else
    print_error "Vim plugin installation failed"
    return 1
fi
