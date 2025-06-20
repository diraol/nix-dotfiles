#!/bin/bash

# NVIDIA-specific Hyprland launcher (Advanced)
# Only use this if Intel graphics script doesn't work

echo "🚀 Starting Hyprland with NVIDIA Graphics..."
echo "⚠️  This is advanced mode - use only if Intel mode failed"
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

# Set up environment
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=hyprland
export XDG_SESSION_DESKTOP=hyprland

# NVIDIA-specific environment
export LIBVA_DRIVER_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export WLR_NO_HARDWARE_CURSORS=1
export WLR_RENDERER=gles2
export WLR_DRM_NO_ATOMIC=1

# Additional NVIDIA Wayland fixes
export __GL_GSYNC_ALLOWED=0
export __GL_VRR_ALLOWED=0
export __GL_SHADER_DISK_CACHE_PATH=/tmp/nvidia-shader-cache
export __GL_THREADED_OPTIMIZATIONS=1

# Use discrete GPU
export DRI_PRIME=1

echo "🎮 Attempting to use NVIDIA graphics"
echo "Starting Hyprland..."

# Start Hyprland
exec Hyprland 