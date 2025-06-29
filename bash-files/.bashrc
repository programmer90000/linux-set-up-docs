# Stop .bashrc running in scripts
case $- in
    *i*) ;;
      *) return;;
esac

# Stop duplicate consecutive lines or lines starting with space adding to history
HISTCONTROL=ignoreboth
