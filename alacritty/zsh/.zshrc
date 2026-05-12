# Zsh config file
export ZDOTDIR="$HOME/.config/zsh"
export HISTFILE="$ZDOTDIR/.zsh_history"
mkdir -p "$ZDOTDIR"

# History
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Programs
export EDITOR=nvim
export PAGER="nvim -R -"

# Language
export LANG=en_GB.UTF-8

# Directory navigation
unsetopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
