# Lightweight Zsh: built-in completion, Git prompt and vi editing.
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_VERIFY
setopt SHARE_HISTORY APPEND_HISTORY
unsetopt CORRECT

export EDITOR="${EDITOR:-hx}"
export VISUAL="${VISUAL:-$EDITOR}"
export TERMINAL=foot
typeset -U path PATH
path=("$HOME/.local/bin" $path)

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=40000

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

autoload -Uz vcs_info add-zsh-hook
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' (%b%u%c)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a%u%c)'
add-zsh-hook precmd vcs_info
# Working directory and Git status; no exit-code decoration.
PROMPT='%F{117}%2~%f %F{150}${vcs_info_msg_0_}%f %F{white}%#%f '

bindkey -v
KEYTIMEOUT=10
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^X^E' edit-command-line
bindkey -M vicmd '^X^E' edit-command-line
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^[[A' history-search-backward
bindkey -M viins '^[[B' history-search-forward
# Free Ctrl+S for the tmux prefix instead of terminal flow control.
[[ -t 0 ]] && stty -ixon

alias c=clear
alias q=exit
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
# Avoid nesting tmux or detaching another client unexpectedly.
t() {
    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t main
    else
        tmux new-session -A -s main
    fi
}
