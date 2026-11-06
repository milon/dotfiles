setopt AUTO_CD
export EDITOR='nvim'
export STARSHIP_CONFIG="$DOTFILES_DIR/files/home/starship.toml"
export PATH="$PATH:$HOME/.composer/vendor/bin:$HOME/.config/composer/vendor/bin"
export PATH="$PATH:$DOTFILES_DIR/bin"
export PATH="$PATH:$HOME/bin:$HOME/.config/phpmon/bin:$HOME/.local/bin"

# Intel Homebrew ncurses keg only (absent on Apple Silicon /opt/homebrew)
if [[ -d /usr/local/opt/ncurses/bin ]]; then
    export PATH="/usr/local/opt/ncurses/bin:$PATH"
fi
