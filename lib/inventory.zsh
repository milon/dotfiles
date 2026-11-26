#!/bin/zsh
# Minimal TOML readers for inventory/*.toml (key = "value" under [section]).

dot_trim() {
    local s=$1
    # Leading/trailing whitespace (spaces + tabs)
    while [[ "$s" == [[:space:]]* ]]; do s=${s#?}; done
    while [[ "$s" == *[[:space:]] ]]; do s=${s%?}; done
    print -r -- "$s"
}

dot_unquote() {
    local s
    s=$(dot_trim "$1")
    if [[ "$s" == \"*\" ]]; then
        s=${s#\"}
        s=${s%\"}
    fi
    print -r -- "$s"
}

# Expand leading ~ in a path.
# Note: escape \~ in ${var#…} patterns — bare ~ expands to $HOME in zsh.
dot_expand_path() {
    local p
    p=$(dot_trim "$1")
    if [[ "$p" == "~" ]]; then
        print -r -- "$HOME"
    elif [[ "$p" == "~/"* ]]; then
        print -r -- "$HOME/${p#\~/}"
    else
        print -r -- "$p"
    fi
}

# Load [links] from inventory/links.toml into associative array reply_links.
dot_load_links() {
    typeset -gA reply_links=()
    local file="${DOT_INVENTORY_DIR}/links.toml"
    [[ -f $file ]] || { print_error "Missing $file"; return 1; }

    local section="" line key val
    while IFS= read -r line || [[ -n $line ]]; do
        # Strip comments
        if [[ "$line" == *#* ]]; then
            line=${line%%#*}
        fi
        line=$(dot_trim "$line")
        [[ -z $line ]] && continue
        if [[ $line == \[*\] ]]; then
            section=${line[2,-2]}
            continue
        fi
        [[ $section == links ]] || continue
        if [[ $line == *=* ]]; then
            key=$(dot_unquote "${line%%=*}")
            val=$(dot_unquote "${line#*=}")
            [[ -n $key ]] || continue
            reply_links[$key]=$(dot_expand_path "$val")
        fi
    done < "$file"
}

# Load repos.toml → reply_code_dir + associative reply_repos.
dot_load_repos() {
    typeset -g reply_code_dir="${HOME}/Code"
    typeset -gA reply_repos=()
    local file="${DOT_INVENTORY_DIR}/repos.toml"
    [[ -f $file ]] || { print_error "Missing $file"; return 1; }

    local section="" line key val
    while IFS= read -r line || [[ -n $line ]]; do
        if [[ "$line" == *#* ]]; then
            line=${line%%#*}
        fi
        line=$(dot_trim "$line")
        [[ -z $line ]] && continue
        if [[ $line == \[*\] ]]; then
            section=${line[2,-2]}
            continue
        fi
        if [[ $line == *=* ]]; then
            key=$(dot_unquote "${line%%=*}")
            val=$(dot_unquote "${line#*=}")
            if [[ -z $section && $key == code_dir ]]; then
                reply_code_dir=$(dot_expand_path "$val")
            elif [[ $section == repos ]]; then
                reply_repos[$key]=$val
            fi
        fi
    done < "$file"
}

# Load composer.global.packages from packages.toml into reply_composer_packages.
dot_load_composer_packages() {
    typeset -ga reply_composer_packages=()
    local file="${DOT_INVENTORY_DIR}/packages.toml"
    [[ -f $file ]] || return 0

    local section="" line raw item
    while IFS= read -r line || [[ -n $line ]]; do
        if [[ "$line" == *#* ]]; then
            line=${line%%#*}
        fi
        line=$(dot_trim "$line")
        [[ -z $line ]] && continue
        if [[ $line == \[*\] ]]; then
            section=${line[2,-2]}
            continue
        fi
        [[ $section == composer.global ]] || continue
        if [[ $line == packages*=* ]]; then
            raw=${line#*=}
            raw=$(dot_trim "$raw")
            raw=${raw#\[}
            raw=${raw%\]}
            for item in ${(s:,:)raw}; do
                item=$(dot_unquote "$item")
                [[ -n $item ]] && reply_composer_packages+=("$item")
            done
        fi
    done < "$file"
}
