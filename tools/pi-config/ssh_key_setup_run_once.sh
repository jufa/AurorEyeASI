#!/usr/bin/env bash
set -e

echo "============================================"
echo " Regenerating SSH host keys on this Pi"
echo "============================================"
echo
echo "This should be done ONCE per cloned image."
echo "It makes this Pi cryptographically unique."
echo

# Must be root
if [[ $EUID -ne 0 ]]; then
  echo "ERROR: This script must be run as root."
  echo "Run: sudo $0"
  exit 1
fi

echo "Stopping SSH service..."
systemctl stop ssh

echo "Removing existing SSH host keys..."
rm -f /etc/ssh/ssh_host_*

echo "Regenerating fresh host keys..."
dpkg-reconfigure openssh-server

echo "Starting SSH service..."
systemctl start ssh

echo
echo "============================================"
echo " SSH host keys regenerated successfully"
echo "============================================"
echo
echo "NEXT STEPS (from your Mac or other client):"
echo
echo "1) Connect normally:"
echo "     ssh pi@<pi-ip>"
echo
echo "2) You WILL see an authenticity warning."
echo "   This is EXPECTED."
echo
echo "3) Type: yes"
echo
echo "4) SSH will remember this Pi as a new machine."
echo
echo "No files or keys need to be copied to your Mac."
echo
echo "--------------------------------------------"
echo "Optional cleanup on the client side:"
echo
echo "If SSH refuses due to old entries, run:"
echo "  ssh-keygen -R <pi-ip>"
echo "  ssh-keygen -R <hostname>"
echo "--------------------------------------------"
echo
echo "Done."
