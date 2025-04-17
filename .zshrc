# https://thevaluable.dev/zsh-install-configure-mouseless/
# https://thevaluable.dev/zsh-line-editor-configuration-mouseless/

# Shell Options
setopt AUTO_CD              # Automatically change to directory if name is typed
setopt CORRECT              # Command correction
setopt AUTO_PUSHD           # Automatically push directories onto directory stack
setopt PUSHD_IGNORE_DUPS    # Avoid duplicate directories in the stack
setopt HIST_IGNORE_ALL_DUPS # Remove duplicate history entries
setopt HIST_REDUCE_BLANKS   # Remove excess blanks in history

# Environment Variables
export EDITOR="nvim"

# History Configuration
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# Enhanced Completion
autoload -U compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' menu select                   # Interactive menu selection
zstyle ':completion:*' list-colors ''                # Colored completion listings

# Prompt Configuration
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info

PS1='%B[%F{red}%n%f@%m] %2~${vcs_info_msg_0_}%b %# '

# VCS Info settings
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# Key Bindings
bindkey -v  # Use Vi keybindings

# Add shell-to-Neovim editing feature
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd e edit-command-line

# Aliases
alias vim=nvim
alias c=clear
alias t='tmux new-session -A -D -s main'
alias q=exit
