#!/bin/bash

# Production Hyprland launcher - Intel Graphics Mode with nixGL
# This should be run from a TTY session (Ctrl+Alt+F2, F3, etc.)

echo "🚀 Starting Hyprland with Intel Graphics using nixGL..."
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

# Set up environment for Intel graphics
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=hyprland
export XDG_SESSION_DESKTOP=hyprland

# Force Intel graphics (avoid NVIDIA issues)
export WLR_NO_HARDWARE_CURSORS=1
export __GLX_VENDOR_LIBRARY_NAME=mesa
export GBM_BACKEND=
unset GBM_BACKEND
export DRI_PRIME=0

# Explicitly set DRM device to Intel GPU
export WLR_DRM_DEVICES=/dev/dri/card1

# Ensure we have access to the DRI devices
if [ ! -r /dev/dri/card1 ]; then
    echo "❌ Error: No access to GPU device /dev/dri/card1"
    echo "   You may need to add your user to the 'video' group:"
    echo "   sudo usermod -a -G video $USER"
    echo "   Then log out and back in."
    exit 1
fi

echo "🎮 Using Intel integrated graphics with nixGL for stability"
echo "Starting Hyprland..."

# Start Hyprland with nixGL wrapper
exec nixGL Hyprland
