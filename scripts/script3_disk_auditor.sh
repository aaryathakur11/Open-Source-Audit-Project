#!/bin/bash
# =============================================================
# Script 3: Disk and Permission Auditor
# Course  : Open Source Software
# Project : The Open Source Audit — Git
# Purpose : Loop through key system directories, report their
#           disk usage and permissions. Also checks Git's config
#           directory specifically.
# Concepts: for loop, arrays, du, ls -ld, awk, cut, if-d test
# =============================================================

# --- List of important system directories to audit ---
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/share/doc")

echo "============================================================"
echo "         DISK AND PERMISSION AUDITOR                       "
echo "============================================================"
printf "%-20s %-25s %-10s\n" "Directory" "Permissions (type user group)" "Size"
echo "------------------------------------------------------------"

# --- Loop through each directory in the array ---
for DIR in "${DIRS[@]}"; do

    if [ -d "$DIR" ]; then
        # Extract permissions, owner user, and owner group using awk
        # ls -ld output: "drwxr-xr-x 2 root root 4096 ..."
        PERMS=$(ls -ld "$DIR" | awk '{print $1, $3, $4}')

        # Get human-readable size; suppress 'permission denied' errors
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        # Print formatted output using printf for alignment
        printf "%-20s %-25s %-10s\n" "$DIR" "$PERMS" "${SIZE:-N/A}"
    else
        # Directory does not exist on this system
        printf "%-20s %-35s\n" "$DIR" "[does not exist on this system]"
    fi

done

echo ""
echo "--- Git Configuration Directory Check ---"

# --- Check Git's specific config directory ---
# Git stores system-wide config in /etc/gitconfig
# and user config in ~/.gitconfig or ~/.config/git/

GIT_SYSTEM_CONFIG="/etc/gitconfig"
GIT_USER_CONFIG="$HOME/.gitconfig"
GIT_CONFIG_DIR="$HOME/.config/git"

# Check system-level git config file
if [ -f "$GIT_SYSTEM_CONFIG" ]; then
    PERMS=$(ls -l "$GIT_SYSTEM_CONFIG" | awk '{print $1, $3, $4}')
    echo "[FOUND] System Git config : $GIT_SYSTEM_CONFIG"
    echo "        Permissions       : $PERMS"
else
    echo "[INFO]  System Git config ($GIT_SYSTEM_CONFIG) not present."
fi

# Check user-level git config file
if [ -f "$GIT_USER_CONFIG" ]; then
    PERMS=$(ls -l "$GIT_USER_CONFIG" | awk '{print $1, $3, $4}')
    echo "[FOUND] User Git config   : $GIT_USER_CONFIG"
    echo "        Permissions       : $PERMS"
else
    echo "[INFO]  User Git config (~/.gitconfig) not found."
    echo "        Run: git config --global user.name 'Your Name' to create it."
fi

# Check git config directory (XDG standard)
if [ -d "$GIT_CONFIG_DIR" ]; then
    PERMS=$(ls -ld "$GIT_CONFIG_DIR" | awk '{print $1, $3, $4}')
    SIZE=$(du -sh "$GIT_CONFIG_DIR" 2>/dev/null | cut -f1)
    echo "[FOUND] Git config dir    : $GIT_CONFIG_DIR"
    echo "        Permissions       : $PERMS | Size: $SIZE"
else
    echo "[INFO]  Git XDG config dir (~/.config/git) not found."
fi

echo ""
echo "--- Git Binary Location ---"
# Find where git is installed
if which git &>/dev/null; then
    GIT_BIN=$(which git)
    PERMS=$(ls -l "$GIT_BIN" | awk '{print $1, $3, $4}')
    echo "[FOUND] Git binary        : $GIT_BIN"
    echo "        Permissions       : $PERMS"
    echo "        Version           : $(git --version)"
else
    echo "[WARN]  Git binary not found in PATH."
fi

echo "============================================================"
