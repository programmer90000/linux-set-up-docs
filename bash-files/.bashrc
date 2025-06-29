# Stop .bashrc running in scripts
case $- in
    *i*) ;;
      *) return;;
esac

# Append to the history file, don't overwrite it
shopt -s histappend

# Stop duplicate consecutive lines or lines starting with space adding to history
HISTCONTROL=ignoreboth
# Maximum number of lines in bash history
HISTSIZE=1000
# Maximum number of lines in .bash_history file
HISTFILESIZE=2000
