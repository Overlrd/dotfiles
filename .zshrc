# Promt
# https://salferrarello.com/zsh-git-status-prompt/
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
PROMPT='%F{yellow}%m%f%F{cyan}${vcs_info_msg_0_} %% '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# Environment variables
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
ZSH_PLUGINS_DIR="$HOME/.local/share/zsh"

# PLugins
plugins=(
   "zsh-users/zsh-syntax-highlighting.git"
   "zsh-users/zsh-autosuggestions.git"
   "zsh-users/zsh-completions.git"
)

for plugin in "${plugins[@]}"; do
    plugin_name="${plugin##*/}"
    plugin_name="${plugin_name%.git}"
    if [[ ! -d "$ZSH_PLUGINS_DIR/$plugin_name" ]]; then
        git clone --depth=1 "https://github.com/$plugin" "$ZSH_PLUGINS_DIR/$plugin_name"
    fi
done

source $ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.cache/zsh/history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Init completion
autoload -U compinit && compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# Aliases
alias ls='ls --color=auto'
alias vim='nvim'
alias c='clear'
alias x='exit'
alias t='tmux'

# Path
fpath=($ZSH_PLUGINS_DIR/zsh-completions/src $fpath)
# Set up PATH variable correctly
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/nvim-linux64/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="/opt/dart-sass:$PATH"
