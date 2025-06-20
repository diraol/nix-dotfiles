#!/bin/bash

# Debug Hyprland launcher with minimal config and nixGL
# This uses software rendering and minimal config for maximum compatibility

echo "🧪 Starting Hyprland in DEBUG mode with nixGL..."
echo "This uses software rendering + minimal config"
echo "Make sure you're running this from a TTY session!"
echo "Press Ctrl+C to cancel, or Enter to continue..."
read

# Check if we're in a TTY
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    echo "✓ Running from TTY - good!"
else
    echo "⚠️  Warning: You appear to be running from a graphical session"
    echo "   This might cause issues. Consider switching to TTY first."
    echo "   Press Ctrl+C to cancel, or Enter to continue anyway..."
    read
fi

# Debug info
echo "🔍 Debug Information:"
echo "User: $(whoami)"
echo "Groups: $(groups)"
echo "DRI devices:"
ls -la /dev/dri/ 2>/dev/null || echo "  No DRI devices found"
echo

# Minimal environment setup
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=hyprland
export XDG_SESSION_DESKTOP=hyprland

# Force software rendering to bypass ALL GPU issues
export WLR_RENDERER=pixman
export WLR_NO_HARDWARE_CURSORS=1
export WLR_BACKEND=drm

# Explicitly set DRM device to Intel GPU
export WLR_DRM_DEVICES=/dev/dri/card1

# Disable all GPU acceleration
unset __GLX_VENDOR_LIBRARY_NAME
unset GBM_BACKEND
unset LIBVA_DRIVER_NAME
unset DRI_PRIME

# Use minimal config
export HYPRLAND_CONFIG_FILE="$HOME/dev/nix-dotfiles/config/.config/hypr/hyprland-minimal.conf"

echo "🎮 Using software rendering (pixman) with minimal config and nixGL"
echo "📁 Config file: $HYPRLAND_CONFIG_FILE"
echo "Starting Hyprland..."

# Start Hyprland with nixGL wrapper and explicit config
exec nixGLIntel Hyprland --config "$HYPRLAND_CONFIG_FILE" 