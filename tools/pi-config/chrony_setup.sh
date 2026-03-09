#!/bin/bash
# --------------------------------------------------------
# Raspberry Pi field-ready Chrony + GPSD setup
# - Chrony uses GPS via SHM (from GPSD)
# - Python (venv) can access raw NMEA from GPSD concurrently
# - Large offsets (>1s) are stepped immediately
# --------------------------------------------------------

set -e

echo "=== Disabling serial console to free /dev/serial0 ==="
sudo systemctl stop serial-getty@ttyAMA0.service
sudo systemctl disable serial-getty@ttyAMA0.service

echo "=== Installing chrony and gpsd ==="
sudo apt update
sudo apt install -y chrony gpsd gpsd-clients

# Use venv python for GPSD library
echo "=== Installing gpsd-py3 in current venv ==="
python -m pip install --upgrade gpsd-py3

echo "=== Stopping GPSD service for configuration ==="
sudo systemctl stop gpsd

echo "=== Backing up existing chrony.conf ==="
sudo cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bak

echo "=== Writing new chrony.conf for GPS + NTP fallback ==="
sudo tee /etc/chrony/chrony.conf > /dev/null <<'EOF'
# --------------------------------------------------------
# Chrony configuration for field RPi
# - NTP servers preferred
# - GPS via SHM fallback
# - Immediate step if clock offset > 1s
# --------------------------------------------------------

# Primary NTP servers
pool pool.ntp.org iburst prefer
pool time.google.com iburst
pool time.cloudflare.com iburst

# GPS via SHM from gpsd
refclock SHM 0 offset 0.5 delay 0.2 refid GPS

# Step system clock immediately at first fix if offset > 1s
makestep 1.0 -1

# Logging
logdir /var/log/chrony
log measurements statistics tracking
EOF

echo "=== Configuring GPSD to use /dev/serial0 ==="
sudo gpsd /dev/serial0 -F /var/run/gpsd.sock
sudo systemctl enable gpsd

echo "=== Restarting chrony service ==="
sudo systemctl restart chrony

echo "=== Verifying chrony status ==="
sudo systemctl status chrony | head -n 20
chronyc sources -v
chronyc tracking

echo "=== Setup complete ==="
echo "Chrony now uses GPS via SHM; Python in venv can access NMEA via gpsd."
