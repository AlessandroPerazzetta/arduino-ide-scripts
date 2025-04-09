#!/bin/bash

# Set default backup destination to current directory
BACKUP_DEST="."

# If argument 1 exists, use it as destination directory
if [ $# -eq 1 ]; then
    BACKUP_DEST="$1"
    # Check if destination directory exists, if not create it
    if [ ! -d "$BACKUP_DEST" ]; then
        mkdir -p "$BACKUP_DEST"
    fi
fi

# Get current date and time for filename
DATETIME=$(date +%Y%m%d-%H%M)
BACKUP_FILE="arduino_dirs-${DATETIME}.tar.gz"

# Create backup
cd "$HOME"
tar -cpzf "${BACKUP_DEST}/${BACKUP_FILE}" \
    .arduino15 \
    .arduinoIDE \
    Arduino \
    2>/dev/null

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup created successfully: ${BACKUP_DEST}/${BACKUP_FILE}"
else
    echo "Error creating backup"
    exit 1
fi