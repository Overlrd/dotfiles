# Zsh Configuration

# Performance Profiling (optional)
zmodload zsh/zprof

# Plugin Directory
PLUGINS_DIR="$HOME/.zsh/plugins"
mkdir -p "$PLUGINS_DIR" 2>/dev/null

# Shell Options
setopt AUTO_CD       # Type directory name to cd
setopt CORRECT       # Command correction
setopt AUTO_PUSHD    # Push directory to stack automatically
setopt PUSHD_IGNORE_DUPS  # Don't push duplicate directories
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS  # Remove superfluous blanks from history
setopt EXTENDED_HISTORY  # Save timestamp and duration in history

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Performance & Usability Improvements
setopt AUTO_CD # Type directory name to cd
setopt CORRECT # Command correction

# Plugin management
typeset -A PLUGINS=(
    ["zsh-users/zsh-syntax-highlighting"]="source_dot_zsh"
    ["zsh-users/zsh-autosuggestions"]="source_dot_zsh"
)

install_plugins() {
    for plugin_repo plugin_setup in ${(kv)PLUGINS}; do
        # Extract plugin name safely
        local plugin_name=$(basename "$plugin_repo")
        local plugin_path="$PLUGINS_DIR/$plugin_name"

        # Clone if not already installed
        if [[ ! -d "$plugin_path" ]]; then
            if ! git clone --depth=1 "https://github.com/$plugin_repo" "$plugin_path" 2>/dev/null; then
                echo -e "Failed to install $plugin_name" >&2
                continue
            fi
            echo -e "Successfully installed $plugin_name"
        fi

        # Handle plugin setup
        if [[ "$plugin_setup" == "source_dot_zsh" ]]; then
            local dot_zsh_path="$plugin_path/$plugin_name.zsh"
            if [[ -f "$dot_zsh_path" ]]; then
                source "$dot_zsh_path"
            else
                echo -e "No .zsh file found for $plugin_name" >&2
            fi
        elif [[ -n "$plugin_setup" ]]; then
            # If not "source_dot_zsh", try to evaluate the setup function
            if declare -f "$plugin_setup" > /dev/null; then
                "$plugin_setup"
            else
                echo -e "Setup function $plugin_setup not found" >&2
            fi
        fi
    done
}

# Better Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' menu select  # Interactive completion menu
zstyle ':completion:*' list-colors ''  # Colored completion listings

# Advanced Prompt Configuration
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst

# Enhanced Git status information
_git_prompt_info() {
    # Check if we're in a git repository
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local git_status=$(git status -sb 2>/dev/null)
    local branch_info ahead behind

    # Extract branch name
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)

    # Check for ahead/behind status
    if [[ "$git_status" == *"ahead"* ]]; then
        ahead=$(echo "$git_status" | grep -o "ahead [0-9]*" | cut -d' ' -f2)
    fi
    if [[ "$git_status" == *"behind"* ]]; then
        behind=$(echo "$git_status" | grep -o "behind [0-9]*" | cut -d' ' -f2)
    fi

    # Construct status string
    local status_str="($branch"
    [[ -n "$ahead" ]] && status_str+=" ↑$ahead"
    [[ -n "$behind" ]] && status_str+=" ↓$behind"

    # Check for uncommitted changes
    if [[ -n $(git status -s) ]]; then
        # Distinguish between staged and unstaged changes
        local staged=$(git diff --cached --name-only | wc -l | tr -d ' ')
        local unstaged=$(git diff --name-only | wc -l | tr -d ' ')
        
        [[ $staged -gt 0 ]] && status_str+=" +$staged"
        [[ $unstaged -gt 0 ]] && status_str+=" *$unstaged"
    fi

    status_str+=")"
    echo "$status_str"
}

# Configure vcs_info for basic git integration
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

# Add hook to update vcs_info
add-zsh-hook precmd vcs_info

# Prompt with enhanced git information
PS1='%n@%m %2~ $(_git_prompt_info)%# '

# Optional: Add right-side prompt for additional info
RPS1='%*'  # Shows current time on the right side



# Alias
alias v=nvim
alias vim=nvim
alias c=clear
alias x=exit

# Setup plugins
install_plugins

# zprof
