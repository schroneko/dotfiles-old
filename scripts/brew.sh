#!/usr/bin/env zsh

set -euo pipefail

BREWFILE="$HOME/dotfiles/config/brew/.Brewfile"
BREW_CMD="/opt/homebrew/bin/brew"

function show_help() {
    cat << EOF
使用方法:
    $0 <command>

コマンド:
    dump    現在の状態をBrewfileに保存
    sync    Brewfileの内容をシステムに同期
EOF
}

function dump_brewfile() {
    $BREW_CMD bundle dump --file="$BREWFILE" --force
}

function sync_brewfile() {
    $BREW_CMD bundle --file="$BREWFILE"
}

case "${1:-}" in
    "dump")
        dump_brewfile
        ;;
    "sync")
        sync_brewfile
        ;;
    *)
        show_help
        ;;
esac
