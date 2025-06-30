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

# Ask for confirmation before copying files and an additional confirmation if overwriting
function cp() {
    local sources=()
    local dest=""
    local skip_prompt=0  # If -f (force) is used

    # Parse arguments (handle -f/-i manually)
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -i|-f)
                # Ignore -i (we handle prompts ourselves)
                # -f means skip confirmation
                [[ "$1" == -f ]] && skip_prompt=1
                shift
                ;;
            -*)
                # Preserve other flags (e.g., -r, -v)
                sources+=("$1")
                shift
                ;;
            *)
                # Last argument = destination
                if [[ $# -eq 1 ]]; then
                    dest="$1"
                else
                    sources+=("$1")
                fi
                shift
                ;;
        esac
    done

    echo -e "\033[1;36mCOPYING:\033[0m"
    echo "Source(s): ${sources[*]}"
    echo "Destination: $dest"

    # Check for existing files
    local overwrite_any=0
    if [ -d "$dest" ]; then
        # Destination is a directory → check each source
        for src in "${sources[@]}"; do
            if [[ -e "$dest/$(basename "$src")" ]]; then
                echo -e "\033[1;31mWARNING:\033[0m '$dest/$(basename "$src")' already exists"
                overwrite_any=1
            fi
        done
    elif [ -e "$dest" ]; then
        # Destination is a file → single overwrite
        echo -e "\033[1;31mWARNING:\033[0m '$dest' already exists"
        overwrite_any=1
    fi

    # Skip prompt if -f (force) or no overwrites needed
    (( skip_prompt || !overwrite_any )) && {
        command cp "${sources[@]}" "$dest"
        return
    }

    # Custom (y/n) prompt
    read -p "Overwrite? (y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] && command cp "${sources[@]}" "$dest"
}

# Ask for confirmation before moving files
function mv() {
    echo -e "\033[1;33mMOVING:\033[0m"
    echo "Source(s): ${@:1:$#-1}"
    echo "Destination: ${@: -1}"
    read -p "Confirm move? (y/n) " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] && command mv -i "$@"
}
