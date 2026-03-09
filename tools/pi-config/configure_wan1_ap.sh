#!/bin/bash
# setup_ap.sh
# Usage: ./setup_ap.sh <AP_NAME>

if [ -z "$1" ]; then
  echo "Error: You must provide an AP name/SSID."
  echo "Usage: $0 <AP_NAME>"
  exit 1
fi

AP_NAME="$1"
CON_NAME="$AP_NAME"  # Use same string for NM connection name

# Check if NetworkManager connection already exists
EXISTING=$(nmcli -t -f NAME connection show | grep "^$CON_NAME$")

if [ -z "$EXISTING" ]; then
  echo "Creating new AP connection '$CON_NAME' with SSID '$AP_NAME' on wlan1..."
  nmcli connection add type wifi ifname wlan1 mode ap con-name "$CON_NAME" ssid "$AP_NAME"
  nmcli connection modify "$CON_NAME" 802-11-wireless.band bg
  nmcli connection modify "$CON_NAME" ipv4.method shared
else
  echo "Updating existing AP connection '$CON_NAME' with SSID '$AP_NAME'..."
  nmcli connection modify "$CON_NAME" 802-11-wireless.ssid "$AP_NAME"
  nmcli connection modify "$CON_NAME" 802-11-wireless.mode ap
  nmcli connection modify "$CON_NAME" ipv4.method shared
fi

# Ensure it autoconnects and binds to wlan1
nmcli connection modify "$CON_NAME" connection.autoconnect yes
nmcli connection modify "$CON_NAME" connection.interface-name wlan1

# Bring up the AP
echo "Bringing up the AP..."
nmcli connection up "$CON_NAME"

echo "Done. AP '$AP_NAME' should now be visible on wlan1."
