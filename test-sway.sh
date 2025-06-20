#!/bin/bash

# Test Sway as alternative Wayland compositor
# This helps us understand if the issue is Hyprland-specific or system-wide

echo "🧪 Testing Sway as alternative Wayland compositor..."
echo "This will help diagnose if the issue is specific to Hyprland"
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

# Check if Sway is available
if ! command -v sway >/dev/null 2>&1; then
    echo "❌ Sway is not installed. Installing it might help test Wayland support:"
    echo "   Add 'sway' to your Nix configuration"
    exit 1
fi

# Debug info
echo "🔍 Debug Information:"
echo "User: $(whoami)"
echo "Groups: $(groups)"
echo "DRI devices:"
ls -la /dev/dri/ 2>/dev/null || echo "  No DRI devices found"
echo "Sway version: $(sway --version 2>/dev/null || echo 'unknown')"
echo

# Basic environment setup
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

# Force software rendering for testing
export WLR_RENDERER=pixman
export WLR_NO_HARDWARE_CURSORS=1

echo "🎮 Testing Sway with software rendering..."
echo "If this works, the issue is Hyprland-specific"
echo "If this fails, the issue is system-wide Wayland"
echo

# Create minimal Sway config
cat > /tmp/sway-test.conf << 'EOF'
# Minimal Sway config for testing
bindsym $mod+Return exec kitty
bindsym $mod+Shift+q kill
bindsym $mod+q exit

set $mod Mod4
font pango:monospace 10

# Software rendering
output * bg #000000 solid_color

# Use software rendering
exec_always --no-startup-id "echo 'Sway test session started'"
EOF

echo "Starting Sway with minimal test config..."
echo "Press Mod+Q to exit if it works"

# Start Sway with test config
exec sway -c /tmp/sway-test.conf 