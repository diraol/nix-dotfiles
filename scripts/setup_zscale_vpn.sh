#!/bin/bash

INSTALLER="/opt/zscaler/Zscaler-linux-3.7.1.71-installer.run"
CLOUD_NAME="zscalertwo"
USER_DOMAIN="nubank.com.br"
MODE="unattended"
UNATTENDEDMODEUI="none"
HIDE_APP_UI="1"

usage() {
  echo "Installer file not found or not executable: $INSTALLER"
  exit 1
}

if [ ! -f "$INSTALLER" ] || [ ! -x "$INSTALLER" ]; then
    chmod +x "$INSTALLER"
    if [ $? -ne 0 ]; then
        usage
    fi
fi

echo "Installing zscaler client..."

"$INSTALLER" --mode "$MODE" --unattendedmodeui "$UNATTENDEDMODEUI" --hideAppUIOnLaunch "$HIDE_APP_UI" --cloudName "$CLOUD_NAME" --userDomain "$USER_DOMAIN"

if [ $? -eq 0 ]; then
    echo "Zscaler client installed successfully."
else
    echo "Zscaler client installation failed."
    exit 1
fi
