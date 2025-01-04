# dotfiles

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
│   │   ├── .zshrc
│   │   └── functions/
│   │       ├── crack.zsh
│   │       └── extract.zsh
│   ├── terminal/     # ターミナル設定
│   │   └── .alacritty.toml
│   └── tmux/         # Tmux設定
│       └── .tmux.conf
└── scripts/          # 各種スクリプト
    ├── brew.sh       # Homebrew管理用
    ├── install.sh    # 初期セットアップ用
    └── macos.sh      # macOS設定用

```

## 管理方法

### Homebrew パッケージの管理

```bash
# 新しいパッケージをインストールした後
./scripts/brew.sh dump    # 現在の状態をBrewfileに保存

# 新しい環境のセットアップ時
./scripts/brew.sh sync    # Brewfileからパッケージをインストール
```

### macOS 設定の適用

```bash
# キーリピートやDockの設定など、macOSのシステム設定を適用
./scripts/macos.sh
```
