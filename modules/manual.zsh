#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    print_info "Remaining manual setup:"
    print_detail "1Password — log in"
    print_detail "Atuin Hub — run: dot atuin"
    print_detail "Lerd — run: dot lerd; Compose apps need proxy then lerd link"
    print_detail "Google Chrome — log in"
    print_detail "Slack / Notion / Linear / ChatGPT — log in if installed (~/.Brewfile.local)"
    print_detail "JetBrains Toolbox — install PhpStorm (skhd: rcmd-p)"
    print_detail "Optional: VS Code Custom CSS/JS Loader → optional/vscode/"
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) return 0 ;;
    *) print_error "Usage: manual.zsh apply"; exit 1 ;;
esac
