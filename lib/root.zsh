#!/bin/zsh
# Shared paths. bin/dot (or ./install) must export DOTFILES_ROOT before sourcing this.

if [[ -z "${DOTFILES_ROOT:-}" ]]; then
    print -u2 "DOTFILES_ROOT is not set"
    return 1 2>/dev/null || exit 1
fi

export DOTFILES_DIR="$DOTFILES_ROOT" # alias for shell fragments / Sheldon
export DOT_CONFIG_DIR="$DOTFILES_ROOT/config"
export DOT_INVENTORY_DIR="$DOTFILES_ROOT/inventory"
export DOT_MODULES_DIR="$DOTFILES_ROOT/modules"
export DOT_LIB_DIR="$DOTFILES_ROOT/lib"
export DOT_GENERATED_DIR="$DOTFILES_ROOT/generated"
export DOT_BACKUP_DIR="${HOME}/.local/share/dot/backup"
