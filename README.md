# .dotfiles

Dotfiles for my mac, took inspirations from [dotfiles](https://dotfiles.github.io/).

## How to use

- Open the App store and sign in with AppleId.
- Update macOS with the latest version.
- Allow the computer to install Rosetta, if you're on a M1 mac. Run the following command- `softwareupdate --install-rosetta`
- Open terminl and `mkdir ~/.ssh && cd ~/.ssh`
- Copy `id_rsa` and `id_rsa.pub` from another machine, or [create a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and add it to GitHub. If copying from another machine `chmod 600 ~/.ssh/id_rsa; chmod 600 ~/.ssh/id_rsa.pub`.
- [Create a GitHub personal access token for logging in from the command line.](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token). Give it just full `repo` access. Save that token in a text file or something.
- Type `git`, hit enter, and follow the prompts to install the command line developer tools.
- Clone the repo- `git clone git@github.com:milon/dotfiles.git ~/.dotfiles`
- Go to the directory by `cd ~/.dotfiles`
- Run the install script- `./install.sh`

## `dotfiles` executable

You will have an executable in your path.

```
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

## Suggestions

Please tweet [@to_milon](https://milon.im/twitter) or email at contact[@]milon[.]im
