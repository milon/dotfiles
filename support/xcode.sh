#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Updating existing software..."
if softwareupdate --install --all; then
    print_success "Software updates installed"
else
    print_info "No software updates available or update failed"
fi

echo
print_step "Checking Xcode command line tools..."
if xcode-select --version &>/dev/null; then
    print_info "Xcode command line tools already installed"
    print_info "Version: $(xcode-select --version)"
else
    print_step "Installing Xcode command line tools..."
    print_info "Please follow the installation prompt that appears"
    xcode-select --install
    print_success "Xcode command line tools installation initiated"
fi
