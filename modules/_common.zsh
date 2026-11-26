#!/bin/zsh
# Sourced at the top of every module (after set -euo pipefail in the module).
# Expects DOTFILES_ROOT to be set by the caller (bin/dot or install).

if [[ -z "${DOTFILES_ROOT:-}" ]]; then
    # Allow direct `zsh modules/foo.zsh apply` for debugging
    export DOTFILES_ROOT=$(cd "$(dirname "$0")/.." && pwd)
fi

source "$DOTFILES_ROOT/lib/root.zsh"
source "$DOTFILES_ROOT/lib/ui.zsh"
source "$DOTFILES_ROOT/lib/inventory.zsh"
