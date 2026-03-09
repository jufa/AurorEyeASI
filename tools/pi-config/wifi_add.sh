#!/bin/bash
# Usage: sudo ./add_wifi_wlan0.sh "SSID_NAME" "PASSWORD"
# Adds a Wi-Fi network to NetworkManager specifically for wlan0, even if not in range.

set -e

SSID="$1"
PASSWORD="$2"

if [ -z "$SSID" ] || [ -z "$PASSWORD" ]; then
    echo "Usage: sudo $0 \"SSID_NAME\" \"PASSWORD\""
    exit 1
fi

CON_NAME="${SSID}_wlan0"

# Check if the connection already exists for wlan0
if nmcli -t -f NAME,DEVICE connection show | grep -E "^${CON_NAME}:wlan0$" >/dev/null; then
    echo "Connection '$CON_NAME' already exists for wlan0. Updating password..."
    sudo nmcli connection modify "$CON_NAME" wifi-sec.psk "$PASSWORD"
else
    echo "Adding new Wi-Fi connection '$CON_NAME' for wlan0..."
    sudo nmcli connection add type wifi ifname wlan0 con-name "$CON_NAME" ssid "$SSID"
    sudo nmcli connection modify "$CON_NAME" wifi-sec.key-mgmt wpa-psk
    sudo nmcli connection modify "$CON_NAME" wifi-sec.psk "$PASSWORD"
    sudo nmcli connection modify "$CON_NAME" connection.autoconnect yes
fi

echo "Reloading NetworkManager..."
sudo nmcli connection reload

echo "Wi-Fi network '$SSID' added to wlan0 (autoconnect enabled)."
