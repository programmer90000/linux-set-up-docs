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

# Auto Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes

# Wildcard
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt NOMATCH

# Notify when background process completes or stops
setopt NOTIFY

# Key bindings
bindkey '^[[3~' delete-char

PS1='%~%# '
