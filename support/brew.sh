#!/bin/zsh

source "$support_dir/functions.sh"

if (! command -v brew &> /dev/null); then
    print_step "Homebrew not found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/milon/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    print_success "Homebrew installed"
else
    print_info "Homebrew already installed, skipping installation"
fi

echo
print_step "Installing Homebrew dependencies from Brewfile..."
if brew bundle --file "$support_dir/Brewfile"; then
    print_success "All Homebrew dependencies installed"
else
    print_error "Some Homebrew dependencies failed to install"
    exit 1
fi
