#!/bin/zsh

# dotfiles lint — static checks for every shell script in the repo.
#   - zsh scripts (and shebang-less *.sh fragments) -> `zsh -n` syntax check
#   - bash scripts (#!/usr/bin/env bash, etc.)      -> shellcheck
#
# shellcheck has no zsh dialect, so zsh files are syntax-checked with `zsh -n`.
# This mirrors .github/workflows/lint.yml so local runs match CI.

source "$support_dir/functions.sh"

cd "$dotfiles_dir" || { print_error "Cannot cd to $dotfiles_dir"; return 1; }

# Candidate scripts: every tracked *.sh plus everything under bin/.
local -a candidates
candidates=( ${(f)"$(git ls-files '*.sh' 'bin/*' | sort -u)"} )

if (( ${#candidates} == 0 )); then
    print_info "No shell scripts found to lint"
    return 0
fi

local have_shellcheck=1
if ! command_exists shellcheck; then
    have_shellcheck=0
    print_info "shellcheck not installed — skipping bash checks (brew install shellcheck)"
fi

typeset -i zsh_fail=0 sc_fail=0 sc_skipped=0 checked=0
local f shebang

for f in $candidates; do
    shebang=$(head -n1 "$f")
    if [[ "$shebang" == *bash* ]]; then
        if (( have_shellcheck )); then
            if shellcheck "$f"; then
                checked+=1
            else
                print_error "shellcheck: $f"
                sc_fail+=1
            fi
        else
            sc_skipped+=1
        fi
    else
        # `zsh -n` prints its own error to stderr on failure.
        if zsh -n "$f"; then
            checked+=1
        else
            print_error "zsh -n: $f"
            zsh_fail+=1
        fi
    fi
done

echo
if (( zsh_fail == 0 && sc_fail == 0 )); then
    print_success "Lint passed: ${checked} script(s) OK"
    (( sc_skipped )) && print_info "${sc_skipped} bash script(s) skipped (shellcheck not installed)"
    return 0
fi

print_error "Lint failed: ${zsh_fail} zsh syntax error(s), ${sc_fail} shellcheck failure(s)"
return 1
