#!/bin/bash

# Destination directory for dotfiles
DEST_DIR="$HOME/dotfiles"

# Copy Neovim configuration file
if [ -f "$HOME/.config/nvim/init.lua" ]; then
    cp -r "$HOME/.config/nvim" "$DEST_DIR"
    echo "Copied Neovim configuration to $DEST_DIR"
else
    echo "Neovim configuration not found at $HOME/.config/nvim"
fi

# Copy Alacritty configuration file
if [ -f "$HOME/.config/alacritty/alacritty.toml" ]; then
    cp -r "$HOME/.config/alacritty" "$DEST_DIR"
    echo "Copied Alacritty configuration to $DEST_DIR"
else
    echo "Alacritty configuration not found at $HOME/.config/alacritty"
fi

