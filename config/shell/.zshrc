autoload -U +X compinit && compinit

#
# Path Configuration
#
# Base PATH
export PATH="/opt/homebrew/bin:$PATH"

# Development tools
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Additional tools
export PATH="/opt/homebrew/opt/john-jumbo/share/john:$PATH"

#
# Environment Setup
#
eval $(/opt/homebrew/bin/brew shellenv)

# Starship config
export STARSHIP_CONFIG="$HOME/dotfiles/config/starship/starship.toml"

#
# Aliases
#
# File listing
if command -v eza &> /dev/null; then
    alias ls='eza --group-directories-first'
    alias tree='eza --tree'
else
    alias ls='ls -G'
fi

# System maintenance
alias update='brew update && brew upgrade --greedy && brew cleanup'

# Quick access
alias note='vim $HOME/Downloads/text.md'
alias icloud='cd "$HOME/Library/Mobile Documents/com~apple~CloudDocs/"'

#
# Load Custom Functions
#
function load_function() {
    local func_file="$1"
    if [ -f "$func_file" ]; then
        source "$func_file"
    else
        echo "Warning: Function file not found: $func_file"
    fi
}

# Load all function files
for func in $HOME/dotfiles/config/shell/functions/*.zsh; do
    load_function "$func"
done

#
# History Configuration
#
if command -v gtac >/dev/null 2>&1; then
    tac="gtac"
elif command -v tac >/dev/null 2>&1; then
    tac="tac"
else
    tac="tail -r"
fi

function peco-select-history() {
    BUFFER=$(fc -l -n 1 | eval $tac | awk '!a[$0]++' | peco --query "$LBUFFER")
    CURSOR=${#BUFFER}
}

zle -N peco-select-history
bindkey '^R' peco-select-history

#
# General Settings
#
export HISTSIZE=10000
export SAVEHIST=10000
export LANG=en_US.UTF-8
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export MANPAGER="col -b -x|vim -R -c 'set ft=man nolist nomod noma' -"

#
# ZSH Options
#
# Directory navigation
setopt auto_cd

# History
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt share_history

# Completion
setopt complete_in_word
setopt list_packed

#
# Completion Settings
#
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#
# Plugin Sources
#
# Function to source plugins safely
source_plugin() {
    local plugin_path="$1"
    local plugin_name="$2"
    if [ -f "$plugin_path" ]; then
        source "$plugin_path"
    else
        echo "Warning: $plugin_name plugin not found at $plugin_path"
    fi
}

source_plugin "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" "zsh-autosuggestions"
source_plugin "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "zsh-syntax-highlighting"

#
# Starship Prompt
#
eval "$(starship init zsh)"

#
# VSCode Integration
#
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
