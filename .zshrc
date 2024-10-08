# ZSH Data Home
ZSH_DATA_HOME=$HOME/.local/share/zsh

# PROMPT
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
PS1='%F{cyan}%2~${vcs_info_msg_0_}%f $ '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# HISTORY
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# PLUGINS
plugins=(
   "zsh-users/zsh-syntax-highlighting"
   "zsh-users/zsh-autosuggestions"
   "zsh-users/zsh-completions"
)

# Install plugins
for plugin in "${plugins[@]}"; do
    plugin_name="${plugin##*/}"
    if [[ ! -d "$ZSH_DATA_HOME/$plugin_name" ]]; then
        git clone --depth=1 "https://github.com/$plugin.git" "$ZSH_DATA_HOME/$plugin_name"
    fi
done

# Setup plugins
source $ZSH_DATA_HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_DATA_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=($ZSH_DATA_HOME/zsh-completions/src $fpath)
autoload -U compinit && compinit

# Completion settings
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# KEYBINDINGS
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# ALIASES
alias ls='ls --color=auto -lh'
alias grep='grep --color=auto'
alias vim='nvim'
alias c='clear'
alias x='exit'
alias t='tmux new-session -A -D -s main'

# EXPORT PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export GOPATH="$HOME/.local/share/go"
export PATH="$GOPATH/bin:$PATH"
