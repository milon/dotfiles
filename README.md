# .dotfiles

Dotfiles for my mac, took inspirations from [dotfiles](https://dotfiles.github.io/).

## How to use

- Open the App store and sign in with AppleId.
- Update macOS with the latest version.
- Install [Dropbox](https://www.dropbox.com/install).
- Allow the computer to install Rosetta, if you're on a M1 mac. Run the following command- `softwareupdate --install-rosetta`
- Give Dropbox permissions via accessibility, and allow it to send notifications.
- Sign into Dropbox and sync the files.
- Open terminl and `mkdir ~/.ssh && cd ~/.ssh`
- Copy `id_rsa` and `id_rsa.pub` from another machine, or [create a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and add it to GitHub. If copying from another machine `chmod 600 ~/.ssh/id_rsa; chmod 600 ~/.ssh/id_rsa.pub`.
- [Create a GitHub personal access token for logging in from the command line.](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token). Give it just full `repo` access. Save that token in a text file or something.
- Type `git`, hit enter, and follow the prompts to install the command line developer tools.
- It assumes the dotfiles will be in `~/.dotfiles` directory. If you want to change this, you can change it in `config.sh` file in the root of the repository.
- Clone the repo- `git clone git@github.com:milon/dotfiles.git ~/.dotfiles`
- Go to the directory by `cd ~/.dotfiles`
- Run the install script- `./install.sh`

## `dotfiles` executable

You will have an executable in your path.

```
$ dotfiles
   _     _   ___ _ _
 _| |___| |_|  _|_| |___ ___
| . | . |  _|  _| | | -_|_ -|
|___|___|_| |_| |_|_|___|___|

➜ Usage: dotfiles <command>

Commands:
   help             This help message
   update           Update packages and pkg managers (brew, mac app store, commposer)
   clean            Clean up caches (brew, npm, composer)
   symlinks         Run symlinks script
   brew             Run brew script
   node             Run node setup script
   python           Run python setup script
   java             Run java setup script
   composer         Run composer setup script
   valet            Run valet script
   git              Run git config script
   clone            Run git clone script
   pull             Run git pull script to update all repos
   mac              Run MacOS defaults script
   xcode            Run XCode script
   vim              Run vim script
   neovim           Run neovim script
```

## Todo

- Backup application config with `mackup`

## Suggestions

Please tweet [@to_milon](https://milon.im/twitter) or email at contact[@]milon[.]im
