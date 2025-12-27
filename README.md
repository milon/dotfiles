# .dotfiles

```
   _     _   ___ _ _         
 _| |___| |_|  _|_| |___ ___ 
| . | . |  _|  _| | | -_|_ -|
|___|___|_| |_| |_|_|___|___|
```

Personal dotfiles configuration for macOS. Automates the setup of development environment, system preferences, and development tools.

> Inspired by [dotfiles.github.io](https://dotfiles.github.io/)


## Quick Start

### Prerequisites

Before running the installation, complete these steps:

1. **Sign in to Mac App Store**
   - Open App Store and sign in with your Apple ID

2. **Update macOS**
   - Go to System Settings → Software Update
   - Install the latest macOS version

3. **Install Rosetta (Apple Silicon only)**
   ```bash
   softwareupdate --install-rosetta
   ```

4. **Set up SSH keys**
   ```bash
   mkdir -p ~/.ssh && cd ~/.ssh
   ```
   
   - **Option A:** Copy SSH keys from another machine:
     ```bash
     # Copy id_rsa and id_rsa.pub (or id_ed25519/id_ecdsa)
     chmod 600 ~/.ssh/id_rsa
     chmod 644 ~/.ssh/id_rsa.pub
     ```
   
   - **Option B:** [Generate a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
     - The installer will prompt you to create one if none are found

5. **Create GitHub Personal Access Token**
   - [Create a token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) with `repo` scope
   - Save it securely (you'll need it for git operations)

6. **Install Command Line Tools**
   ```bash
   git
   ```
   - Follow the prompts to install Xcode Command Line Tools

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:milon/dotfiles.git ~/.dotfiles
   ```

2. **Run the installer**
   ```bash
   cd ~/.dotfiles
   ./install.sh
   ```

The installer will guide you through the setup process with interactive prompts.

## Usage

After installation, you'll have a `dotfiles` command available in your terminal.

### View Available Commands

```bash
dotfiles help
```

or simply:

```bash
dotfiles
```

### Command Reference

```bash
➜ dotfiles
   _     _   ___ _ _
 _| |___| |_|  _|_| |___ ___
| . | . |  _|  _| | | -_|_ -|
|___|___|_| |_| |_|_|___|___|
➜ Usage: dotfiles <command>

Commands:

  help             Show this help message
  update           Update packages and pkg managers (brew, mac app store, composer)
  clean            Clean up caches (brew, npm, composer)

  Setup:
  symlinks         Create symlinks for dotfiles
  brew             Install Homebrew and dependencies
  git              Configure git settings

  Languages:
  node             Setup Node.js environment
  python           Setup Python environment
  java             Setup Java environment
  ruby             Setup Ruby environment
  composer         Setup PHP Composer

  Development:
  valet            Setup Laravel Valet
  clone            Clone git repositories
  pull             Update all git repositories

  Editors:
  vim              Setup Vim
  neovim           Setup Neovim

  System:
  mac              Configure macOS settings
  xcode            Setup Xcode
```

## What Gets Installed

### Development Tools
- **Editors:** Vim, Neovim (NvChad)
- **Version Managers:** nvm, pyenv, frum (Ruby), jenv (Java)
- **Languages:** Node.js, Python, PHP, Ruby, Java
- **Databases:** SQLite, DBngin (MySQL, PostgreSQL, Redis)
- **Other:** Git, Composer, Laravel Valet, Mailpit, Meilisearch

### Applications
- **Development:** Visual Studio Code, Bruno (API client), OrbStack (Docker)
- **Productivity:** 1Password, Raycast, Obsidian, Bartender
- **System:** Aldente, MonitorControl, Latest
- **Media:** IINA, YouTube Music
- **Terminal:** Ghostty

### System Configuration
- Shell configuration (Zsh with Antigen)
- Git configuration with aliases and colors
- macOS system preferences
- Symlinks for dotfiles


## Customization

### Adding Your Own Configurations

1. **Custom aliases:** Edit `~/.custom_aliases` (created automatically)
2. **Dotfiles:** Add files to `files/` directory and update `support/sym_links.sh`
3. **Homebrew packages:** Add to `support/Brewfile`

### Repository Configuration

- **Git repositories:** Edit `support/git_clone.sh` to add your repositories
- **Git pull list:** Edit `support/pull.sh` to manage repository updates


## Troubleshooting

### Installation Issues

- **SSH key errors:** Ensure your SSH keys are properly configured and added to GitHub
- **Homebrew errors:** Make sure you have admin privileges and internet connection
- **Permission errors:** Some scripts may require `sudo` for system-level changes

### Common Commands

```bash
# Re-run a specific setup step
dotfiles brew

# Check what will be installed
cat support/Brewfile

# View installation logs
# Check the output from install.sh for specific errors
```


## Notes

- The installer will prompt you for confirmation at various steps
- Some steps require manual intervention (e.g., signing into apps)
- The `manual_steps.sh` script will remind you of remaining manual tasks


## Contributing

This is a personal dotfiles repository, but suggestions and improvements are welcome!

## Contact

- Twitter: [@to_milon](https://milon.im/twitter)
- Email: contact[@]milon[.]im


## License

See [LICENSE](LICENSE) file for details.
