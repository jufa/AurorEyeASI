#!/bin/bash
set -euo pipefail

MOUNT_POINT="/mnt/extstore"
FSTAB="/etc/fstab"

# -----------------------------
# 0. Root check
# -----------------------------
if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: This script must be run as root (use sudo)"
  exit 1
fi

echo "=== External Storage Setup for Raspberry Pi (Bookworm) ==="
echo

# -----------------------------
# 1. List available volumes
# -----------------------------
echo "Available block devices:"
echo "------------------------------------------------------------"
lsblk -o NAME,MODEL,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT
echo "------------------------------------------------------------"
echo
echo "⚠️  Do NOT select:"
echo "   - mmcblk0*  (SD card)"
echo "   - / (root filesystem)"
echo

# -----------------------------
# 2. User selects device
# -----------------------------
read -rp "Enter device to mount (e.g. /dev/sda1): " DEV

if [ ! -b "$DEV" ]; then
  echo "ERROR: $DEV is not a valid block device"
  exit 1
fi

if echo "$DEV" | grep -q "mmcblk0"; then
  echo "ERROR: Refusing to touch SD card device ($DEV)"
  exit 1
fi

# -----------------------------
# 3. Check filesystem
# -----------------------------
FSTYPE=$(blkid -o value -s TYPE "$DEV" || true)

if [ "$FSTYPE" != "ext4" ]; then
  echo
  if [ -z "$FSTYPE" ]; then
    echo "No filesystem detected on $DEV."
  else
    echo "Filesystem detected on $DEV is '$FSTYPE', not ext4."
  fi

  read -rp "Do you want to reformat $DEV as ext4 with label 'extstore'? (yes/NO): " CONFIRM
  if [ "$CONFIRM" != "yes" ]; then
    echo "Aborting."
    exit 1
  fi

  echo "Formatting $DEV as ext4..."
  mkfs.ext4 -L extstore "$DEV"
  FSTYPE="ext4"
fi

# -----------------------------
# 4. Ensure mount point exists
# -----------------------------
mkdir -p "$MOUNT_POINT"

# -----------------------------
# 5. Get UUID
# -----------------------------
UUID=$(blkid -o value -s UUID "$DEV")

if [ -z "$UUID" ]; then
  echo "ERROR: Unable to determine UUID for $DEV"
  exit 1
fi

# -----------------------------
# 6. Prepare fstab entry
# -----------------------------
FSTAB_LINE="UUID=$UUID  $MOUNT_POINT  ext4  defaults,nofail,x-systemd.automount,x-systemd.device-timeout=5  0  2"

echo
echo "Proposed /etc/fstab entry:"
echo "------------------------------------------------------------"
echo "$FSTAB_LINE"
echo "------------------------------------------------------------"
echo

read -rp "Apply this change? (yes/NO): " APPLY
if [ "$APPLY" != "yes" ]; then
  echo "Aborting."
  exit 1
fi

# Backup fstab
BACKUP="/etc/fstab.bak.$(date +%Y%m%d-%H%M%S)"
cp "$FSTAB" "$BACKUP"
echo "Backup created: $BACKUP"

# Remove any existing extstore entries
sed -i '\|/mnt/extstore|d' "$FSTAB"

# Append new entry
echo "$FSTAB_LINE" >> "$FSTAB"

# -----------------------------
# 7. Reload and test
# -----------------------------
systemctl daemon-reload

echo
echo "Testing mount (mount -a)..."
if mount -a; then
  echo "Mount test succeeded."
else
  echo "ERROR: mount -a failed. Restoring fstab backup."
  cp "$BACKUP" "$FSTAB"
  exit 1
fi

echo
echo "Final mount status:"
mount | grep "$MOUNT_POINT" || echo "Mounted on demand (automount active)"

echo
echo "✅ External storage setup complete."
echo "Reboot not required."

#!/bin/bash
set -euo pipefail

MOUNT_POINT="/mnt/extstore"
FSTAB="/etc/fstab"

# -----------------------------
# 0. Root check
# -----------------------------
if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: This script must be run as root (use sudo)"
  exit 1
fi

echo "=== External Storage Setup for Raspberry Pi (Bookworm) ==="
echo

# -----------------------------
# 1. List available volumes
# -----------------------------
echo "Available block devices:"
echo "------------------------------------------------------------"
lsblk -o NAME,MODEL,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT
echo "------------------------------------------------------------"
echo
echo "⚠️  Do NOT select:"
echo "   - mmcblk0*  (SD card)"
echo "   - / (root filesystem)"
echo

# -----------------------------
# 2. User selects device
# -----------------------------
read -rp "Enter device to mount (e.g. /dev/sda1): " DEV

if [ ! -b "$DEV" ]; then
  echo "ERROR: $DEV is not a valid block device"
  exit 1
fi

if echo "$DEV" | grep -q "mmcblk0"; then
  echo "ERROR: Refusing to touch SD card device ($DEV)"
  exit 1
fi

# -----------------------------
# 3. Check filesystem
# -----------------------------
FSTYPE=$(blkid -o value -s TYPE "$DEV" || true)

if [ "$FSTYPE" != "ext4" ]; then
  echo
  if [ -z "$FSTYPE" ]; then
    echo "No filesystem detected on $DEV."
  else
    echo "Filesystem detected on $DEV is '$FSTYPE', not ext4."
  fi

  read -rp "Do you want to reformat $DEV as ext4 with label 'extstore'? (yes/NO): " CONFIRM
  if [ "$CONFIRM" != "yes" ]; then
    echo "Aborting."
    exit 1
  fi

  echo "Formatting $DEV as ext4..."
  mkfs.ext4 -L extstore "$DEV"
  FSTYPE="ext4"
fi

# -----------------------------
# 4. Ensure mount point exists
# -----------------------------
mkdir -p "$MOUNT_POINT"

# -----------------------------
# 5. Get UUID
# -----------------------------
UUID=$(blkid -o value -s UUID "$DEV")

if [ -z "$UUID" ]; then
  echo "ERROR: Unable to determine UUID for $DEV"
  exit 1
fi

# -----------------------------
# 6. Prepare fstab entry
# -----------------------------
FSTAB_LINE="UUID=$UUID  $MOUNT_POINT  ext4  defaults,nofail,x-systemd.automount,x-systemd.device-timeout=5  0  2"

echo
echo "Proposed /etc/fstab entry:"
echo "------------------------------------------------------------"
echo "$FSTAB_LINE"
echo "------------------------------------------------------------"
echo

read -rp "Apply this change? (yes/NO): " APPLY
if [ "$APPLY" != "yes" ]; then
  echo "Aborting."
  exit 1
fi

# Backup fstab
BACKUP="/etc/fstab.bak.$(date +%Y%m%d-%H%M%S)"
cp "$FSTAB" "$BACKUP"
echo "Backup created: $BACKUP"

# Remove any existing extstore entries
sed -i '\|/mnt/extstore|d' "$FSTAB"

# Append new entry
echo "$FSTAB_LINE" >> "$FSTAB"

# -----------------------------
# 7. Reload and test
# -----------------------------
systemctl daemon-reload

echo
echo "Testing mount (mount -a)..."
if mount -a; then
  echo "Mount test succeeded."
else
  echo "ERROR: mount -a failed. Restoring fstab backup."
  cp "$BACKUP" "$FSTAB"
  exit 1
fi

echo
echo "Final mount status:"
mount | grep "$MOUNT_POINT" || echo "Mounted on demand (automount active)"

echo
echo "✅ External storage setup complete."
echo "Reboot not required."
