#!/bin/zsh
set -euo pipefail

# エラーメッセージを表示して終了
error() {
    echo "Error: $1" >&2
    exit 1
}

# 進行状況を表示
info() {
    echo "==> $1"
}

# 管理者権限の確認
if [ "$(whoami)" != "root" ]; then
    info "一部の設定には管理者権限が必要です"
fi

# ====================
# システム設定
# ====================
info "システム設定を適用中..."

# キーボード設定
defaults write -g ApplePressAndHoldEnabled -bool false    # キーリピートを有効化
defaults write -g InitialKeyRepeat -int 15                # キーリピート開始までの時間
defaults write -g KeyRepeat -int 2                        # キーリピートの速度
defaults write .GlobalPreferences NSAutomaticCapitalizationEnabled -bool false  # 自動大文字化を無効化

# ファイル表示設定
defaults write -g AppleShowAllExtensions -bool true       # 全ての拡張子を表示
defaults write -g AppleShowAllFiles -bool true            # 隠しファイルを表示

# 開発者向け設定
defaults write -g WebKitDeveloperExtras -bool true        # WebKit開発者ツール有効化

# ====================
# 入力デバイス設定
# ====================
info "入力デバイス設定を適用中..."

# トラックパッド設定
defaults write -g com.apple.trackpad.scaling 2            # トラックパッドの速度
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true  # タップでクリック

# ====================
# Finder設定
# ====================
info "Finder設定を適用中..."

# 表示設定
defaults write com.apple.finder ShowPathbar -bool true    # パスバーを表示
defaults write com.apple.finder WarnOnEmptyTrash -bool false  # ゴミ箱を空にする時の警告を無効化

# .DS_Store設定
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true  # ネットワークドライブ
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true      # USBドライブ

# ====================
# Dock設定
# ====================
info "Dock設定を適用中..."

defaults write com.apple.dock autohide -bool true         # 自動的に隠す
defaults write com.apple.dock show-recents -bool false    # 最近使用したアプリを非表示
defaults write com.apple.dock static-only -bool true      # 固定のアプリのみ表示
defaults write com.apple.dock persistent-apps -array      # アプリをすべて削除
defaults write com.apple.dock show-process-indicators -bool false  # プロセスインジケータを非表示

# ====================
# セキュリティ設定
# ====================
info "セキュリティ設定を適用中..."

# ダウンロードしたアプリの警告を無効化
defaults write com.apple.LaunchServices LSQuarantine -bool false

# 起動音を無効化（管理者権限が必要）
if [ "$(whoami)" = "root" ]; then
    nvram SystemAudioVolume=" "
else
    info "起動音の設定をスキップしました（管理者権限が必要です）"
fi

# ====================
# 設定の反映
# ====================
info "設定を反映中..."

for app in "Dock" "Finder" "SystemUIServer" "System Preferences"; do
    killall "$app" &>/dev/null || true
done

info "macOSの設定が完了しました"
info "一部の設定を反映するには再起動が必要です"
