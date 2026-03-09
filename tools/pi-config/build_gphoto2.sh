#!/bin/bash
# Safe builder for libgphoto2 + gphoto2 from Git SHAs on Raspberry Pi
# Author: CHATGPT5 2025-October
# Usage:
#   ./build_gphoto_from_sha.sh [<LIBGPHOTO2_SHA> [<GPHOTO2_SHA>]]
#
# If SHAs are not provided, the latest commits from GitHub are used.

set -e

# ---------------- CONFIG ----------------
PREFIX="$HOME/libgphoto2"
LOGFILE="$HOME/gphoto_build.log"
LIB_REPO="https://github.com/gphoto/libgphoto2.git"
GPHOTO_REPO="https://github.com/gphoto/gphoto2.git"

LIB_SHA="$1"
GPHOTO_SHA="$2"

# ---------------- FETCH LATEST IF EMPTY ----------------
if [ -z "$LIB_SHA" ]; then
  echo "[INFO] No libgphoto2 SHA specified — fetching latest..."
  LIB_SHA=$(git ls-remote "$LIB_REPO" HEAD | awk '{print $1}')
fi

if [ -z "$GPHOTO_SHA" ]; then
  echo "[INFO] No gphoto2 SHA specified — fetching latest..."
  GPHOTO_SHA=$(git ls-remote "$GPHOTO_REPO" HEAD | awk '{print $1}')
fi

echo "--------------------------------------------------"
echo "Building libgphoto2 @ $LIB_SHA"
echo "Building gphoto2   @ $GPHOTO_SHA"
echo "Installation prefix: $PREFIX"
echo "Logging to: $LOGFILE"
echo "--------------------------------------------------"
sleep 2

mkdir -p "$PREFIX"
touch "$LOGFILE"

# ---------------- CHECK CURRENT INSTALL ----------------
INSTALLED_PATH="$PREFIX/build_info.txt"
if [ -f "$INSTALLED_PATH" ]; then
  CURRENT_LIB_SHA=$(grep "libgphoto2" "$INSTALLED_PATH" | awk '{print $2}')
  CURRENT_GPHOTO_SHA=$(grep "gphoto2" "$INSTALLED_PATH" | awk '{print $2}')
else
  CURRENT_LIB_SHA=""
  CURRENT_GPHOTO_SHA=""
fi

if [ "$LIB_SHA" = "$CURRENT_LIB_SHA" ] && [ "$GPHOTO_SHA" = "$CURRENT_GPHOTO_SHA" ]; then
  echo "[INFO] Installed SHAs already match ($LIB_SHA / $GPHOTO_SHA). Skipping rebuild."
  exit 0
fi

# ---------------- CLEAN AND CLONE ----------------
cd "$HOME"
rm -rf libgphoto2-src gphoto2-src

echo "[INFO] Cloning libgphoto2..."
git clone "$LIB_REPO" libgphoto2-src >> "$LOGFILE" 2>&1
cd libgphoto2-src
git checkout "$LIB_SHA" >> "$LOGFILE" 2>&1

echo "[BUILD] Building libgphoto2..."
autoreconf -is >> "$LOGFILE" 2>&1
./configure --prefix="$PREFIX" >> "$LOGFILE" 2>&1
make -j$(nproc) >> "$LOGFILE" 2>&1
make install >> "$LOGFILE" 2>&1

echo "[SUCCESS] libgphoto2 installed."

# ---------------- BUILD gphoto2 ----------------
cd "$HOME"
echo "[INFO] Cloning gphoto2..."
git clone "$GPHOTO_REPO" gphoto2-src >> "$LOGFILE" 2>&1
cd gphoto2-src
git checkout "$GPHOTO_SHA" >> "$LOGFILE" 2>&1

echo "[BUILD] Building gphoto2..."
autoreconf -is >> "$LOGFILE" 2>&1
./configure --prefix="$PREFIX" PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig" >> "$LOGFILE" 2>&1
make -j$(nproc) >> "$LOGFILE" 2>&1
make install >> "$LOGFILE" 2>&1

# ---------------- UPDATE ENVIRONMENT ----------------
if ! grep -q "$PREFIX/bin" ~/.bashrc; then
  echo "export PATH=\"$PREFIX/bin:\$PATH\"" >> ~/.bashrc
  echo "export LD_LIBRARY_PATH=\"$PREFIX/lib:\$LD_LIBRARY_PATH\"" >> ~/.bashrc
fi

export PATH="$PREFIX/bin:$PATH"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"

# ---------------- RECORD BUILD INFO ----------------
echo "libgphoto2 $LIB_SHA" > "$INSTALLED_PATH"
echo "gphoto2 $GPHOTO_SHA" >> "$INSTALLED_PATH"

# ---------------- VERIFY ----------------
echo "[VERIFY] Checking new install..."
if gphoto2 --version >/dev/null 2>&1; then
  echo "--------------------------------------------------"
  gphoto2 --version
  echo "--------------------------------------------------"
  echo "[SUCCESS] gphoto2/libgphoto2 installed and linked to:"
  echo "  $PREFIX"
else
  echo "[ERROR] gphoto2 failed to run correctly. Check $LOGFILE."
  exit 1
fi
