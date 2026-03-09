#!/usr/bin/env bash
set -e

AP_CON="AurorEye"
IFACE="wlan0"
IP_ADDR="192.168.4.1/24"
CHANNEL="6"
BAND="bg"

usage() {
    echo "Usage: $0 --ssid <ssid> --password <passphrase>"
    echo "  WPA2-PSK passphrase must be 8–63 characters"
    exit 1
}

# ---- parse args ----
SSID=""
PASS=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --ssid)
            SSID="$2"
            shift 2
            ;;
        --password)
            PASS="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

[[ -z "$SSID" || -z "$PASS" ]] && usage
[[ ${#PASS} -lt 8 || ${#PASS} -gt 63 ]] && {
    echo "Error: WPA2 password must be 8–63 characters"
    exit 1
}

# ---- check nmcli ----
command -v nmcli >/dev/null || {
    echo "Error: nmcli not found (NetworkManager required)"
    exit 1
}

# ---- create or modify connection ----
if nmcli con show "$AP_CON" >/dev/null 2>&1; then
    echo "Updating existing AP connection: $AP_CON"
else
    echo "Creating AP connection: $AP_CON"
    nmcli con add \
        type wifi \
        ifname "$IFACE" \
        mode ap \
        con-name "$AP_CON" \
        ssid "$SSID"
fi

# ---- configure AP ----
nmcli con modify "$AP_CON" \
    wifi.ssid "$SSID" \
    wifi.band "$BAND" \
    wifi.channel "$CHANNEL" \
    wifi-sec.key-mgmt wpa2-psk \
    wifi-sec.psk "$PASS" \
    ipv4.method manual \
    ipv4.addresses "$IP_ADDR" \
    ipv4.never-default yes \
    connection.autoconnect no

echo "AP setup complete."
echo "SSID: $SSID"
echo "IP:   192.168.4.1"
echo "Use with: nmcli con up $AP_CON"
