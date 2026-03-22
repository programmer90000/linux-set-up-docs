#!/bin/bash

sudo apt update
sudo apt install curl

validate_source() {
    local source="$1"
    
    # Check if it's a URL
    if [[ "$source" =~ ^https?:// ]]; then
        if curl --output /dev/null --silent --head --fail "$source"; then
            echo "URL"
            return 0
        else
            echo "Error: URL is not accessible."
            return 1
        fi
    fi
    
    # Check if it's a local file
    # Expand tilde to home directory
    local expanded_source="${source/#\~/$HOME}"
    
    if [[ ! -f "$expanded_source" ]]; then
        echo "Error: File does not exist."
        return 1
    fi
    
    if [[ ! -x "$expanded_source" ]]; then
        echo "Error: File is not executable."
        return 1
    fi
    
    echo "FILE"
    return 0
}

# First, ask what to install
read -p "What would you like to install? " install_target

# Trim whitespace
install_target=$(echo "$install_target" | xargs)

if [[ "$install_target" == "Zoom" || "$install_target" == "zoom" ]]; then
    read -p "Enter source for Zoom (URL or local executable file path): " download_source
    
    while true; do
        download_source=$(echo "$download_source" | xargs)
        
        if [[ -z "$download_source" ]]; then
            echo "Error: No input provided."
            read -p "Please enter a valid URL or executable file path: " download_source
            continue
        fi
        
        validation_result=$(validate_source "$download_source")
        validation_status=$?
        
        if [[ $validation_status -eq 0 ]]; then
            source_type=$(echo "$validation_result" | head -n 1)
            if [[ "$source_type" == "URL" ]]; then
                echo "URL found: $download_source"
                break
            elif [[ "$source_type" == "FILE" ]]; then
                # Expand path for output if needed
                expanded_source="${download_source/#\~/$HOME}"
                echo "Executable file found: $expanded_source"
                download_source="$expanded_source"
                break
            fi
        else
            echo "Invalid input: '$download_source' is not a valid URL or existing executable file."
            echo "Requirements for local files:"
            echo "    - File must exist"
            echo "    - File must have execute permissions (chmod +x)"
            echo ""
            read -p "Please enter a valid URL or executable file path: " download_source
        fi
    done
    
    echo ""
    if [[ "$download_source" =~ ^https?:// ]]; then
        echo "Downloading Zoom from URL..."
        
        temp_dir=$(mktemp -d)
        cd "$temp_dir" || exit 1
        
        if wget --show-progress "$download_source"; then
            echo "Download completed successfully."
            
            downloaded_file=$(ls | head -n 1)
            
            if [[ "$downloaded_file" == *.sh ]]; then
                chmod +x "$downloaded_file"
                echo "Running Zoom installer..."
                ./"$downloaded_file"
            elif [[ "$downloaded_file" == *.deb ]]; then
                echo "Installing Zoom .deb package..."
                sudo dpkg -i "$downloaded_file"
                sudo apt-get install -f -y  # Fix any dependency issues
            else
                echo "Unknown file type. Please install manually."
                ls -la
            fi
        else
            echo "Error: Failed to download from URL."
            exit 1
        fi
        
        # Clean up
        cd /tmp || exit
        rm -rf "$temp_dir"
        
    else
        echo "Installing Zoom from local file..."
        
        if [[ "$download_source" == *.deb ]]; then
            echo "Installing .deb package..."
            sudo dpkg -i "$download_source"
            sudo apt-get install -f -y  # Fix any dependency issues
        elif [[ "$download_source" == *.sh ]]; then
            echo "Running shell script installer..."
            "$download_source"
        else
            echo "Running executable file..."
            "$download_source"
        fi
    fi
    
    echo ""
    if command -v zoom &> /dev/null; then
        echo "Zoom has been successfully installed! You can launch Zoom by typing 'zoom' in the terminal"
    else
        echo "Installation completed, but 'zoom' command not found in PATH."
        echo "You may need to log out and back in, or manually launch Zoom from the installed location."
    fi
    
else
    echo "You entered an invalid app name to install"
    exit 1
fi