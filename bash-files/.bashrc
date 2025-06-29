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

# Prompt customization
PS1='\[\e[1;34m\]\H\[\e[0m\]@\[\e[1;32m\]\u\[\e[0m\]\[\e[1;36m\]\w\[\e[0m\]\$ '
