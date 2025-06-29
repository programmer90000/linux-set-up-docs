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

# Define 10 background colors (ANSI codes)
COLOR_BG_DIRS=(
    '48;5;27'   # Blue
    '48;5;34'   # Green
    '48;5;161'  # Pink
    '48;5;208'  # Orange
    '48;5;226'  # Yellow
    '48;5;93'   # Purple
    '48;5;39'   # Light Blue
    '48;5;196'  # Red
    '48;5;46'   # Bright Green
    '48;5;129'  # Lavender
)

# Function to colorize each directory in the path
colorize_path() {
    local dirs=()
    IFS='/' read -r -a dirs <<< "$(pwd | sed 's|^/||')"  # Split path, remove leading /

    local colored_path=""
    local color_index=0

    for dir in "${dirs[@]}"; do
        # Get the background color
        local bg_code="${COLOR_BG_DIRS[$color_index]}"
        # Add directory with background color (NO \[\] here!)
        colored_path+="\e[${bg_code}m ${dir} \e[0m"
        ((color_index = (color_index + 1) % 10))  # Cycle colors
    done

    echo -ne "$colored_path"
}

# Set PS1 with your desired colors and the colorized path
PS1='\[\e[1;34m\]\H\[\e[0m\]@\[\e[1;32m\]\u\[\e[0m\] \[$(colorize_path)\]\$ '
