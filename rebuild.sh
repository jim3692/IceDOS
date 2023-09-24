#!/bin/bash

# cd into script's folder
cd "$(cd "$(dirname "$0")" && pwd)" || exit
pwd > .configuration-location

# Copy "/etc/nixos/hardware-configuration.nix" to the project
[ -f "hardware-configuration.nix" ] && rm -f hardware-configuration.nix
cp /etc/nixos/hardware-configuration.nix ./

# Set to read-only as the user should update the original file
chmod 444 hardware-configuration.nix

# Fool flake to use untracked file
# Source: Development tricks - https://nixos.wiki/wiki/Flakes
git add --intent-to-add hardware-configuration.nix
git update-index --skip-worktree hardware-configuration.nix

# Build the configuration
sudo nixos-rebuild switch --flake .

# Delete the copied hardware-configuration.nix
rm -f hardware-configuration.nix
