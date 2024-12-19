# Zsh Configuration

# Performance Profiling (optional - only enable when debugging)
# zmodload zsh/zprof

# Shell Options
setopt AUTO_CD           # Type directory name to cd
setopt CORRECT           # Command correction
setopt AUTO_PUSHD        # Push directory to stack automatically
setopt PUSHD_IGNORE_DUPS # Don't push duplicate directories
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from history
setopt EXTENDED_HISTORY      # Save timestamp and duration in history

# Environment Variables
export EDITOR=nvim
export NOTES_DIR="$HOME/notes"
export PATH="$HOME/.local/bin:$PATH"

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Completion
autoload -Uz compinit
compinit -C  # -C skips security check, speeds up startup

# Enhanced Completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' menu select  # Interactive completion menu
zstyle ':completion:*' list-colors ''  # Colored completion listings

# Prompt Configuration
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info

PS1='%B%F{cyan}%n@%m %2~${vcs_info_msg_0_}%f%b %# '

# VCS Info settings
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# Aliases
alias v=nvim
alias vim=nvim
alias c=clear
alias t='tmux new-session -A -D -s main'
alias q=exit
alias notes='cd ~/notes/2024/12/'
alias books='cd ~/Books/Technical/Programming/'
alias fnotes='grep -r --exclude-dir=".git" "date: " ~/notes/ | sort -t":" -k2 -r | fzf'

# Source note-taking scripts
source "$HOME/.local/bin/note.sh"

# Optional: Uncomment for startup performance analysis
# zprof
