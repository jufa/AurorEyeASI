#!/usr/bin/env bash
set -e

echo "=== Installing zram tools ==="
sudo apt update
sudo apt install -y zram-tools

# --- Determine supported compression algorithm ---
echo "=== Detecting supported compression algorithm ==="
ALGO="lzo"  # default fallback
if [ -d /sys/block/zram0 ]; then
    SUPPORTED=$(cat /sys/block/zram0/comp_algorithm 2>/dev/null || echo "")
    if echo "$SUPPORTED" | grep -q "lz4"; then
        ALGO="lz4"
    elif echo "$SUPPORTED" | grep -q "zstd"; then
        ALGO="zstd"
    fi
else
    # fallback if zram0 not yet exists
    ALGO="lz4"
fi
echo "Using ZRAM compression algorithm: $ALGO"

# --- Stop zramswap service to prevent conflicts ---
sudo systemctl stop zramswap || true
sudo swapoff -a || true

# --- Reset existing zram0 safely ---
if [ -d /sys/block/zram0 ]; then
    echo "Resetting existing /dev/zram0"
    echo 1 | sudo tee /sys/block/zram0/reset
fi

# --- Configure ZRAM size and algorithm ---
RAM_TOTAL_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ZRAM_SIZE=$(( RAM_TOTAL_KB / 4 * 1024 ))  # RAM/4 bytes

echo "$ALGO" | sudo tee /sys/block/zram0/comp_algorithm
echo $ZRAM_SIZE | sudo tee /sys/block/zram0/disksize

sudo mkswap /dev/zram0
sudo swapon /dev/zram0 -p 100
echo "ZRAM configured with $(numfmt --to=iec $ZRAM_SIZE) bytes"

# --- Configure SD card swapfile ---
SWAPFILE="/swapfile"
SWAP_SIZE="1G"

if [ ! -f $SWAPFILE ]; then
    echo "Creating SD card swapfile ($SWAP_SIZE)"
    sudo fallocate -l $SWAP_SIZE $SWAPFILE
    sudo chmod 600 $SWAPFILE
    sudo mkswap $SWAPFILE
fi

sudo swapon --priority 10 $SWAPFILE || echo "SD swapfile already active"

# Make swapfile persistent
if ! grep -q "$SWAPFILE" /etc/fstab; then
    echo "$SWAPFILE none swap sw,pri=10 0 0" | sudo tee -a /etc/fstab
fi

# --- Set swappiness and page-cluster ---
sudo tee /etc/sysctl.d/99-swap.conf > /dev/null <<'EOF'
vm.swappiness=60
vm.page-cluster=0
EOF
sudo sysctl --system

# --- Configure tmpfs for /tmp and /var/log ---
sudo cp /etc/fstab /etc/fstab.bak.$(date +%Y%m%d-%H%M%S)

# /tmp
if ! grep -q ' /tmp ' /etc/fstab; then
    echo 'tmpfs /tmp tmpfs defaults,noatime,nosuid,size=100M 0 0' | sudo tee -a /etc/fstab
fi

# /var/log
if ! grep -q ' /var/log ' /etc/fstab; then
    echo 'tmpfs /var/log tmpfs defaults,noatime,mode=0755,size=50M 0 0' | sudo tee -a /etc/fstab
fi

# Mount immediately
sudo mount -o remount /tmp || sudo mount /tmp
sudo mount -o remount /var/log || sudo mount /var/log

# Create necessary log directories
sudo mkdir -p /var/log/journal
sudo mkdir -p /var/log/nginx /var/log/apache2 /var/log/mysql
sudo chmod 755 /var/log

# --- Summary ---
echo "=== Swap and tmpfs configuration ==="
swapon --show
mount | grep tmpfs
free -h

echo "✅ ZRAM + SD swap + tmpfs setup complete."
echo "⚠️ /var/log and /tmp are ephemeral — reset on reboot."
