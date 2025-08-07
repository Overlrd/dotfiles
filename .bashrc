# .bashrc

# Set the editor to nvim
export EDITOR="nvim"

# Add .local/bin to the PATH
export PATH="$HOME/.local/bin:$PATH"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases and prompt configuration
alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
