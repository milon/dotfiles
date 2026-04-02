#!/bin/zsh

source "$support_dir/functions.sh"

ascii_art
echo
echo -e "${BOLD}${CYAN}${ARROW} Usage: ${YELLOW}${BIN_NAME} <command>${NC}"
echo
echo -e "${BOLD}${GREEN}Commands:${NC}"
echo
echo -e "  ${YELLOW}help${NC}             ${CYAN}Show this help message${NC}"
echo -e "  ${YELLOW}update${NC}           ${CYAN}Run Topgrade (brew, casks, mas, mise, extensions, Composer, … per files/config/topgrade.toml)${NC}"
echo -e "  ${YELLOW}clean${NC}            ${CYAN}Clean Homebrew cache, autoremove unused deps, npm/Composer/mise caches${NC}"
echo
echo -e "  ${BOLD}Setup:${NC}"
echo -e "  ${YELLOW}symlinks${NC}         ${CYAN}Create symlinks for dotfiles${NC}"
echo -e "  ${YELLOW}brew${NC}             ${CYAN}Install Homebrew and dependencies${NC}"
echo -e "  ${YELLOW}git${NC}              ${CYAN}Configure Git settings${NC}"
echo
echo -e "  ${BOLD}Languages:${NC}"
echo -e "  ${YELLOW}mise${NC}             ${CYAN}Setup mise (node, python, ruby, java, go, rust)${NC}"
echo -e "  ${YELLOW}php${NC}              ${CYAN}Setup PHP and Composer${NC}"
echo
echo -e "  ${BOLD}Development:${NC}"
echo -e "  ${YELLOW}valet${NC}            ${CYAN}Setup Laravel Valet${NC}"
echo -e "  ${YELLOW}clone${NC}            ${CYAN}Clone Git repositories${NC}"
echo -e "  ${YELLOW}pull${NC}             ${CYAN}Update all Git repositories${NC}"
echo
echo -e "  ${BOLD}Editors:${NC}"
echo -e "  ${YELLOW}vim${NC}              ${CYAN}Setup Vim${NC}"
echo -e "  ${YELLOW}neovim${NC}           ${CYAN}Setup Neovim${NC}"
echo
echo -e "  ${BOLD}System:${NC}"
echo -e "  ${YELLOW}mac${NC}              ${CYAN}Configure macOS settings${NC}"
echo -e "  ${YELLOW}xcode${NC}            ${CYAN}Setup Xcode / CLI tools${NC}"
echo
