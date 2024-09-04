#!/usr/bin/env bash

# Set variables
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Iosevka.tar.xz"
TEMP_DIR="/tmp/iosevka_font_install"
FONT_DIR="/usr/share/fonts/Iosevka"

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Download font
echo "Downloading Iosevka font..."
if ! wget -q -P "$TEMP_DIR" "$FONT_URL"; then
    echo "Error: Failed to download the font. Please check your internet connection."
    exit 1
fi

# Extract font
echo "Extracting font..."
mkdir -p "$FONT_DIR"
if ! tar xf "$TEMP_DIR/Iosevka.tar.xz" --directory="$FONT_DIR"; then
    echo "Error: Failed to extract the font."
    exit 1
fi

# Update font cache
echo "Updating font cache..."
if ! fc-cache -f "$FONT_DIR"; then
    echo "Error: Failed to update font cache."
    exit 1
fi

# Cleanup
echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "Iosevka font installation complete!"
