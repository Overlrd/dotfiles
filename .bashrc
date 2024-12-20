# ~/.bashrc

# Ensure this script is loaded for non-login interactive shells
[ -n "$PS1" ] || return

# History Configuration
export HISTCONTROL=ignoreboth      # Avoid duplicates and ignored commands
export HISTSIZE=10000              # Larger history
export HISTFILESIZE=20000          # Even larger history file
shopt -s histappend                # Append to history, don't overwrite

# Prompt Customization
PS1='\[\033[1;32m\]\u@\h:\[\033[0;34m\]\w\[\033[0m\]\$ '

# Aliases
alias ll='ls -lah --color=auto'
alias ls='ls --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias df='df -h'
alias free='free -h'
alias vim='nvim'

# PATH Modification (add your custom paths here)
export PATH=$HOME/.local/bin/:$PATH

# Enable Programmable Completion Features
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# Environment Tweaks
export EDITOR=nvim       # Set default editor
export TERMINAL=wezterm  # Set your terminal emulator

# Quick Navigation (optional but useful for WezTerm splits)
bind '"\e[A": history-search-backward'  # Up arrow for command search
bind '"\e[B": history-search-forward'   # Down arrow for command search
bind -x '"\C-l":clear'                  # Clear screen

# Clean up Terminal on Exit
trap "clear" EXIT
