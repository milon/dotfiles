# .dotfiles

```
   _     _   ___ _ _         
 _| |___| |_|  _|_| |___ ___ 
| . | . |  _|  _| | | -_|_ -|
|___|___|_| |_| |_|_|___|___|
```

Personal macOS bootstrap: Homebrew, mise, Lerd/Podman, yabai/skhd, Ghostty, Neovim.

> Testing the rewrite? Stay on branch `greenfield`. `master` is the previous system until you cut over.

## Quick start

1. Sign in to the Mac App Store, install CLT (`xcode-select --install`), set up SSH keys.
2. Clone to the canonical path:

```bash
git clone git@github.com:milon/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git checkout greenfield   # while testing the rewrite
./install
# or: ./install --yes
```

`./install` ensures Homebrew/CLT, then runs `dot apply`.

## CLI

```bash
dot help
dot apply [module...]    # idempotent setup
dot check [module...]    # health check (doctor)
dot link                 # symlink config/ only
dot update               # topgrade
dot clone / dot pull     # personal repos
dot atuin / dot clean / dot lint / dot manual
```

Global flag: `dot --yes …` or `DOT_NONINTERACTIVE=1`.

Modules run as **subprocesses** (`set -euo pipefail`). They are never sourced into the dispatcher.

## Layout

```text
~/.dotfiles/
  install            bootstrap
  bin/dot            CLI
  config/            all tracked config (one tree)
  inventory/         Brewfile, links.toml, repos.toml, packages.toml
  modules/           apply|check scripts
  lib/               shared helpers
  generated/         gitignored stubs (from `dot wm`)
```

### One `config/` folder

On disk, apps still use `~` and `~/.config`. In the repo everything lives under `config/`. Destinations are declared in `inventory/links.toml`.

Unlisted paths under `config/` (zsh fragments, starship, aliases) are sourced via `$DOTFILES_ROOT`, not symlinked.

### Inventory

| File | Role |
|------|------|
| `inventory/Brewfile` | Homebrew formulae, casks, MAS |
| `inventory/links.toml` | Symlink map |
| `inventory/repos.toml` | Personal git clones |
| `inventory/packages.toml` | Composer globals (+ mise notes) |
| `~/.Brewfile.local` | Per-machine brew extras (untracked) |

## Notes

- Checkout is `~/.dotfiles`; `DOTFILES_ROOT` is still discovered so other paths work.
- Secrets stay in `~/.zshrc.local` (mode 600).
- `dot pull --update` runs `composer update` and **does not** auto-commit; commit lockfile bumps yourself.
- Roll back to the old system: `git checkout master` (old `bin/dotfiles` lives only on master).

## License

See [LICENSE](LICENSE).
