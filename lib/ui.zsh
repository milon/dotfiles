#!/bin/zsh
# Shared UI helpers for bin/dot and modules (subprocess-safe).

if [[ -z "${RED:-}" ]]; then
    export ARROW="➜"
    export CHECK=$'\uf00c'
    export CROSS=$'\uf00d'
    export INFO=$'\uf129'
    export WARN=$'\uf071'
    export SECTION=$'\uf120'
    export RED='\033[0;31m'
    export GREEN='\033[0;32m'
    export YELLOW='\033[0;33m'
    export BLUE='\033[0;34m'
    export MAGENTA='\033[0;35m'
    export CYAN='\033[0;36m'
    export BOLD='\033[1m'
    export NC='\033[0m'
fi

print_section() {
    local title=$1
    local rule
    rule=$(printf '─%.0s' {1..60})
    echo
    echo -e "${BOLD}${YELLOW}${SECTION}  ${title}${NC}"
    echo -e "${YELLOW}${rule}${NC}"
}

print_subsection() {
    echo
    echo -e "${BOLD}$1${NC}"
}

print_success() { echo -e "${GREEN}${CHECK}${NC}  $1"; }
print_error()   { echo -e "${RED}${CROSS}${NC}  $1" >&2; }
print_warn()    { echo -e "${YELLOW}${WARN}${NC}  $1"; }
print_info()    { echo -e "${BLUE}${INFO}${NC}  $1"; }
print_step()    { echo -e "${YELLOW}${ARROW}${NC}  $1"; }
print_detail()  { echo -e "    $1"; }

print_stream() {
    local line
    while IFS= read -r line || [[ -n $line ]]; do
        [[ -z $line ]] && continue
        print_detail "$line"
    done
}

# Tree UI shared by `dot help` (matches former `dotfiles help`)
#   print_tree_header  COLOR ICON "Title"
#   print_tree_item    COLOR PREFIX LABEL "description"
print_tree_header() {
    local color=$1 icon=$2 name=$3
    echo
    echo -e "${BOLD}${color}${icon}  ${name}${NC}"
}

print_tree_item() {
    local color=$1 prefix=$2 label=$3 desc=$4
    printf "${color}%s${NC} ${BOLD}%-9s${NC} ${BOLD}${color}->${NC} ${CYAN}%s${NC}\n" \
        "$prefix" "$label" "$desc"
}

command_exists() { command -v "$1" &>/dev/null; }

brew_prefix() {
    if [[ -n "${HOMEBREW_PREFIX:-}" && -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
        print -- "$HOMEBREW_PREFIX"
        return 0
    fi
    [[ -x /opt/homebrew/bin/brew ]] && { print -- /opt/homebrew; return 0; }
    [[ -x /usr/local/bin/brew ]] && { print -- /usr/local; return 0; }
    return 1
}

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

ascii_art() {
    # Block DOT — mint / teal / deep teal
cat << 'EOF'
[0;38;2;150;170;165m     [0;38;2;20;80;70m▀[0;38;2;80;220;180;48;2;20;80;70m▄[0;38;2;20;80;70m▄▄[0;38;2;150;170;165m        [0;38;2;80;220;180;48;2;20;80;70m▀▄[0;38;2;20;80;70m▄▄[0;38;2;150;170;165m   [0m
[0;38;2;150;170;165m      [0;38;2;80;220;180;48;2;20;80;70m▐[0;38;2;160;255;210;48;2;40;180;160m▄[0;38;2;160;255;210;48;2;20;80;70m▄[0;38;2;20;80;70m▌[0;38;2;150;170;165m  [0;38;2;20;80;70m▄▄▄[0;38;2;150;170;165m  [0;38;2;20;80;70m▐[0;38;2;160;255;210;48;2;40;180;160m [0;38;2;160;255;210;48;2;20;80;70m█▌[0;38;2;20;80;70m▄▄[0;38;2;150;170;165m [0m
[0;38;2;150;170;165m [0;38;2;20;80;70m▄[0;38;2;160;255;210;48;2;20;80;70m [0;38;2;80;220;180;48;2;20;80;70m▄▄▄▄[0;38;2;160;255;210;48;2;40;180;160m▄[0;38;2;160;255;210m█[0;38;2;20;80;70m▌▄[0;38;2;80;220;180;48;2;20;80;70m▄[0;38;2;160;255;210;48;2;40;180;160m▄▄[0;38;2;160;255;210;48;2;20;80;70m█▄[0;38;2;20;80;70m▌▐[0;38;2;160;255;210;48;2;40;180;160m [0;38;2;160;255;210;48;2;20;80;70m█▀▀▀[0;38;2;20;80;70m▀[0m
[0;38;2;20;80;70m▐[0;38;2;160;255;210;48;2;20;80;70m▐[0;38;2;80;220;180m█[0;38;2;160;255;210;48;2;20;80;70m█[0;38;2;160;255;210m▌[0;38;2;20;80;70m▐[0;38;2;160;255;210;48;2;20;80;70m▐█[0;38;2;160;255;210m█[0;38;2;20;80;70m▌[0;38;2;80;220;180;48;2;20;80;70m▐[0;38;2;160;255;210;48;2;20;80;70m█▌[0;38;2;20;80;70m▄[0;38;2;160;255;210;48;2;20;80;70m▄█[0;38;2;20;80;70m▌▐[0;38;2;160;255;210;48;2;40;180;160m [0;38;2;160;255;210;48;2;20;80;70m█▌[0;38;2;150;170;165m [0;38;2;160;255;210;48;2;20;80;70m▄[0;38;2;20;80;70m▌[0m
[0;38;2;150;170;165m [0;38;2;0;0;0;48;2;20;80;70m░[0;38;2;80;220;180;48;2;20;80;70m▀[0;38;2;160;255;210;48;2;20;80;70m▀▀▀▀▀▀[0;38;2;0;0;0;48;2;20;80;70m░[0;38;2;20;80;70m▀[0;38;2;160;255;210;48;2;20;80;70m▀▀▀▀[0;38;2;20;80;70m▀[0;38;2;150;170;165m [0;38;2;80;220;180;48;2;20;80;70m▀▀[0;38;2;160;255;210;48;2;20;80;70m▀▀▀▀[0;38;2;20;80;70m▌[0m
EOF
}

dot_noninteractive() {
    [[ "${DOT_NONINTERACTIVE:-0}" == 1 ]]
}

dot_consume_yes_args() {
    typeset -ga REPLY=()
    while (( $# > 0 )); do
        case "$1" in
            --yes|-y)
                export DOT_NONINTERACTIVE=1
                shift
                ;;
            *)
                REPLY=( "$@" )
                return 0
                ;;
        esac
    done
    REPLY=()
}

confirm_or_exit() {
    local prompt_message=$1
    if dot_noninteractive; then
        print_info "${prompt_message} — auto-confirmed (--yes)"
        return 0
    fi
    if read -q "choice?${prompt_message} (y/n) "; then
        echo
        return 0
    fi
    echo
    print_warn "Quitting"
    return 1
}

confirm_yn() {
    local prompt_message=$1
    local default=${2:-no}
    if dot_noninteractive; then
        if [[ "$default" == yes ]]; then
            print_info "${prompt_message} — auto-yes (--yes)"
            return 0
        fi
        print_info "${prompt_message} — auto-no (--yes)"
        return 1
    fi
    if read -q "choice?${prompt_message} (y/n) "; then
        echo
        return 0
    fi
    echo
    return 1
}
