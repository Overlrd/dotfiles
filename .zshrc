# https://thevaluable.dev/zsh-install-configure-mouseless/
# https://thevaluable.dev/zsh-line-editor-configuration-mouseless/

# Colors - Enable colored output for various commands
autoload -U colors && colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

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

# Enhanced Completion (no colors)
autoload -U compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' menu select                   # Interactive menu selection

# Prompt Configuration
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info

# Simple prompt with Vi mode indicator
PS1='%B[%F{red}%n%f@%m] %2~${vcs_info_msg_0_}${vi_mode}%b %# '

# VCS Info settings (no colors)
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats ' (%b%u%c)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a%u%c)'

# Aliases
alias vim=nvim
alias c=clear
alias t='tmux new-session -A -D -s main'
alias q=exit
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# PATH Variables
export PATH="/$HOME/.local/bin:$PATH"
