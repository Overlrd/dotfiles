# Set the default terminal and editor
export TERMINAL=alacritty
export EDITOR="nvim"
export VENV_PATH="$HOME/envs/"

# Zsh functions directory
fpath+=~/.zfunc

# Zsh Data Home
ZSH_DATA_HOME=$HOME/.local/share/zsh

# PROMPT
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
PS1='%B%F{cyan}%n@%m %2~${vcs_info_msg_0_}%f%b %# '

# VCS Info settings
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# HISTORY
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# PLUGINS (minimal setup)
plugins=(
   "zsh-users/zsh-syntax-highlighting"
   "zsh-users/zsh-autosuggestions"
   "zsh-users/zsh-completions"
)

# Install plugins if not already installed
for plugin in "${plugins[@]}"; do
    plugin_name="${plugin##*/}"
    if [[ ! -d "$ZSH_DATA_HOME/$plugin_name" ]]; then
        git clone --depth=1 "https://github.com/$plugin.git" "$ZSH_DATA_HOME/$plugin_name"
    fi
done

# Source plugins
source $ZSH_DATA_HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_DATA_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=($ZSH_DATA_HOME/zsh-completions/src $fpath)
autoload -U compinit && compinit

# KEYBINDINGS
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# ALIASES
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias c='clear'
alias x='exit'
alias t='tmux new-session -A -D -s main'
alias vim=nvim

# Go paths
export GOPATH="$HOME/.local/share/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
