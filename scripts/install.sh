#! /bin/zsh
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"

[ "$(uname)" = "Darwin" ] || { echo "This script is for macOS!"; exit 1; }

if ! xcode-select -p &>/dev/null; then
  xcode-select --install &>/dev/null
fi

[ -d "$DOTFILES_DIR" ] || git clone https://github.com/schroneko/dotfiles.git "$DOTFILES_DIR"

cd "$DOTFILES_DIR"

# Create symbolic links
ln -snfv "$DOTFILES_DIR/config/shell/.zshrc" "$HOME/.zshrc"
ln -snfv "$DOTFILES_DIR/config/shell/.p10k.zsh" "$HOME/.p10k.zsh"
ln -snfv "$DOTFILES_DIR/config/shell/.hushlogin" "$HOME/.hushlogin"
ln -snfv "$DOTFILES_DIR/config/editor/.vimrc" "$HOME/.vimrc"
ln -snfv "$DOTFILES_DIR/config/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -snfv "$DOTFILES_DIR/config/terminal/.alacritty.toml" "$HOME/.alacritty.toml"

# Install Homebrew if not installed
command -v brew &>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install packages from Brewfile
brew bundle --file="$DOTFILES_DIR/config/brew/.Brewfile"

# Source zshrc if exists
[ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"
