#!/bin/zsh

source "$support_dir/functions.sh"

ascii_art
echo

echo -e "${BOLD}${CYAN}${ARROW} Usage:${NC} ${YELLOW}${BIN_NAME} <command>${NC}"
echo

# Helpers — render category header + tree-style command lines.
# `->` separator, bold command name, fixed-width padding for alignment.
print_section_header() {
    local color=$1 icon=$2 name=$3
    echo -e "${BOLD}${color}${icon}  ${name}${NC}"
}

print_command() {
    local color=$1 prefix=$2 cmd=$3 desc=$4
    printf "${color}%s${NC} ${BOLD}%-9s${NC} ${BOLD}${color}->${NC} ${CYAN}%s${NC}\n" \
        "$prefix" "$cmd" "$desc"
}

# ─── CORE ────────────────────────────────────────────────────────────────
print_section_header "$YELLOW" $'\ueb45' "CORE"
print_command "$YELLOW" "├" "help"     "Show this help message"
print_command "$YELLOW" "├" "doctor"   "Diagnose installation drift"
print_command "$YELLOW" "├" "update"   "Run Topgrade across all package managers"
print_command "$YELLOW" "├" "clean"    "Clean caches (brew, npm, Composer, mise)"
print_command "$YELLOW" "└" "symlinks" "Create symlinks for dotfiles"
echo

# ─── SETUP ───────────────────────────────────────────────────────────────
print_section_header "$BLUE" $'\uf0ad' "SETUP"
print_command "$BLUE" "├" "brew"  "Install Homebrew and dependencies"
print_command "$BLUE" "├" "git"   "Configure Git settings"
print_command "$BLUE" "├" "xcode" "Install Xcode / CLI tools"
print_command "$BLUE" "├" "mise"  "Setup mise (node, python, ruby, java, go, rust)"
print_command "$BLUE" "├" "php"   "Setup PHP and Composer"
print_command "$BLUE" "└" "valet" "Setup Laravel Valet"
echo

# ─── REPOS ───────────────────────────────────────────────────────────────
print_section_header "$GREEN" $'\uea84' "REPOS"
print_command "$GREEN" "├" "clone" "Clone personal Git repositories"
print_command "$GREEN" "└" "pull"  "Update all Git repositories"
echo

# ─── EDITORS ─────────────────────────────────────────────────────────────
print_section_header "$CYAN" $'\uf489' "EDITORS"
print_command "$CYAN" "├" "vim"    "Setup Vim (vim-plug + plugins)"
print_command "$CYAN" "└" "neovim" "Setup Neovim"
echo

# ─── SYSTEM ──────────────────────────────────────────────────────────────
print_section_header "$MAGENTA" $'\uf179' "SYSTEM"
print_command "$MAGENTA" "├" "mac"     "Configure macOS settings"
print_command "$MAGENTA" "└" "hotkeys" "Start/reload yabai + skhd"
echo
