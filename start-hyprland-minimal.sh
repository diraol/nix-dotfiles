#!/bin/bash

# Minimal Hyprland launcher with software fallback and nixGL
# This uses software rendering to bypass hardware issues

echo "🚀 Starting Hyprland in minimal/software mode with nixGL..."
echo "This uses software rendering - slower but more compatible"
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

# Minimal environment setup
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=hyprland
export XDG_SESSION_DESKTOP=hyprland

# Force the usage of Intel GPU.
export DRI_PRIME=0

# Force software rendering to bypass GPU issues
export WLR_RENDERER=pixman
export WLR_NO_HARDWARE_CURSORS=1
export WLR_BACKEND=drm

# Explicitly set DRM device to Intel GPU
export WLR_DRM_DEVICES=/dev/dri/card1

# Disable all GPU acceleration
unset __GLX_VENDOR_LIBRARY_NAME
unset GBM_BACKEND
unset LIBVA_DRIVER_NAME

echo "🎮 Using software rendering (pixman) with nixGL - bypassing GPU hardware issues"
echo "Starting Hyprland..."

# Start Hyprland with nixGL wrapper
exec nixGLIntel Hyprland 
