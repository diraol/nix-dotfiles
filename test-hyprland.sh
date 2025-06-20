#!/bin/bash

# Hyprland System Check and Debug Tool
# This script checks if your system is ready to run Hyprland

echo "🧪 Hyprland System Diagnostic Tool"
echo "=================================="
echo

# Check current session type
echo "📋 Session Information:"
echo "Current session type: ${XDG_SESSION_TYPE:-unknown}"
echo "Display server: ${DISPLAY:+X11}${WAYLAND_DISPLAY:+Wayland}${DISPLAY}${WAYLAND_DISPLAY:-TTY}"
echo

# Check GPU access
echo "🎮 GPU Information:"
if command -v lspci >/dev/null; then
    echo "Available GPUs:"
    lspci | grep -E "(VGA|3D|Display)" | sed 's/^/  /'
else
    echo "  lspci not available"
fi

echo
echo "DRM devices:"
if ls /dev/dri/card* >/dev/null 2>&1; then
    ls -la /dev/dri/card* | sed 's/^/  /'
    if [ -r /dev/dri/card0 ] || [ -r /dev/dri/card1 ]; then
        echo "  ✓ GPU devices are accessible"
    else
        echo "  ❌ GPU devices not accessible - you may need to add user to 'video' group"
    fi
else
    echo "  ❌ No DRM devices found"
fi

echo
echo "👤 User Groups:"
groups | tr ' ' '\n' | grep -E "(video|render|input)" | sed 's/^/  /' || echo "  ❌ Missing video/render/input groups"

echo
echo "🔧 System Requirements Check:"

# Check if Hyprland is installed
if command -v Hyprland >/dev/null; then
    echo "  ✓ Hyprland is installed: $(which Hyprland)"
    echo "  Version: $(Hyprland --version 2>/dev/null || echo 'unknown')"
else
    echo "  ❌ Hyprland not found in PATH"
fi

# Check for required dependencies
deps=("waybar" "wofi" "kitty" "dunst")
echo
echo "📦 Dependencies:"
for dep in "${deps[@]}"; do
    if command -v "$dep" >/dev/null; then
        echo "  ✓ $dep: $(which $dep)"
    else
        echo "  ❌ $dep: not found"
    fi
done

echo
echo "💡 Recommendations:"
if [ "$XDG_SESSION_TYPE" = "x11" ] || [ -n "$DISPLAY" ]; then
    echo "  • You're currently in an X11 session"
    echo "  • Switch to TTY (Ctrl+Alt+F2) and run: ./start-hyprland.sh"
fi

if ! groups | grep -q video; then
    echo "  • Add user to video group: sudo usermod -a -G video $USER"
    echo "  • Then log out and back in"
fi

echo
echo "🚀 To start Hyprland:"
echo "  1. Switch to TTY (Ctrl+Alt+F2, F3, etc.)"
echo "  2. Run: cd ~/dev/nix-dotfiles && ./start-hyprland.sh"
echo
echo "📝 For debugging, check logs at:"
echo "  ~/.cache/hyprland/" 
