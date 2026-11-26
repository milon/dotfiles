#!/bin/zsh
set -euo pipefail

export DOTFILES_ROOT=${DOTFILES_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}
source "$DOTFILES_ROOT/lib/root.zsh"
source "$DOTFILES_ROOT/lib/ui.zsh"

lint_main() {
    cd "$DOTFILES_ROOT"

    local -a candidates
    candidates=( ${(f)"$(git ls-files '*.zsh' 'bin/*' '.githooks/*' 'install' 'tests/*' 'lib/*' 'modules/*' | sort -u)"} )

    local f
    for f in bin/dot install tests/lint.zsh modules/*.zsh lib/*.zsh; do
        [[ -f $f ]] || continue
        [[ ${candidates[(Ie)$f]} -eq 0 ]] && candidates+=("$f")
    done

    typeset -i zsh_fail=0 sc_fail=0 sc_skipped=0 checked=0
    local have_shellcheck=1 shebang
    command_exists shellcheck || have_shellcheck=0

    for f in ${(u)candidates}; do
        [[ -f $f ]] || continue
        [[ $f == modules/_common.zsh ]] && continue
        shebang=$(head -n1 "$f" 2>/dev/null || true)
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
        (( sc_skipped )) && print_warn "${sc_skipped} bash script(s) skipped (no shellcheck)"
        return 0
    fi
    print_error "Lint failed: ${zsh_fail} zsh / ${sc_fail} shellcheck"
    return 1
}

lint_main
