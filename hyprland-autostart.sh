#!/bin/bash

# Script to configure Hyprland auto-start on user login
# This sets up a systemd user service for automatic Hyprland startup

set -e

echo "🖥️ Setting up Hyprland auto-start..."

# Create systemd user directory
mkdir -p ~/.config/systemd/user

# Create Hyprland service file
cat > ~/.config/systemd/user/hyprland.service << 'EOF'
[Unit]
Description=Hyprland Wayland Compositor
After=graphical-session.target

[Service]
Type=notify
ExecStart=/usr/bin/env Hyprland
Restart=on-failure
RestartSec=1
TimeoutStopSec=10
KillMode=mixed
Environment=WLR_NO_HARDWARE_CURSORS=1
Environment=XDG_CURRENT_DESKTOP=Hyprland
Environment=XDG_SESSION_DESKTOP=Hyprland
Environment=XDG_SESSION_TYPE=wayland

[Install]
WantedBy=graphical-session.target
EOF

echo "✅ Created Hyprland systemd service"

# Enable the service
systemctl --user daemon-reload
systemctl --user enable hyprland.service

echo "✅ Enabled Hyprland auto-start service"
echo ""
echo "🔄 Hyprland will now start automatically on next login"
echo "🎯 To disable: systemctl --user disable hyprland.service"
echo "🔍 To check status: systemctl --user status hyprland.service"

# Ask if user wants to start now
read -p "🚀 Start Hyprland now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    systemctl --user start hyprland.service
    echo "✅ Hyprland started!"
fi 