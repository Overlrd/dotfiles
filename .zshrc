# Zsh Configuration
# References:
# https://thevaluable.dev/zsh-install-configure-mouseless/
# https://thevaluable.dev/zsh-line-editor-configuration-mouseless/

# Colors - Enable colored output for various commands
autoload -U colors && colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Shell Options
setopt AUTO_CD              # Automatically change to directory if name is typed
setopt CORRECT              # Command correction
setopt AUTO_PUSHD           # Automatically push directories onto directory stack
setopt PUSHD_IGNORE_DUPS    # Avoid duplicate directories in the stack
setopt HIST_IGNORE_ALL_DUPS # Remove duplicate history entries
setopt HIST_REDUCE_BLANKS   # Remove excess blanks in history
setopt HIST_VERIFY          # Show command with history expansion to user before running it
setopt SHARE_HISTORY        # Share history between all sessions
setopt APPEND_HISTORY       # Append to history file, don't overwrite it

# Environment Variables
export EDITOR="nvim"
export TERMINAL="foot"

# History Configuration
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# Enhanced Completion
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' menu select                   # Interactive menu selection

# VCS Info Configuration
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats ' (%b%u%c)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a%u%c)'

# Prompt Configuration
autoload -Uz add-zsh-hook
add-zsh-hook precmd vcs_info
PS1='%B[%F{red}%n%f@%m] %2~${vcs_info_msg_0_}%b %# '

# Key Bindings
bindkey -v  # Use Vi keybindings

# Line Editor Configuration
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd e edit-command-line

# Key Bindings (common additions)
bindkey '^R' history-incremental-search-backward
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Aliases
alias vim=nvim
alias c=clear
alias t='tmux new-session -A -D -s main'
alias q=exit
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'

# PATH
export PATH="$HOME/.local/bin:$PATH"
