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

# copy Polybar config
if [ -f "$HOME/.config/polybar/config.ini" ]; then
    cp -r "$HOME/.config/polybar" "$DEST_DIR"
    echo "Copied Alacritty configuration to $DEST_DIR"
else
    echo "Copying Polybar config failed"
fi

# i3
if [ -f "$HOME/.config/i3/config" ]; then
    cp -r "$HOME/.config/i3" "$DEST_DIR"
    echo "Copy i3 config success"
else
    echo "Warning: i3 config not found"
fi

# rofi
if [ -f "$HOME/.config/rofi/config.rasi" ]; then
    cp -r "$HOME/.config/rofi" "$DEST_DIR"
    echo "Copy rofi config success"
else
    echo "Warning: rofi config not found"
fi

# zathura
if [ -f "$HOME/.config/zathura/zathurarc" ]; then
    cp -r "$HOME/.config/zathura" "$DEST_DIR"
    echo "Copy zathura config success"
else
    echo "Warning: zathura config not found"
fi

