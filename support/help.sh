#!/bin/zsh

# Help is generated from support/commands.sh — edit that file to add commands.

source "$support_dir/functions.sh"
source "$support_dir/commands.sh"

_dotfiles_print_help() {
    ascii_art
    echo

    echo -e "${BOLD}${CYAN}${ARROW} Usage:${NC} ${YELLOW}${BIN_NAME} [--yes|-y] <command>${NC}"
    echo

    # Helpers — render category header + tree-style command lines.
    print_section_header() {
        local color=$1 icon=$2 name=$3
        echo -e "${BOLD}${color}${icon}  ${name}${NC}"
    }

    print_command() {
        local color=$1 prefix=$2 cmd=$3 desc=$4
        printf "${color}%s${NC} ${BOLD}%-9s${NC} ${BOLD}${color}->${NC} ${CYAN}%s${NC}\n" \
            "$prefix" "$cmd" "$desc"
    }

    local category cmds_var color icon label cmd prefix desc
    local -a cmds cmd_list
    local -i i last

    for category in $DOTFILES_CATEGORIES; do
        cmds_var="DOTFILES_CMDS_${category}"
        cmds=( ${(P)cmds_var} )
        (( ${#cmds} )) || continue

        color=${DOTFILES_CATEGORY_COLOR[$category]}
        icon=${DOTFILES_CATEGORY_ICON[$category]}
        label=${DOTFILES_CATEGORY_LABEL[$category]}
        print_section_header "$color" "$icon" "$label"

        # help is CORE-only and not in the registry (no script to dispatch)
        if [[ $category == core ]]; then
            cmd_list=( help $cmds )
        else
            cmd_list=( $cmds )
        fi

        last=${#cmd_list}
        for (( i = 1; i <= last; i++ )); do
            cmd=${cmd_list[i]}
            prefix="├"
            (( i == last )) && prefix="└"
            if [[ $cmd == help ]]; then
                desc="Show this help message"
            else
                desc=${DOTFILES_CMD_DESC[$cmd]}
            fi
            print_command "$color" "$prefix" "$cmd" "$desc"
        done
        echo
    done

    if dotfiles_noninteractive; then
        print_info "Noninteractive mode on (--yes / DOTFILES_NONINTERACTIVE=1)"
    fi
}

_dotfiles_print_help
