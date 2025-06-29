# Stop .bashrc running in scripts
case $- in
    *i*) ;;
      *) return;;
esac
