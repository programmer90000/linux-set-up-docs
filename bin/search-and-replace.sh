#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Temporary files
SEARCH_RESULTS="/tmp/search_results.$$"
MATCH_TABLE="/tmp/match_table.$$"
REPLACE_LOG="/tmp/replace_log.$$"

cleanup() {
    rm -f "$SEARCH_RESULTS" "$MATCH_TABLE" "$REPLACE_LOG"
    exit
}

trap cleanup EXIT INT TERM

# Function to display the main table
show_table() {
    echo -e "\n${YELLOW}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                                MATCHES TABLE                                 ║${NC}"
    echo -e "${YELLOW}╠═══════╦══════════════════╦══════╦══════════════════════════════════════════╣${NC}"
    echo -e "${YELLOW}║ ${CYAN}ID${YELLOW}    ║ ${CYAN}File${YELLOW}             ║ ${CYAN}Line${YELLOW} ║ ${CYAN}Content${YELLOW}                                   ║${NC}"
    echo -e "${YELLOW}╟───────╫──────────────────╫──────╫──────────────────────────────────────────╢${NC}"
    
    local counter=0
    > "$MATCH_TABLE"
    
    while IFS=: read -r file line_num content; do
        counter=$((counter + 1))

        # Clean up the input
        file=$(echo "$file" | tr -d '\r')
        line_num=$(echo "$line_num" | tr -d '\r')
        content=$(echo "$content" | sed 's/^[ \t]*//;s/[ \t]*$//')

        # Shorten for display
        file_display=$(basename "$file")
        if [[ ${#file_display} -gt 15 ]]; then
            file_display="${file_display:0:12}..."
        fi
        
        content_display=$(echo "$content" | cut -c1-40)
        if [[ ${#content} -gt 40 ]]; then
            content_display="${content_display}..."
        fi

        # Store full data for later use
        echo "$counter:$file:$line_num:$content" >> "$MATCH_TABLE"

        # Display row
        printf "${YELLOW}║ ${GREEN}%-5s ${YELLOW}║ ${BLUE}%-16s ${YELLOW}║ ${PURPLE}%-4s ${YELLOW}║ %-40s ${YELLOW}║${NC}\n" \
               "$counter" "$file_display" "$line_num" "$content_display"

    done < "$SEARCH_RESULTS"

    echo -e "${YELLOW}╚═══════╩══════════════════╩══════╩══════════════════════════════════════════╝${NC}"
    echo -e "\n${GREEN}Total matches: $counter${NC}"
    echo -e "${CYAN}Commands: [ID] = preview match, 'apply' = apply changes, 'quit' = exit${NC}"
}

# Function to show context preview
preview_match() {
    local match_id="$1"
    local search_term="$2"
    local replace_term="$3"

    # Find the match in our table
    local match_data=$(grep "^$match_id:" "$MATCH_TABLE")
    if [[ -z "$match_data" ]]; then
        echo -e "${RED}Invalid ID: $match_id${NC}"
        return 1
    fi

    IFS=: read -r id file line_num original_content <<< "$match_data"

    echo -e "\n${PURPLE}┌─────────────────── MATCH #$match_id ───────────────────${NC}"
    echo -e "${PURPLE}│ ${CYAN}File: ${file}:${line_num}${NC}"
    echo -e "${PURPLE}├──────────────────────────────────────────────────────────${NC}"

    # Show context (5 lines before and after)
    local start_line=$((line_num - 5))
    local end_line=$((line_num + 5))

    if [[ $start_line -lt 1 ]]; then
        start_line=1
    fi

    echo -e "${PURPLE}│ ${YELLOW}Context (lines ${start_line}-${end_line}):${NC}"
    echo -e "${PURPLE}│${NC}"

    # Read the file and show context
    local current_line=0
    while IFS= read -r line; do
        current_line=$((current_line + 1))

        if [[ $current_line -ge $start_line && $current_line -le $end_line ]]; then
            # Highlight the current match line
            if [[ $current_line -eq $line_num ]]; then
                # Show original in red
                echo -e "${PURPLE}│ ${RED}➤ ${current_line}: ${line}${NC}"
                # Show replacement in green
                local replaced_line=$(echo "$line" | sed "s/$search_term/$replace_term/g")
                echo -e "${PURPLE}│ ${GREEN}   ${current_line}: ${replaced_line}${NC}"
            else
                echo -e "${PURPLE}│    ${current_line}: ${line}${NC}"
            fi
        fi

        # Break early if we've passed the end line
        if [[ $current_line -gt $end_line ]]; then
            break
        fi
    done < "$file"

    echo -e "${PURPLE}├──────────────────────────────────────────────────────────${NC}"
    echo -e "${PURPLE}│ ${CYAN}Replace '${search_term}' with '${replace_term}'?${NC}"
    echo -e "${PURPLE}│ ${GREEN}[y]${NC} = yes, ${RED}[n]${NC} = no, ${YELLOW}[back]${NC} = return to table"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────${NC}"

    # Store this match for potential replacement
    local replaced_content=$(echo "$original_content" | sed "s/$search_term/$replace_term/g")
    echo "$match_id:$file:$line_num:$original_content:$replaced_content" >> "$REPLACE_LOG"
}

# Function to apply all approved changes
apply_changes() {
    if [[ ! -f "$REPLACE_LOG" ]] || [[ ! -s "$REPLACE_LOG" ]]; then
        echo -e "${RED}No changes to apply!${NC}"
        return 1
    fi

    echo -e "\n${YELLOW}Applying changes...${NC}"
    local applied_count=0

    # Create backups first
    awk -F: '{print $2}' "$REPLACE_LOG" | sort -u | while read file; do
        if [[ -f "$file" ]]; then
            cp "$file" "${file}.backup.$$"
            echo -e "${CYAN}Backed up: ${file} -> ${file}.backup.$$${NC}"
        fi
    done

    # Apply replacements
    while IFS=: read -r match_id file line_num original replaced; do
        # Use exact line replacement
        if sed -i "${line_num}s/.*/${replaced}/" "$file" 2>/dev/null; then
            echo -e "${GREEN}✓ Applied match #$match_id in ${file}:${line_num}${NC}"
            applied_count=$((applied_count + 1))
        else
            echo -e "${RED}✗ Failed to apply match #$match_id${NC}"
        fi
    done < "$REPLACE_LOG"
    
    echo -e "\n${GREEN}Successfully applied $applied_count changes${NC}"
    echo -e "${CYAN}Backup files created with extension: .backup.$$${NC}"
}

# Function to search files
search_files() {
    local search_term="$1"
    local directory="$2"

    echo -e "${BLUE}Searching for: '${search_term}' in ${directory}${NC}"

    # Use grep to find matches
    grep -r -n -I "$search_term" "$directory" 2>/dev/null > "$SEARCH_RESULTS"

    local match_count=$(wc -l < "$SEARCH_RESULTS" 2>/dev/null || echo 0)

    if [[ $match_count -eq 0 ]]; then
        echo -e "${RED}No matches found.${NC}"
        return 1
    fi

    echo -e "${GREEN}Found $match_count matches${NC}"
    return 0
}

# Main interactive loop
main_loop() {
    local search_term="$1"
    local replace_term="$2"

    # Clear replace log at start
    > "$REPLACE_LOG"

    while true; do
        show_table

        echo -e "\n${CYAN}Enter command:${NC}"
        read -p "> " command

        case "$command" in
            [0-9]*)
                # Preview a specific match
                preview_match "$command" "$search_term" "$replace_term"

                # Handle the preview interaction
                while true; do
                    read -p "> " preview_cmd
                    case "$preview_cmd" in
                        [yY])
                            echo -e "${GREEN}✓ Marked match #$command for replacement${NC}"
                            break
                            ;;
                        [nN])
                            echo -e "${RED}✗ Skipped match #$command${NC}"
                            # Remove from replace log if it was added
                            sed -i "/^$command:/d" "$REPLACE_LOG" 2>/dev/null
                            break
                            ;;
                        [bB]ack|back|exit)
                            echo -e "${YELLOW}Returning to table...${NC}"
                            break
                            ;;
                        *)
                            echo -e "${RED}Invalid command. Use: y, n, or back${NC}"
                            ;;
                    esac
                done
                ;;

            [aA]pply|apply)
                local change_count=$(wc -l < "$REPLACE_LOG" 2>/dev/null || echo 0)
                if [[ $change_count -eq 0 ]]; then
                    echo -e "${RED}No changes marked for replacement!${NC}"
                else
                    echo -e "${YELLOW}You have $change_count changes ready to apply. Continue? (y/n):${NC}"
                    read -p "> " confirm
                    if [[ $confirm =~ [yY] ]]; then
                        apply_changes
                        break
                    else
                        echo -e "${YELLOW}Application cancelled${NC}"
                    fi
                fi
                ;;

            [qQ]uit|quit|exit)
                echo -e "${YELLOW}Exiting without changes${NC}"
                break
                ;;

            "")
                # Just show table again
                ;;

            *)
                echo -e "${RED}Invalid command. Use: [ID], 'apply', or 'quit'${NC}"
                ;;
        esac
    done
}

# Main function
main() {
    local directory="${1:-.}"

    if [[ ! -d "$directory" ]]; then
        echo -e "${RED}Error: Directory '$directory' does not exist${NC}"
        exit 1
    fi

    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║               T A B L E   S E A R C H   &   R E P L A C E     ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo -e "Directory: ${CYAN}$directory${NC}"
    echo

    # Get search term
    read -p "Enter text to search for: " search_term
    if [[ -z "$search_term" ]]; then
        echo -e "${RED}Error: Search term cannot be empty${NC}"
        exit 1
    fi

    # Perform search
    if ! search_files "$search_term" "$directory"; then
        exit 1
    fi

    # Get replacement term
    read -p "Enter replacement text: " replace_term

    # Start main interactive loop
    main_loop "$search_term" "$replace_term"
}

main "$@"