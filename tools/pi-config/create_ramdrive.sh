#!/bin/bash
# create_ramdrive.sh
# Create a tmpfs (RAM drive) on Raspberry Pi.
# Usage: sudo ./create_ramdrive.sh <mount_path> <size_in_MB> [--persistent]
# Example: sudo ./create_ramdrive.sh /mnt/ramdisk 50 --persistent

set -e

# --- Functions ---
show_help() {
  echo "Usage: sudo $0 <mount_path> <size_in_MB> [--persistent]"
  echo
  echo "Example:"
  echo "  sudo $0 /mnt/ramdisk 50"
  echo "  sudo $0 /mnt/ramdisk 50 --persistent"
  echo
  echo "Options:"
  echo "  --persistent   Add or update an entry in /etc/fstab so it mounts automatically on boot."
  exit 1
}

# --- Argument parsing ---
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  show_help
fi

if [ $# -lt 2 ]; then
  echo "❌ Error: Missing arguments."
  show_help
fi

MOUNT_PATH="$1"
SIZE_MB="$2"
PERSISTENT=false
[ "$3" == "--persistent" ] && PERSISTENT=true

# --- Validate size ---
if ! [[ "$SIZE_MB" =~ ^[0-9]+$ ]]; then
  echo "❌ Error: Size must be an integer (MB)."
  exit 1
fi

# --- Ensure directory exists ---
if [ ! -d "$MOUNT_PATH" ]; then
  echo "📁 Creating directory $MOUNT_PATH ..."
  mkdir -p "$MOUNT_PATH"
fi

# --- If already mounted, unmount first ---
if mountpoint -q "$MOUNT_PATH"; then
  echo "⚠️  $MOUNT_PATH is already mounted. Unmounting first..."
  umount "$MOUNT_PATH"
fi

# --- Mount tmpfs ---
echo "⚙️ Mounting tmpfs of size ${SIZE_MB}M at ${MOUNT_PATH} ..."
mount -t tmpfs -o size=${SIZE_MB}M,mode=1777 tmpfs "$MOUNT_PATH"

# --- Verify mount ---
echo "✅ Mounted RAM drive:"
df -h "$MOUNT_PATH" | tail -n 1

# --- Optional: Make persistent ---
if [ "$PERSISTENT" = true ]; then
  echo "🧩 Making RAM drive persistent..."
  FSTAB_LINE="tmpfs ${MOUNT_PATH} tmpfs size=${SIZE_MB}M,mode=1777 0 0"

  # Remove any existing entry for this path
  if grep -q " ${MOUNT_PATH} " /etc/fstab; then
    echo "🔄 Updating existing /etc/fstab entry..."
    sed -i "\| ${MOUNT_PATH} |c\\${FSTAB_LINE}" /etc/fstab
  else
    echo "➕ Adding new entry to /etc/fstab..."
    echo "${FSTAB_LINE}" >> /etc/fstab
  fi

  echo "✅ Persistent mount configured. Will auto-mount at boot."
fi

echo
echo "📋 Summary:"
echo "  Mount path: $MOUNT_PATH"
echo "  Size:       ${SIZE_MB}M"
echo "  Persistent: $PERSISTENT"
echo
echo "Unmount with:  sudo umount $MOUNT_PATH"
echo "Recreate at boot: add '--persistent' next time if you want it permanent."
