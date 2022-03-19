# .dotfiles

Dotfiles for my mac, heavily inspired by [Matt Stauffer](https://github.com/mattstauffer/dotfiles)'s dotfiles.

## How to use

- Install [Dropbox](https://www.dropbox.com/install).
- Allow the computer to install Rosetta, if you're on a M1 mac.
- Give Dropbox permissions via accessibility, and allow it to send notifications.
- Sign into Dropbox and sync the files.
- Open the App store and sign in with AppleId.
- Open terminl and `mkdir ~/.ssh && cd ~/.ssh`
- Copy `id_rsa` and `id_rsa.pub` from another machine, or [create a new SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and add it to GitHub. If copying from another machine `chmod 600 ~/.ssh/id_rsa; chmod 600 ~/.ssh/id_rsa.pub`.
- [Create a GitHub personal access token for logging in from the command line.](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token). Give it just full `repo` access. Save that token in a text file or something.
- Type `git`, hit enter, and follow the prompts to install the command line developer tools.
- Clone the repo- `git clone https://github.com/milon/dotfiles.git .dotfiles`
- Run the install script- `./bin/install.sh`
