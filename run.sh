#!/usr/bin/bash
# This script is used to set up the environment for Arduino IDE on Linux
# and run the IDE with the specified parameters.
# It sets up the necessary environment variables and then executes the IDE.
# The script is designed to be run from a Linux environment.
# It is assumed that the script is executed from the directory where the IDE is located.
# The script uses the Linux command line to set up the environment variables.

# Reference:
# - https://docs.arduino.cc/arduino-cli/configuration/
# - https://arduino.github.io/arduino-cli/1.2/configuration/
# - https://portableapps.com/node/68844

# Function to display help message
show_help() {
    printf "Usage: %s [version]\n" "${0##*/}"
    printf "  version: Arduino IDE version (e.g., 2.3.5) or 'latest'\n"
    printf "  If no version is specified, 'latest' is used\n"
    exit 1
}

# Show help if -h or --help is passed
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
fi

# Get the version from command line argument, default to "latest"
# VERSION="${1:-latest}"

# Get the version from command line argument
VERSION="$1"

# Otherwise validate the version format
if [ "$VERSION" != "latest" ] && ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    printf "Invalid version format: %s\n" "$VERSION"
    printf "Version must be 'latest' or in format X.Y.Z where X, Y, and Z are integers\n"
    show_help
    exit 1
fi

# Set the current version of Arduino IDE
# ARDUINO_CURRENT_VERSION="2.3.5"
# ARDUINO_CURRENT_VERSION="latest"
ARDUINO_CURRENT_VERSION="$VERSION"

# Check if the current version is set
if [ -z "$ARDUINO_CURRENT_VERSION" ]; then
    printf "Current version is not set. Please set the current version.\n"
    exit 1
fi

ARDUINO_IDE_PATH="/opt/arduino-${ARDUINO_CURRENT_VERSION}"
# Check if the IDE path exists
if [ ! -d "$ARDUINO_IDE_PATH" ]; then
    printf "Arduino IDE path does not exist: ${ARDUINO_IDE_PATH}\n"
    printf "Please set the correct path to the Arduino IDE.\n"
    exit 1
fi

printf "Using Arduino IDE path: ${ARDUINO_IDE_PATH}\n"
mkdir -p "${ARDUINO_IDE_PATH}/DataDir"/{.arduinoIDE,.arduino15/staging,Sketchbook,Lib,Tools}

# Set the environment variables for Arduino IDE
export ARDUINO_CONFIG_PATH="${ARDUINO_IDE_PATH}/DataDir/.arduinoIDE"
export ARDUINO_CONFIG_FILE="${ARDUINO_IDE_PATH}/DataDir/.arduinoIDE/arduino-cli.yaml"
export ARDUINO_DIRECTORIES_DATA="${ARDUINO_IDE_PATH}/DataDir/.arduino15"
export ARDUINO_DIRECTORIES_DOWNLOADS="${ARDUINO_IDE_PATH}/DataDir/.arduino15/staging"
export ARDUINO_DIRECTORIES_USER="${ARDUINO_IDE_PATH}/DataDir/Sketchbook"
export ARDUINO_DIRECTORIES_BUILTIN_LIBRARIES="${ARDUINO_IDE_PATH}/DataDir/Lib"
export ARDUINO_DIRECTORIES_BUILTIN_TOOLS="${ARDUINO_IDE_PATH}/DataDir/Tools"
export ARDUINO_LOGGING_FILE="${ARDUINO_IDE_PATH}/DataDir/logfile.txt"

# Check if arduino-cli and arduino-ide exist and are executable
if [ -x "${ARDUINO_IDE_PATH}/resources/app/lib/backend/resources/arduino-cli" ] && [ -x "${ARDUINO_IDE_PATH}/arduino-ide" ]; then
    printf "Found both arduino-cli and arduino-ide, initializing...\n"
else
    printf "Required executables not found in ${ARDUINO_IDE_PATH}\n"
    printf "Please ensure both arduino-cli and arduino-ide are present and executable\n"
    exit 1
fi

# Execute the Arduino IDE with the specified parameters
# ${ARDUINO_IDE_PATH}/resources/app/lib/backend/resources/arduino-cli config init --config-dir "${ARDUINO_CONFIG_PATH}" --config-file "${ARDUINO_CONFIG_FILE}"
# ${ARDUINO_IDE_PATH}/arduino-ide --data-dir "${ARDUINO_CONFIG_PATH}"

${ARDUINO_IDE_PATH}/resources/app/lib/backend/resources/arduino-cli config init --overwrite --dest-dir "${ARDUINO_CONFIG_PATH}" --config-dir "${ARDUINO_CONFIG_PATH}" --config-file "${ARDUINO_CONFIG_FILE}" && \
${ARDUINO_IDE_PATH}/arduino-ide --dest-dir "${ARDUINO_CONFIG_PATH}" --config-file "${ARDUINO_CONFIG_FILE}"