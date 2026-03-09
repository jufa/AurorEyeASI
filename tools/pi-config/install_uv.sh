#!/bin/bash


set -e

echo "Update adn Upgrade APT package manifests? (y/n)"
read yn
if [ "$yn" == "y" ]; then 
  sudo apt update
  sudo apt full-upgrade -y
fi

echo "Installing uv dependency manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh
echo "Installed. Version information:"
uv --version


