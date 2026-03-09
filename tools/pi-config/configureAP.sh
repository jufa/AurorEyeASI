# may have to install REALTEK8818BU driver if on kernel < 3.12 (i.e. older than raspbian trixie)
SSID="MY_AP_NAME"
PASS="MY_PASSWORD"

# Remove any previous connection with same name
sudo nmcli connection delete ap-wlan1 || true

# Create AP
sudo nmcli connection add type wifi ifname wlan1 con-name ap-wlan1 autoconnect yes ssid "$SSID"

# Configure AP mode
sudo nmcli connection modify ap-wlan1 802-11-wireless.mode ap
sudo nmcli connection modify ap-wlan1 802-11-wireless.band bg
sudo nmcli connection modify ap-wlan1 802-11-wireless.channel 6

# Static IP for AP
sudo nmcli connection modify ap-wlan1 ipv4.addresses 192.168.4.1/24
sudo nmcli connection modify ap-wlan1 ipv4.method shared   # internal DHCP + NAT
sudo nmcli connection modify ap-wlan1 ipv6.method ignore

# Security
sudo nmcli connection modify ap-wlan1 802-11-wireless-security.key-mgmt wpa-psk
sudo nmcli connection modify ap-wlan1 802-11-wireless-security.psk "$PASS"
