#!/bin/zsh

source "$support_dir/functions.sh"

print_info "Remaining manual setup:"
print_detail "1Password — log in"
print_detail "Atuin Hub — run: dotfiles atuin"
print_detail "Lerd — run: dotfiles lerd; Compose apps need proxy.port then lerd link"
print_detail "Google Chrome — log in"
print_detail "Slack / Notion / Linear / ChatGPT — log in if installed (~/.Brewfile.local)"
print_detail "JetBrains Toolbox — install PhpStorm (skhd: rcmd-p)"
print_detail "Optional: VS Code Custom CSS/JS Loader → optional/vscode/ (see README)"
