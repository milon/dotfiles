#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Cleaning Homebrew cache..."
if brew cleanup; then
    print_success "Homebrew cache cleaned"
fi

print_step "Removing unused Homebrew dependency formulae..."
print_detail "brew autoremove — formulae installed only as deps and no longer needed"
if brew autoremove --quiet; then
    print_success "Homebrew autoremove done"
fi

print_step "Cleaning npm cache..."
if npm cache clean --force 2>/dev/null; then
    print_success "npm cache cleaned"
else
    print_warn "npm not available — skipping"
fi

print_step "Cleaning Composer cache..."
if composer clear-cache 2>/dev/null; then
    print_success "Composer cache cleaned"
else
    print_warn "Composer not available — skipping"
fi

print_step "Cleaning mise cache..."
if command_exists mise && mise cache prune; then
    print_success "mise cache pruned"
else
    print_warn "mise not available — skipping"
fi
