#!/usr/bin/bash

#curl -s https://api.github.com/repos/arduino/arduino-ide/releases/latest |grep "browser_download_url.*zip" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /opt/arduino

# Download the latest Arduino IDE release as latest.zip
#curl -s https://api.github.com/repos/arduino/arduino-ide/releases/latest |grep "browser_download_url.*zip" |cut -d : -f 2,3 |tr -d \"| grep $(uname -s) | xargs -n 1 curl -L -o /tmp/arduino_latest.zip

# Download the latest Arduino IDE release as version.zip
# curl -s https://api.github.com/repos/arduino/arduino-ide/releases/latest | grep "browser_download_url.*zip" | cut -d : -f 2,3 | tr -d \" | grep $(uname -s) | while read -r url; do
#     version=$(echo "$url" | grep -oP 'arduino-ide-\K[0-9.]+')
#     printf "Downloading Arduino IDE version: $version\n"
#     curl -L "$url" -o "/tmp/arduino_${version}.zip"
# done

# Define color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

clear

# Function to print messages with colors
print_message() {
    local type=$1
    local message=$2
    
    case $type in
        "ERROR")
            printf "\n${RED}[ERROR] ${message}${NC}\n"
            ;;
        "WARNING")
            printf "\n${YELLOW}[WARNING] ${message}${NC}\n"
            ;;
        "INFO")
            printf "\n${CYAN}[INFO] ${message}${NC}\n"
            ;;
        "SUCCESS")
            printf "\n${GREEN}[SUCCESS] ${message}${NC}\n"
            ;;
        *)
            printf "\n${message}\n"
            ;;
    esac
}

# Function to display help message
show_help() {
    printf "Usage: $0 <destination_dir> [latest_naming]\n"
    printf "\nOptions:\n"
    printf "  destination_dir    Directory where Arduino IDE will be extracted\n"
    printf "  latest_naming      Optional: Use 'latest_naming' instead of version number\n"
    printf "\nExample:\n"
    printf "  $0 /opt\n"
    printf "  $0 /opt latest_naming\n"
    exit 1
}

# Show help if requested
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
fi

# Remove trailing slash from destination_dir if present
destination_dir="${1%/}"

# Take optional second argument for naming convention
use_latest_naming=false
if [ $# -eq 2 ] && [ "$2" = "latest_naming" ]; then
    use_latest_naming=true
fi

# First, get the list of files that would be downloaded
files_to_download=$(curl -s https://api.github.com/repos/arduino/arduino-ide/releases/latest | grep "browser_download_url.*zip" | cut -d : -f 2,3 | tr -d \" | grep $(uname -s))

# Check existing files first
for url in $files_to_download; do
    filename=$(basename "$url")
    if [ -f "/tmp/$filename" ]; then
        print_message "WARNING" "File already exists: /tmp/$filename\n"
        read -p "Do you want to download again? (y/n): " choice
        if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
            print_message "INFO" "Skipping download of $filename\n"
            files_to_download=$(echo "$files_to_download" | grep -v "$url")
        fi
    fi
done

# Download the files
echo "$files_to_download" | while read -r url; do
    if [ -n "$url" ]; then
        filename=$(basename "$url")
        print_message "INFO" "Downloading Arduino IDE: $filename\n"
        curl -L "$url" -o "/tmp/$filename" --progress-bar
    fi
done

# After downloading, ask to decompress
read -p "Do you want to extract the downloaded file? (y/n): " choice
if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
    print_message "INFO" "Skipping extraction.\n"
    exit 0
fi
# Check if the file is empty
if [ ! -s "/tmp/$filename" ]; then
    print_message "WARNING" "File is empty: /tmp/$filename\n"
    exit 1
fi
# Check if unzip is installed
if ! command -v unzip &> /dev/null; then
    print_message "ERROR" "unzip could not be found. Please install unzip.\n"
    exit 1
fi
# Check if the file is a valid zip file
if ! unzip -t "/tmp/$filename" &> /dev/null; then
    print_message "ERROR" "File is not a valid zip file: /tmp/$filename\n"
    exit 1
fi

# Extract the file to target_dir
if [ "$use_latest_naming" = true ]; then
    version="latest"
else
    version=$(echo "$filename" | grep -oP 'arduino-ide_\K[0-9.]+')
fi

target_dir="$destination_dir/arduino-$version"

# Check if the target directory already exists
if [ -d "$target_dir" ]; then
    print_message "WARNING" "Target directory already exists: $target_dir\n"
    print_message "WARNING" "(!!!DANGEROUS!!!) This will delete the target directory and all its contents.\n"
    read -p "Confirm to cleaning target directory ($target_dir)? (y/n): " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        print_message "INFO" "Exit, no cleaning and no extraction.\n"
        exit 1
    else
        print_message "INFO" "Cleaning target directory: $target_dir\n"
        rm -rf "$target_dir"
        print_message "SUCCESS" "Target directory cleaned.\n"
    fi
fi

# Create the target directory
mkdir -p "$target_dir"

# print_message "INFO" "Extracting %s to %s...\n" "/tmp/$filename" "$target_dir"
print_message "INFO" "Extracting /tmp/$filename to $target_dir...\n"
# unzip "/tmp/$filename" -d "$target_dir"

# unzip -o "/tmp/$filename" -d "$target_dir" | while read -r line; do
#     printf "  %s\n" "$line"
# done

unzip -q -o "/tmp/$filename" -d "$target_dir"



# Check if the extraction was successful
if [ $? -ne 0 ]; then
    print_message "ERROR" "Failed to extract: /opt/$filename\n"
    exit 1
fi

print_message "SUCCESS" "Arduino IDE extracted to: $target_dir\n"

# Extract the filename without zip extension
filename_unzipped=$(basename "$url")
if [[ "$filename_unzipped" == *.zip ]]; then
    filename_unzipped="${filename_unzipped%.zip}"
fi

# Cleaning target dir
if [ -d "$target_dir/${filename_unzipped}" ]; then
    print_message "WARNING" "Target dir has subdirectory ${filename_unzipped}, moving content one level up\n"
    mv $target_dir/${filename_unzipped}/* $target_dir
    rm -rf $target_dir/${filename_unzipped}
    print_message "SUCCESS" "Target dir cleaned\n"
else
    print_message "SUCCESS" "Target is clean\n"
    exit 1
fi

# Ask to confirm creation of desktop entry
read -p "Do you want to create a desktop entry? (y/n): " choice
if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
    print_message "INFO" "Skipping desktop entry creation.\n"
    exit 0
fi

# Create a desktop entry on the system
# Get the display name with version
if [ "$use_latest_naming" = true ]; then
    display_version="latest"
else
    display_version="$version"
fi
display_name="Arduino IDE - $display_version"
# Create the directory for the desktop entry
if [ ! -d "$HOME/Desktop/Arduino" ]; then
    mkdir -p "$HOME/Desktop/Arduino"
fi
# Check if the desktop entry already exists
desktop_entry_path="$HOME/Desktop/Arduino/$display_name.desktop"
if [ -f "$desktop_entry_path" ]; then
    print_message "WARNING" "Desktop entry already exists: $desktop_entry_path\n"
    read -p "Do you want to overwrite it? (y/n): " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        print_message "INFO" "Skipping desktop entry creation.\n"
        exit 0
    fi
fi

# Try to delete the existing desktop entry
if [ -f "$desktop_entry_path" ]; then
    if ! rm "$desktop_entry_path"; then
        print_message "ERROR" "Failed to delete existing desktop entry: $desktop_entry_path"
        exit 1
    fi
fi

# Create the desktop entry
cat << EOF | tee "$desktop_entry_path" > /dev/null
[Desktop Entry]
Type=Application
Name=Arduino IDE
GenericName=Arduino IDE
Comment=Open-source electronics prototyping platform
Exec="$target_dir/arduino-ide"
Icon=$target_dir/resources/app/resources/icons/512x512.png
Terminal=true
Categories=Development;IDE;Electronics;
MimeType=text/x-arduino;
Keywords=embedded electronics;electronics;avr;microcontroller;
StartupWMClass=processing-app-Base
Name[en_US]=Arduino IDE - $display_version
EOF

# Make the desktop entry executable
chmod +x "$desktop_entry_path"
print_message "SUCCESS" "Desktop entry created: $desktop_entry_path\n"