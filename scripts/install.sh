#! /bin/zsh
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
BREW_PREFIX="/opt/homebrew"

# エラーメッセージを表示して終了
error() {
    echo "Error: $1" >&2
    exit 1
}

# 進行状況を表示
info() {
    echo "==> $1"
}

# シンボリックリンクを作成
create_symlink() {
    local src="$1"
    local dst="$2"
    info "Creating symlink: $dst -> $src"
    ln -snfv "$src" "$dst"
}

# macOSチェック
[ "$(uname)" = "Darwin" ] || error "This script is for macOS only!"

# Xcodeコマンドラインツールのインストール
if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install &>/dev/null || error "Failed to install Xcode Command Line Tools"
fi

# dotfilesのクローン
if [ ! -d "$DOTFILES_DIR" ]; then
    info "Cloning dotfiles repository..."
    git clone https://github.com/schroneko/dotfiles.git "$DOTFILES_DIR" || error "Failed to clone repository"
fi

cd "$DOTFILES_DIR" || error "Failed to change directory to $DOTFILES_DIR"

# シンボリックリンクの作成
info "Creating symbolic links..."
create_symlink "$DOTFILES_DIR/config/shell/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/config/shell/.p10k.zsh" "$HOME/.p10k.zsh"
create_symlink "$DOTFILES_DIR/config/shell/.hushlogin" "$HOME/.hushlogin"
create_symlink "$DOTFILES_DIR/config/editor/.vimrc" "$HOME/.vimrc"
create_symlink "$DOTFILES_DIR/config/tmux/.tmux.conf" "$HOME/.tmux.conf"
create_symlink "$DOTFILES_DIR/config/terminal/.alacritty.toml" "$HOME/.alacritty.toml"

# Homebrewのインストール
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" || error "Failed to install Homebrew"
    
    # Apple Silicon Macの場合、PATHを追加
    if [ -d "$BREW_PREFIX" ]; then
        eval "$($BREW_PREFIX/bin/brew shellenv)"
    fi
fi

# パッケージのインストール
info "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/config/brew/.Brewfile" || error "Failed to install packages"

# zshrcの読み込み
if [ -f "$HOME/.zshrc" ]; then
    info "Sourcing .zshrc..."
    source "$HOME/.zshrc"
fi

info "Installation completed successfully!"
