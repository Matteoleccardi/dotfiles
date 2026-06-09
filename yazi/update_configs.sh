#!/bin/bash

# 1. Setup base directory
mkdir -p ~/.config/yazi
cd ~/.config/yazi || exit

# Base URL for your raw GitHub files
REPO_URL="https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/yazi"

echo "Downloading core configs..."
# 2. Download core config files
for f in yazi.toml theme.toml keymap.toml vfs.toml Catppuccin-mocha.tmTheme; do
    curl -sLO "$REPO_URL/$f"
done

echo "Downloading plugins..."
# 3. Define your plugins array (make sure the names exactly match your GitHub folders)
PLUGINS=("shell-cwd.yazi" "smart-enter.yazi")

# 4. Loop through each plugin, create its directory, and download its files
for plugin in "${PLUGINS[@]}"; do
    mkdir -p "plugins/$plugin"
    
    for file in main.lua README.md LICENSE; do
        # We use -o here to save it into the correct subfolder since -O would dump it in the current dir
        curl -sL -o "plugins/$plugin/$file" "$REPO_URL/plugins/$plugin/$file"
    done
    echo "  -> Synced: $plugin"
done

echo "Yazi sync complete!"
