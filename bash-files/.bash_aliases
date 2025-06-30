# ls displays file names only in horizontal format, with colours and without any extra info
alias ls='ls -x --color=auto'

# Ask for confirmation before removing files and display a warning if removing recursive directories
function rm() {
  local dangerous=0
  local targets=()

  # Parse arguments to detect dangerous flags
  for arg in "$@"; do
    if [[ "$arg" == "-"* ]]; then
      [[ "$arg" == *"r"* ]] && dangerous=1  # recursive
      [[ "$arg" == *"f"* ]] && dangerous=1  # force
    else
      targets+=("$arg")
    fi
  done

  # Show appropriate warning
  if (( dangerous )); then
    echo -e "\033[1;31mDANGER:\033[0m Recursive/force delete detected"
    echo "Targets: ${targets[*]}"
    read -p "Confirm PERMANENT deletion? (y/n) " -n 1 -r
  else
    echo "About to delete: ${targets[*]}"
    read -p "Confirm deletion? (y/n) " -n 1 -r
  fi

  # Execute or cancel
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    command rm "$@"
  else
    echo "Deletion cancelled"
    return 1
  fi
}
