#!/bin/zsh
# Symfony-style per-command help for bin/dot.
# Expects BIN_NAME, lib/commands.zsh, and lib/ui.zsh.

# Resolve a user-facing command name to the canonical help key (has DOT_CMD_DESC).
dot_help_canonical() {
    local cmd=$1
    if [[ -n ${DOT_CMD_DESC[$cmd]:-} ]]; then
        print -r -- "$cmd"
        return 0
    fi
    local spec=${DOT_CMD_MODULE[$cmd]:-}
    [[ -n $spec ]] || return 1
    local name
    for name in ${(k)DOT_CMD_DESC}; do
        if [[ ${DOT_CMD_MODULE[$name]:-} == "$spec" ]]; then
            print -r -- "$name"
            return 0
        fi
    done
    return 1
}

# Print help for one command.
dot_cmd_help() {
    local requested=${1:?}
    local cmd
    if ! cmd=$(dot_help_canonical "$requested"); then
        print_error "Unknown command: '${requested}'"
        echo
        print_info "Run ${YELLOW}${BIN_NAME} help${NC} to list commands"
        return 1
    fi

    local desc=${DOT_CMD_DESC[$cmd]}
    local usage_suffix=${DOT_CMD_USAGE[$cmd]:-}
    local args_blob=${DOT_CMD_ARGS[$cmd]:-}
    local opts_blob=${DOT_CMD_OPTS[$cmd]:-}
    local has_yes=0
    [[ "$opts_blob" == y\|yes$'\t'* || "$opts_blob" == *$'\n'y\|yes$'\t'* ]] && has_yes=1

    echo
    echo -e "${BOLD}Description:${NC}"
    echo -e "  ${desc}"
    if [[ -n ${DOT_CMD_HELP[$cmd]:-} ]]; then
        local line
        for line in ${(f)DOT_CMD_HELP[$cmd]}; do
            echo -e "  ${line}"
        done
    fi

    echo
    echo -e "${BOLD}Usage:${NC}"
    if (( has_yes )); then
        if [[ -n $usage_suffix ]]; then
            echo -e "  ${YELLOW}${BIN_NAME}${NC} [${YELLOW}--yes${NC}|${YELLOW}-y${NC}] ${YELLOW}${cmd}${NC} ${usage_suffix}"
        else
            echo -e "  ${YELLOW}${BIN_NAME}${NC} [${YELLOW}--yes${NC}|${YELLOW}-y${NC}] ${YELLOW}${cmd}${NC}"
        fi
    else
        if [[ -n $usage_suffix ]]; then
            echo -e "  ${YELLOW}${BIN_NAME}${NC} ${YELLOW}${cmd}${NC} ${usage_suffix}"
        else
            echo -e "  ${YELLOW}${BIN_NAME}${NC} ${YELLOW}${cmd}${NC}"
        fi
    fi

    local -a aliases=()
    local name spec canon_spec
    canon_spec=${DOT_CMD_MODULE[$cmd]:-}
    if [[ -n $canon_spec ]]; then
        for name in ${(k)DOT_CMD_MODULE}; do
            [[ $name == "$cmd" ]] && continue
            [[ ${DOT_CMD_MODULE[$name]} == "$canon_spec" ]] && aliases+=("$name")
        done
    fi
    if (( ${#aliases} )); then
        echo
        echo -e "${BOLD}Aliases:${NC}"
        echo -e "  ${(j:, :)aliases}"
    fi

    if [[ -n $args_blob ]]; then
        echo
        echo -e "${BOLD}Arguments:${NC}"
        local arg_line arg_name arg_desc
        for arg_line in ${(f)args_blob}; do
            arg_name=${arg_line%%	*}
            arg_desc=${arg_line#*	}
            printf "  ${GREEN}%-16s${NC} %s\n" "$arg_name" "$arg_desc"
        done
    fi

    echo
    echo -e "${BOLD}Options:${NC}"
    local opt_line opt_keys opt_desc short long padded
    if [[ -n $opts_blob ]]; then
        for opt_line in ${(f)opts_blob}; do
            opt_keys=${opt_line%%	*}
            opt_desc=${opt_line#*	}
            if [[ $opt_keys == *\|* ]]; then
                short=${opt_keys%%\|*}
                long=${opt_keys#*\|}
                padded="-${short}, --${long}"
            else
                padded="--${opt_keys}"
            fi
            printf "  ${GREEN}%-18s${NC} %s\n" "$padded" "$opt_desc"
        done
    fi
    printf "  ${GREEN}%-18s${NC} %s\n" "-h, --help" "Display help for the command"
    echo
}
