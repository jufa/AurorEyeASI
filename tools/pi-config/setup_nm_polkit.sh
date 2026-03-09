#!/bin/bash
# setup_nm_polkit.sh
# Usage: ./setup_nm_polkit.sh [username]

# Determine the user
USER_TO_USE="${1:-$(whoami)}"

echo "Setting up NetworkManager + polkit rules for user: $USER_TO_USE"

# --------------------------
# Step 1: Polkit rule for AP sharing
# --------------------------
POLKIT_FILE="/etc/polkit-1/rules.d/50-nm-ap.rules"
echo "Creating polkit rule at $POLKIT_FILE ..."
sudo tee "$POLKIT_FILE" > /dev/null <<EOL
polkit.addRule(function(action, subject) {
    if ((action.id == "org.freedesktop.NetworkManager.settings.modify.system" ||
         action.id == "org.freedesktop.NetworkManager.network-control") &&
        subject.user == "$USER_TO_USE") {
        return polkit.Result.YES;
    }

    if (action.id == "org.freedesktop.NetworkManager.settings.modify.own" &&
        subject.user == "$USER_TO_USE") {
        return polkit.Result.YES;
    }
});
EOL

# --------------------------
# Step 2: NetworkManager rule for Wi-Fi scans / network modifications
# --------------------------
NM_RULE_FILE="/etc/polkit-1/localauthority/50-local.d/10-nm-user.pkla"
echo "Creating NetworkManager local authority rule at $NM_RULE_FILE ..."
sudo tee "$NM_RULE_FILE" > /dev/null <<EOL
[Allow user $USER_TO_USE Wi-Fi management]
Identity=unix-user:$USER_TO_USE
Action=org.freedesktop.NetworkManager.settings.modify.system;org.freedesktop.NetworkManager.network-control;org.freedesktop.NetworkManager.wifi.scan
ResultAny=yes
ResultInactive=yes
ResultActive=yes
EOL

# --------------------------
# Step 3: Restart polkit and NetworkManager
# --------------------------
echo "Restarting polkit and NetworkManager to apply changes..."
sudo systemctl restart polkit
sudo systemctl restart NetworkManager

echo "Done. User '$USER_TO_USE' should now be authorized to manage Wi-Fi, perform scans, and share connections via AP."
