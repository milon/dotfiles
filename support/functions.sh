#!/bin/zsh

# Color constants (if not already defined)
if [[ -z "${RED:-}" ]]; then
    export ARROW="➜"
    export CHECK=$'\uf00c'
    export CROSS=$'\uf00d'
    export INFO=$'\uf129'
    export RED='\033[0;31m'
    export GREEN='\033[0;32m'
    export YELLOW='\033[0;33m'
    export BLUE='\033[0;34m'
    export MAGENTA='\033[0;35m'
    export CYAN='\033[0;36m'
    export BOLD='\033[1m'
    export NC='\033[0m'
fi

# Output helpers
print_section() {
    local title=$1
    local icon=$'\uf120'  # nf-fa-terminal — "command-line action"
    local rule=$(printf '─%.0s' {1..60})
    echo
    echo -e "${BOLD}${YELLOW}${icon}  ${title}${NC}"
    echo -e "${YELLOW}${rule}${NC}"
}

print_success() {
    local message=$1
    echo -e "${GREEN}${CHECK}${NC}  ${message}"
}

print_error() {
    local message=$1
    echo -e "${RED}${CROSS}${NC}  ${message}" >&2
}

print_info() {
    local message=$1
    echo -e "${BLUE}${INFO}${NC}  ${message}"
}

print_step() {
    local message=$1
    echo -e "${YELLOW}${ARROW}${NC}  ${message}"
}

# Helper functions
command_exists() {
    command -v "$1" &> /dev/null
}

# Detect Homebrew prefix on this machine. Echoes the prefix on success, returns
# non-zero when brew is not found at any standard location. Apple Silicon →
# /opt/homebrew, Intel → /usr/local. Honors $HOMEBREW_PREFIX if already set.
brew_prefix() {
    if [[ -n "${HOMEBREW_PREFIX:-}" && -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
        print -- "$HOMEBREW_PREFIX"
        return 0
    fi
    if [[ -x /opt/homebrew/bin/brew ]]; then
        print -- /opt/homebrew
        return 0
    fi
    if [[ -x /usr/local/bin/brew ]]; then
        print -- /usr/local
        return 0
    fi
    return 1
}

# Detect the first SSH key present in $HOME/.ssh. On success, echoes the key
# type (ed25519|rsa|ecdsa) and returns 0. Returns 1 when no key is found.
detect_ssh_key() {
    local kt
    for kt in ed25519 rsa ecdsa; do
        if [[ -f "$HOME/.ssh/id_${kt}" && -f "$HOME/.ssh/id_${kt}.pub" ]]; then
            print -- "$kt"
            return 0
        fi
    done
    return 1
}

# Functions

ascii_art () {
    cat << 'EOF'
   _     _   ___ _ _         
 _| |___| |_|  _|_| |___ ___ 
| . | . |  _|  _| | | -_|_ -|
|___|___|_| |_| |_|_|___|___|
EOF
}

confirm_or_exit() {
    local prompt_message=$1

    if read -q "choice?${prompt_message} (y/n) "; then
        echo
        return 0
    else
        echo
        echo "Quitting..."
        return 1
    fi
}

# Run a single dotfiles "step" (a support/ script). Used by both install.sh
# (top-level orchestration) and bin/dotfiles (single-command dispatch).
#
# Usage:
#   run_step <display_name> <script> [args...]
#
# <script> may be either a bare file name (resolved against $support_dir) or
# an absolute path. Extra args are forwarded to the sourced script as $1, $2…
#
# Behavior:
#   - Prints a section header, sources the script, prints a footer.
#   - On script failure, prints an error and either exits or returns based on
#     the $DOTFILES_EXIT_ON_STEP_FAILURE flag (install.sh sets it to 1 to fail
#     fast across the whole install; the per-command dispatcher leaves it 0).
run_step() {
    local display_name=$1
    local script=$2
    shift 2

    local script_path
    if [[ "$script" == /* ]]; then
        script_path=$script
    else
        script_path="$support_dir/$script"
    fi

    if [[ ! -f $script_path ]]; then
        print_error "Script not found: $script"
        if [[ "${DOTFILES_EXIT_ON_STEP_FAILURE:-0}" == 1 ]]; then
            exit 1
        fi
        return 1
    fi

    print_section "$display_name"
    set -- "$@"
    source "$script_path"
    local ec=$?
    cd "$dotfiles_dir" 2>/dev/null || true

    if (( ec == 0 )); then
        echo
        print_success "${display_name} completed successfully"
        return 0
    fi

    echo
    print_error "${display_name} failed (exit code: ${ec})"
    if [[ "${DOTFILES_EXIT_ON_STEP_FAILURE:-0}" == 1 ]]; then
        exit "$ec"
    fi
    return "$ec"
}
