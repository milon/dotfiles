#!/bin/zsh

source "$support_dir/functions.sh"

print_info "There are still a few things that need to be done manually:"
echo

print_step "Open and configure these applications:"
print_info "  • 1Password - log in to your account"
print_info "  • Google Chrome - log in to your account"
print_info "  • Slack / Notion / Linear / ChatGPT - log in (installed via Brewfile; skhd launchers)"
print_info "  • JetBrains Toolbox - install PhpStorm (skhd: rcmd-p)"
print_info "  • Optional: VS Code Custom CSS and JS Loader → files/vscode/ (see README)"
print_info "  • Additional apps as needed"
echo

print_success "Manual steps checklist displayed"
