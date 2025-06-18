#!/bin/bash

# Script to set ZSH as default shell for current user
# Run this after activating home-manager configuration

set -e

echo "🐚 Setting up ZSH as default shell..."

# Get the Nix-managed zsh path
ZSH_PATH=$(which zsh 2>/dev/null || echo "/home/$USER/.nix-profile/bin/zsh")

if [[ ! -f "$ZSH_PATH" ]]; then
    echo "❌ ZSH not found. Please run 'home-manager switch --flake .#diraol' first."
    exit 1
fi

echo "📍 Found ZSH at: $ZSH_PATH"

# Check if zsh is already in /etc/shells
if ! grep -q "^$ZSH_PATH$" /etc/shells 2>/dev/null; then
    echo "📝 Adding ZSH to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
else
    echo "✅ ZSH already in /etc/shells"
fi

# Get current shell
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
echo "🔍 Current shell: $CURRENT_SHELL"

# Change default shell if not already zsh
if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then
    echo "🔄 Changing default shell to ZSH..."
    chsh -s "$ZSH_PATH"
    echo "✅ Default shell changed to ZSH!"
    echo ""
    echo "🔄 Please log out and log back in, or restart your terminal"
    echo "   to use ZSH as your default shell."
else
    echo "✅ ZSH is already your default shell!"
fi

echo ""
echo "🎯 To verify: run 'echo \$SHELL' in a new terminal session"
echo "🎨 Your powerlevel10k theme will work best with ZSH as default" 