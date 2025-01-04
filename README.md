# My Dotfiles Repo

## インストール方法

```bash
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/schroneko/dotfiles/main/scripts/install.sh)"
```

## ディレクトリ構造

```
dotfiles/
├── assets/           # 画像などのアセットファイル
│   └── alacritty.png
├── config/           # 各種設定ファイル
│   ├── brew/         # Homebrew関連
│   │   └── .Brewfile
│   ├── editor/       # エディタ設定
│   │   └── .vimrc
│   ├── shell/        # シェル関連設定
│   │   ├── .hushlogin
│   │   └── .zshrc
│   ├── starship/     # Starship設定
│   │   └── starship.toml
│   ├── terminal/     # ターミナル設定
│   │   └── .alacritty.toml
│   └── tmux/         # Tmux設定
│       └── .tmux.conf
└── scripts/          # 各種スクリプト
    ├── brew.sh      # Homebrew管理用
    ├── install.sh    # インストール用
    ├── macos.sh      # macOS設定用
    └── sync.sh       # 設定同期用
```

## Homebrew パッケージの管理

```bash
# 新しいパッケージをインストールした後
./scripts/brew.sh dump    # 現在の状態を Brewfile に保存

# 新しい環境のセットアップ時
./scripts/brew.sh sync    # Brewfile からパッケージをインストール
```
