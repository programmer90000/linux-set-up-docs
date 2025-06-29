# Stop .bashrc running in scripts
case $- in
    *i*) ;;
      *) return;;
esac

# Append to the history file, don't overwrite it
shopt -s histappend

# Stop duplicate consecutive lines or lines starting with space adding to history
HISTCONTROL=ignoreboth
