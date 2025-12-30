#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Adding Homebrew taps..."
brew tap shivammathur/php
brew tap shivammathur/extensions
print_success "Homebrew taps added"

print_step "Installing PHP..."
if brew install php; then
    print_success "PHP installed"
    print_info "PHP version: $(php --version | head -n 1)"
else
    print_error "PHP installation failed"
    exit 1
fi

print_step "Installing Composer..."
if brew install composer; then
    print_success "Composer installed"
else
    print_error "Composer installation failed"
    exit 1
fi

print_step "Installing global Composer packages..."
if composer global require laravel/valet tightenco/takeout:~2.0 psy/psysh; then
    print_success "Global Composer packages installed"
else
    print_error "Some global packages failed to install"
    exit 1
fi

