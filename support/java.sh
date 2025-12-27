#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Installing Temurin JDK 21..."
if brew install --cask temurin@21; then
    print_success "Temurin JDK 21 installed"
else
    print_error "JDK installation failed"
    exit 1
fi

print_step "Adding JDK to jenv..."
if jenv add /Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/; then
    print_success "JDK added to jenv"
else
    print_error "Failed to add JDK to jenv"
    exit 1
fi

print_step "Setting Java 21 as global version..."
if jenv global 21; then
    print_success "Java 21 set as global version"
    print_info "Java version: $(java -version 2>&1 | head -n 1)"
else
    print_error "Failed to set global Java version"
    exit 1
fi
