# Stop .bashrc running in scripts
case $- in
    *i*) ;;
      *) return;;
esac

# Change the position of text on resize if needed
shopt -s checkwinsize

# Append to the history file, don't overwrite it
shopt -s histappend

# Stop duplicate consecutive lines or lines starting with space adding to history
HISTCONTROL=ignoreboth
# Maximum number of lines in bash history
HISTSIZE=1000
# Maximum number of lines in .bash_history file
HISTFILESIZE=2000

# Add chroot name when applicable
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Get custom aliases from .bash_aliases file
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Setup nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Define 10 background colors (ANSI codes)
COLOR_BG_DIRS=(
    '48;5;27'   # Blue
    '48;5;34'   # Green
    '48;5;161'  # Pink
    '48;5;130'  # Orange
    '48;5;136'  # Yellow
    '48;5;93'   # Purple
    '48;5;39'   # Light Blue
    '48;5;196'  # Red
    '48;5;22'   # Dark Green
    '48;5;129'  # Lavender
)

# Function to colorize each directory in the path
colorize_path() {
    local dirs=()
    IFS='/' read -r -a dirs <<< "$(pwd | sed 's|^/||')" # Split path, remove leading /

    local colored_path=""
    local color_index=0

    for dir in "${dirs[@]}"; do
        # Get the background color
        local bg_code="${COLOR_BG_DIRS[$color_index]}"
        # Add directory with background color
        colored_path+="\[\e[${bg_code}m\] ${dir} \[\e[0m\]"
        ((color_index = (color_index + 1) % 10)) # Cycle colors
    done

    echo -n "$colored_path"
}

# Set PS1 using PROMPT_COMMAND to ensure proper evaluation
set_prompt() {
    PS1="\[\e[1;34m\]\H\[\e[0m\]@\[\e[1;32m\]\u\[\e[0m\] $(colorize_path) $(git_branch)\$ "
}
PROMPT_COMMAND=set_prompt

git_branch() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            # Dirty = red
            echo -n "\[\e[1;31m\](${branch})\[\e[0m\]"
        else
            # Clean = green
            echo -n "\[\e[1;32m\](${branch})\[\e[0m\]"
        fi
    fi
}

# Set PS1 with your desired colors and the colorized path
set_prompt() {
    PS1="\[\e[1;34m\]\H\[\e[0m\]@\[\e[1;32m\]\u\[\e[0m\] $(colorize_path) $(git_branch)\$ "
}

PROMPT_COMMAND=set_prompt

# Display history menu when pressing Ctrl + R
export HSTR_CONFIG=hicolor
bind '"\C-r": "\C-a hstr -- \C-j"'  # Better Ctrl+R history menu
