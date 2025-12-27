#!/bin/zsh

# Color constants (if not already defined)
if [[ -z "${RED:-}" ]]; then
    export ARROW="➜"
    export CHECK="✓"
    export CROSS="✗"
    export INFO="ℹ"
    export RED='\033[0;31m'
    export GREEN='\033[0;32m'
    export YELLOW='\033[0;33m'
    export BLUE='\033[0;34m'
    export CYAN='\033[0;36m'
    export BOLD='\033[1m'
    export NC='\033[0m'
fi

# Output helpers
print_section() {
    local title=$1
    echo
    echo -e "${BOLD}${CYAN}${ARROW} ${title}${NC}"
    echo -e "${CYAN}$(printf '─%.0s' {1..60})${NC}"
}

print_success() {
    local message=$1
    echo -e "${GREEN}${CHECK} ${message}${NC}"
}

print_error() {
    local message=$1
    echo -e "${RED}${CROSS} ${message}${NC}" >&2
}

print_info() {
    local message=$1
    echo -e "${BLUE}${INFO} ${message}${NC}"
}

print_step() {
    local message=$1
    echo -e "${YELLOW}${ARROW} ${message}${NC}"
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
    else
        echo
        echo "Quitting..."
        exit 1
    fi
}

title () {
    title=$1
    title_length=${#title}
    leftover=$(expr 30 - $title_length)

    echo 
    printf "$title "
    printf '=%.0s' {1..$leftover}
    echo 
}

run_step() {
    local step_name=$1
    local script=$2
    
    print_section "$step_name"
    source "$script"
    cd "$dotfiles_dir"
}
