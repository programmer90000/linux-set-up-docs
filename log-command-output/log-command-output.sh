#!/bin/bash

# Configuration with environment variable overrides
LOG_FILE="./logs/$(basename "$0")_$(date +%Y%m%d_%H%M%S).log"
VERBOSE="${VERBOSE:-0}"
QUIET="${QUIET:-0}"
NO_COLOR="${NO_COLOR:-0}"

# Terminal colors (disabled when NO_COLOR=1)
if [ "$NO_COLOR" = "1" ]; then
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    NC=""
else
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
fi

# Clean up temp files on exit
cleanup() {
    rm -f "$STDOUT_FILE" "$STDERR_FILE" 2>/dev/null
    exit "${1:-0}"
}
trap 'cleanup $?' EXIT
trap 'cleanup 130' INT
trap 'cleanup 143' TERM

# Color stderr output red
colorize_stderr() {
    while IFS= read -r line; do
        echo -e "${RED}${line}${NC}"
    done
}

show_usage() {
cat << EOF
Usage: log-run [-v|--verbose] [-q|--quiet] ["description"] <command> [args...]

Examples:
  log-run ["Updating packages"] sudo apt update
  log-run -v ["Building project"] make
EOF
    exit 1
}

# Parse command line flags
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -q|--quiet)
            QUIET=1
            shift
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            break
            ;;
    esac
done

# Extract description from [brackets]
if [[ $# -gt 0 && "$1" =~ ^\[.*\]$ ]]; then
    DESCRIPTION="${1#\[}"
    DESCRIPTION="${DESCRIPTION%\]}"
    
    # Strip surrounding quotes if present
    if [[ "$DESCRIPTION" =~ ^\".*\"$ ]] || [[ "$DESCRIPTION" =~ ^\'.*\'$ ]]; then
        DESCRIPTION="${DESCRIPTION:1:$((${#DESCRIPTION}-2))}"
    fi
    shift
else
    echo "Error: Description must be in [brackets]"
    show_usage
fi

# Validate inputs
if [ -z "$DESCRIPTION" ]; then
    echo "Error: Empty description"
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "Error: No command specified"
    exit 1
fi

# Ensure log directory exists
LOG_DIR="$(dirname "$LOG_FILE")"
if [ -n "$LOG_DIR" ] && [ "$LOG_DIR" != "." ]; then
    mkdir -p "$LOG_DIR" 2>/dev/null
fi

# Fallback to temp if log file is unwritable
if ! touch "$LOG_FILE" 2>/dev/null; then
    LOG_FILE="/tmp/log-run_$(date +%Y%m%d_%H%M%S).log"
    touch "$LOG_FILE"
fi

# Log the start of the command
echo "[$(date '+%Y-%m-%d %H:%M:%S')] ▶ $DESCRIPTION" >> "$LOG_FILE"

# Show description on terminal unless quiet
if [ "$QUIET" = "0" ]; then
    echo -e "${BLUE}▶${NC} $DESCRIPTION"
fi

# Create temp files for output streams
STDOUT_FILE=$(mktemp)
STDERR_FILE=$(mktemp)

# Run command and capture output
set +e
"$@" > "$STDOUT_FILE" 2> "$STDERR_FILE"
EXIT_CODE=$?
set -e

# Write complete command output to log file
{
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Command: $*"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Description: $DESCRIPTION"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Exit code: $EXIT_CODE"
    echo "--- STDOUT ---"
    cat "$STDOUT_FILE"
    echo "--- STDERR ---"
    cat "$STDERR_FILE"
    echo "---"
} >> "$LOG_FILE"

# Handle terminal output based on verbosity and exit status
if [ "$QUIET" = "0" ]; then
    if [ $EXIT_CODE -ne 0 ]; then
        # Command failed - show error details
        echo -e "${RED}✗ Command failed (exit: $EXIT_CODE)${NC}"
        
        if [ -s "$STDERR_FILE" ]; then
            echo -e "${RED}Error output:${NC}" >&2
            colorize_stderr < "$STDERR_FILE" >&2
        fi
        
        if [ "$VERBOSE" = "1" ] && [ -s "$STDOUT_FILE" ]; then
            echo "Standard output:"
            cat "$STDOUT_FILE"
        fi
    elif [ "$VERBOSE" = "1" ]; then
        # Command succeeded and verbose - show all output
        if [ -s "$STDOUT_FILE" ]; then
            cat "$STDOUT_FILE"
        fi
        
        if [ -s "$STDERR_FILE" ]; then
            echo -e "${YELLOW}Warning output:${NC}" >&2
            cat "$STDERR_FILE" >&2
        fi
    fi
    # If not verbose and success, show nothing beyond the initial description
fi

exit $EXIT_CODE