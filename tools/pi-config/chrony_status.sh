#!/usr/bin/env bash

echo "=== Time & Clock Status (Raspberry Pi) ==="
echo

# ----------------------------
# System time
# ----------------------------
echo "[System time]"
date
echo

# ----------------------------
# Chrony service
# ----------------------------
echo "[Chrony service]"
if systemctl is-active --quiet chrony; then
  echo "chrony: active"
else
  echo "chrony: INACTIVE"
fi
echo

# ----------------------------
# Chrony tracking
# ----------------------------
echo "[Chrony tracking]"
if command -v chronyc >/dev/null 2>&1; then
  chronyc tracking
else
  echo "chronyc not installed"
fi
echo

# ----------------------------
# Chrony sources
# ----------------------------
echo "[Chrony sources]"
if command -v chronyc >/dev/null 2>&1; then
  chronyc sources -v
else
  echo "chronyc not installed"
fi
echo

# ----------------------------
# Active reference summary
# ----------------------------
echo "[Active reference]"
if command -v chronyc >/dev/null 2>&1; then
  REF=$(chronyc tracking 2>/dev/null | awk -F': ' '/Reference ID/ {print $2}')
  if [[ -n "$REF" ]]; then
    echo "Current reference: $REF"
  else
    echo "No reference selected"
  fi
else
  echo "chronyc not available"
fi
echo

# ----------------------------
# GPS daemon status
# ----------------------------
echo "[GPSD status]"
if systemctl is-active --quiet gpsd; then
  echo "gpsd: active"
else
  echo "gpsd: INACTIVE"
fi
echo

# ----------------------------
# GPS fix status (via gpspipe)
# ----------------------------
echo "[GPS fix]"
if command -v gpspipe >/dev/null 2>&1; then
  FIX=$(gpspipe -w -n 10 2>/dev/null | grep -m1 '"mode":' | sed 's/.*"mode":\([0-9]\).*/\1/')
  case "$FIX" in
    3) echo "GPS fix: 3D" ;;
    2) echo "GPS fix: 2D" ;;
    1) echo "GPS fix: NO FIX" ;;
    *) echo "GPS fix: unknown" ;;
  esac
else
  echo "gpspipe not available"
fi
echo

# ----------------------------
# Serial device presence
# ----------------------------
echo "[GPS serial device]"
if [[ -e /dev/serial0 ]]; then
  ls -l /dev/serial0
else
  echo "/dev/serial0 not present"
fi
echo

# ----------------------------
# NTP reachability (best-effort)
# ----------------------------
echo "[Network time reachability]"
if ping -c1 -W1 pool.ntp.org >/dev/null 2>&1; then
  echo "NTP network reachable"
else
  echo "NTP network NOT reachable"
fi
echo

echo "=== End status ==="
