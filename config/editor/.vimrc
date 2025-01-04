" ====================
" プラグイン設定
" ====================
" vim-plugのインストール
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" プラグインの読み込み
filetype plugin on
call plug#begin()
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install', 'for': ['markdown', 'text', 'vim-plug'] }
Plug 'ryanoasis/vim-devicons'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Prettierのチェックと設定
if !executable('prettier')
  echohl WarningMsg
  echom "Warning: Prettier is not installed. Please install it using 'npm install -g prettier' or 'volta install prettier'."
  echohl None
endif
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

" Markdown Preview設定
let g:mkdp_filetypes = ['markdown', 'text']
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0

" ====================
" 基本設定
" ====================
" ファイル関連
set autoread         " ファイルが外部で変更された時に自動で読み直す
set nobackup         " バックアップファイルを作成しない
set noswapfile       " スワップファイルを作成しない
set path+=**         " ファイル検索パスの設定

" システム連携
set clipboard+=unnamed " システムのクリップボードを使用
set viminfo=         " viminfo ファイルを作成しない

" ====================
" 表示設定
" ====================
" UI表示
set number           " 行番号を表示
set cursorline       " カーソル行をハイライト
set ruler            " カーソル位置を表示
set laststatus=0     " ステータスラインを非表示
set visualbell       " ビープ音を視覚表示に
set showmatch        " 対応する括弧を表示

" 文字表示
set ambiwidth=double " 全角文字の表示設定
syntax on            " シンタックスハイライトを有効化

" 補完と検索
set wildmenu         " コマンドライン補完を強化
set wildmode=longest:full,full " 補完モードの設定
set wildignorecase   " 補完時に大文字小文字を区別しない
set hlsearch         " 検索結果をハイライト
set ignorecase       " 大文字小文字を区別しない
set incsearch        " インクリメンタルサーチ
set wrapscan         " 検索時にファイル末尾まで行ったら先頭に戻る
set shortmess-=S     " 検索結果数を表示
set re=0             " 正規表現エンジンの設定

" ====================
" 編集設定
" ====================
" インデント
set autoindent       " 自動インデント
set smartindent      " スマートインデント
set expandtab        " タブを空白に変換
set tabstop=4        " タブ幅を4に設定
set softtabstop=4    " ソフトタブ幅を4に設定
set shiftwidth=4     " インデント幅を4に設定

" カーソル移動
set backspace=indent,eol,start " バックスペースの動作設定
set virtualedit=onemore " 行末の1文字先までカーソルを移動可能に
set whichwrap=h,l   " h,lで行をまたぐことができる

" ====================
" キーマッピング
" ====================
" 基本操作
inoremap jj <ESC>
nmap ; :

" 機能キー
nnoremap <Esc><Esc> :nohlsearch<Enter>
nnoremap <C-n> :Prettier<Enter>
nmap <C-p> <Plug>MarkdownPreviewToggle
