# .dotfiles

```
     ▀▄▄▄        ▀▄▄▄
      ▐▄▄▌  ▄▄▄  ▐ █▌▄▄
 ▄ ▄▄▄▄▄█▌▄▄▄▄█▄▌▐ █▀▀▀▀
▐▐██▌▐▐██▌▐█▌▄▄█▌▐ █▌ ▄▌
 ░▀▀▀▀▀▀▀░▀▀▀▀▀▀ ▀▀▀▀▀▀▌
```

Personal **macOS** bootstrap and day-to-day maintenance CLI (`dot`). Automates Homebrew, mise, Lerd/Podman, yabai/skhd, Ghostty, Neovim, and related tooling.

> Shell scripts target **Zsh** (macOS default). Run `./install` and `dot` from Zsh.

## Quick start

### Prerequisites

1. **Sign in to the Mac App Store** (needed for `mas` packages in the Brewfile).
2. **Update macOS** via System Settings → Software Update.
3. **Rosetta** (Apple Silicon only): `softwareupdate --install-rosetta`
4. **SSH keys** in `~/.ssh` (ed25519 preferred), added to GitHub — clones use SSH remotes.
5. **Xcode Command Line Tools**: `xcode-select --install`

### Install

```bash
git clone git@github.com:milon/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

Noninteractive (auto-confirms prompts; skips Atuin login and SSH key generation):

```bash
./install --yes
# or: DOT_NONINTERACTIVE=1 ./install
```

`./install` ensures Homebrew and CLT when needed, then runs `dot apply` (full setup). Config is symlinked as part of that apply via the `symlinks` module — you do not need a separate post-install symlink step.

Canonical checkout path is `~/.dotfiles`. `DOTFILES_ROOT` is still discovered from the repo, so another path works, but docs and skhd helpers assume this location.

## CLI

After install, `bin/dot` is on your `PATH` (via shell env). Entry points:

```bash
dot                 # same as: dot help
dot help
dot help pull       # per-command help (also: dot pull --help / -h)
dot --yes <command> # apply/brew/git/atuin/precheck only (or DOT_NONINTERACTIVE=1)
```

### Command reference

Run `dot help` for the live categorized tree. Summary:

| Category | Commands | Purpose |
|----------|----------|---------|
| **CORE** | `doctor`, `lint`, `update`, `clean`, `symlinks`, `precheck`, `apply` | Health, maintenance, full setup |
| **SETUP** | `brew`, `shell`, `git`, `atuin`, `xcode`, `mise`, `php`, `lerd` | Tooling install/configure |
| **REPOS** | `clone`, `pull` | Personal git repos from inventory |
| **SYSTEM** | `mac`, `hotkeys`, `manual` | macOS defaults, yabai/skhd, checklist |

Notable details:

- **doctor** — Read-only drift check (Homebrew, symlinks, mise, PHP, Podman/Lerd, git, Sheldon, Atuin, yabai/skhd, SSH, PATH). Non-zero if anything is broken. Alias: `dot check`.
- **apply** — Idempotent full setup (what `./install` finishes with). Optional module list accepts public names: `dot apply brew symlinks clone`.
- **symlinks** — Link `config/` onto `~` / `~/.config` per `inventory/links.toml`. Backups go to `~/.local/share/dot/backup/`.
- **update** — [Topgrade](https://github.com/topgrade-rs/topgrade) using `~/.config/topgrade.toml` when present, else the repo copy.
- **pull --update** — Runs `composer update` in PHP repos, then commits and pushes lockfile bumps (`Updates dependencies`).
- **hotkeys** — Start/reload yabai + skhd; writes `generated/skhd-bin`.
- **shell** — Runs `sheldon lock` after `plugins.toml` changes so new zsh plugins load.

Adding a command: edit [`lib/commands.zsh`](lib/commands.zsh) (registry: module map, descriptions, usage/args/options). Dispatch, list help, per-command `--help`, and tab-completion (`config/zsh/completions/_dot`) all read that file. Help rendering lives in [`lib/help.zsh`](lib/help.zsh).

### Architecture note

`modules/*.zsh` run as **subprocesses** with `set -euo pipefail`. They are never sourced into `bin/dot`, so a module failure cannot leak `cd`/`set -e` into the dispatcher. Standalone helpers under `bin/yabai-*` also use `set -euo pipefail`.

## Layout

```text
~/.dotfiles/
  install                 Bootstrap → brew/CLT → dot apply
  bin/dot                 User CLI
  bin/yabai-*             Window-manager helpers (skhd)
  config/                 All tracked config (one tree)
  inventory/
    Brewfile              Homebrew formulae, casks, MAS
    links.toml            Symlink map (config/ → disk)
    repos.toml            Personal git clones
    packages.toml         Composer globals (mise lives in config/mise/)
  modules/                apply|check scripts
  lib/                    Shared UI, inventory parsers, command registry
  generated/              Gitignored stubs (e.g. skhd-bin)
  tests/lint.zsh          Shell lint (also CI / pre-commit)
  optional/vscode/        Optional VS Code CSS/JS (not symlinked)
```

### One `config/` folder

Apps still split destinations between `~` and `~/.config`. In the **repo**, everything lives under `config/`. Only paths listed in `inventory/links.toml` are symlinked:

| In repo | On disk |
|---------|---------|
| `config/zshrc` | `~/.zshrc` |
| `config/gitignore` | `~/.gitignore` |
| `config/skhdrc` | `~/.skhdrc` |
| `config/yabairc` | `~/.yabairc` |
| `config/sheldon/` | `~/.config/sheldon/` |
| `config/atuin/` | `~/.config/atuin/` |
| `config/nvim/` | `~/.config/nvim/` |
| `config/ghostty/` | `~/.config/ghostty/` |
| `config/fastfetch/` | `~/.config/fastfetch/` |
| `config/mise/` | `~/.config/mise/` |
| `config/topgrade.toml` | `~/.config/topgrade.toml` |

Not linked (sourced via `$DOTFILES_ROOT`): `config/zsh/*.zsh`, `config/zsh_aliases`, `config/fzf.sh`, `config/starship.toml`, `config/gitconfig` (included by `git config --global include.path`).

## What gets installed

Driven by [`inventory/Brewfile`](inventory/Brewfile) and mise:

- **Shell:** Sheldon, Starship, Atuin, zoxide, fzf, eza, bat, …
- **Languages:** mise (node, python, ruby, java, go, rust, …); host PHP/Composer via Homebrew; site runtime is **Lerd on Podman**
- **Editors / terminal:** Neovim, Ghostty, VS Code
- **Desktop:** yabai + skhd, Raycast, 1Password, Chrome, TablePlus, …
- **OrbStack** remains available for Docker Desktop–compatible Compose; Lerd does not use it

Per-machine extras go in untracked `~/.Brewfile.local` (created by `dot precheck`).

## Customization

1. **Secrets / machine overrides:** `~/.zshrc.local` (mode `600`, sourced last). Not tracked.
2. **Shared aliases:** `config/zsh_aliases`.
3. **Zsh plugins:** `config/sheldon/plugins.toml`, then `sheldon lock` (or `dot shell`).
4. **New symlinks:** add files under `config/` and a row in `inventory/links.toml`, then `dot symlinks`.
5. **Homebrew:** shared packages → `inventory/Brewfile`; one-off machine packages → `~/.Brewfile.local`.
6. **Personal repos:** `inventory/repos.toml` (`dot clone` / `dot pull`).
7. **VS Code Custom CSS/JS (optional):** point the [Custom CSS and JS Loader](https://marketplace.visualstudio.com/items?itemName=be5invis.vscode-custom-css) extension at `$DOTFILES_ROOT/optional/vscode/style.css` and `script.js`.

## Day-to-day

```bash
dot doctor          # drift / health
dot brew            # refresh Brewfile packages
dot update          # topgrade
dot clean           # brew/npm/composer/mise caches
dot pull            # update tracked repos
dot hotkeys         # reload yabai + skhd
```

Pre-commit (this repo): `dot lint` + symlink source checks (via `.githooks`).

## Troubleshooting

- **SSH / clone failures:** ensure a key exists and is loaded (`ssh-add -l`), and is on GitHub.
- **Brewfile drift:** `dot brew` (shared + `~/.Brewfile.local`).
- **Broken symlinks after path moves:** `dot symlinks` (conflicts backed up under `~/.local/share/dot/backup/`).
- **Prompt / plugins odd after updates:** open a new shell; run `dot shell` (Sheldon lock) and confirm `STARSHIP_CONFIG` points at `$DOTFILES_ROOT/config/starship.toml`.
- **Lerd / Podman:** `lerd status` / `lerd start`; doctor checks Podman reachability.
- **Unknown command:** `dot help` — registry lives in `lib/commands.zsh`.

## License

See [LICENSE](LICENSE).

## Contact

- Twitter: [@to_milon](https://milon.im/twitter)
- Email: contact[@]milon[.]im
