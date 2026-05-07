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

run_step() {
    local step_name=$1
    local script=$2

    print_section "$step_name"
    source "$script"
    local ec=$?
    cd "$dotfiles_dir" 2>/dev/null || cd / || true
    if (( ec != 0 )); then
        print_error "Step failed: ${step_name} (exit ${ec})"
        exit "$ec"
    fi
}
