# PROMPT
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info

PS1='%F{cyan}%~ ${vcs_info_msg_0_}%f $ '

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# HISTORY
export HISTFILE="$XDG_DATA_HOME/zsh/histfile"
export HISTSIZE=5000  
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY            # append to history file
setopt HIST_NO_STORE             # Don't store history commands

# ENVIRONEMENT VARIABLES
export EDITOR="vi -e"   
export VISUAL="nvim"

# PLUGINS
ZSH_PLUGINS_DIR="$XDG_DATA_HOME/zsh"

# register
plugins=(
   "zsh-users/zsh-syntax-highlighting"
   "zsh-users/zsh-autosuggestions"
   "zsh-users/zsh-completions"
)

# install
for plugin in "${plugins[@]}"; do
    plugin_name="${plugin##*/}"
    if [[ ! -d "$ZSH_PLUGINS_DIR/$plugin_name" ]]; then
        git clone --depth=1 "https://github.com/$plugin.git" "$ZSH_PLUGINS_DIR/$plugin_name"
    fi
done

# setup
source $ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath=($ZSH_PLUGINS_DIR/zsh-completions/src $fpath)
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# FUNCTIONS
# install fzf: https://github.com/junegunn/fzf/releases
function _fh() {
    eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}
zle -N _fh

# KEYBINDINGS
bindkey '^r' history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^r' _fh
# bindkey '^r' history-incremental-search-backward

# ALIASES
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim='nvim'
alias c='clear'
alias x='exit'
alias t='tmux'

# EXPORT PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/nvim-linux64/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
