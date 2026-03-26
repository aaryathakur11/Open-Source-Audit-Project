#!/bin/bash
# =============================================================
# Script 2: FOSS Package Inspector
# Course  : Open Source Software
# Project : The Open Source Audit — Git
# Purpose : Check if a FOSS package is installed, display its
#           version and license, and print a philosophy note.
# Concepts: if-then-else, case statement, rpm/dpkg, pipe+grep
# =============================================================

# --- Target package for this audit ---
PACKAGE="git"

echo "============================================================"
echo "          FOSS PACKAGE INSPECTOR — $PACKAGE                "
echo "============================================================"

# --- Detect package manager and check installation ---
# Different distros use different package managers (rpm vs dpkg)
if command -v rpm &>/dev/null; then
    # RPM-based system (RHEL, Fedora, CentOS)
    if rpm -q "$PACKAGE" &>/dev/null; then
        echo "[INFO] Package '$PACKAGE' is INSTALLED (RPM system)."
        echo ""
        echo "--- Package Details ---"
        # Use grep with -E to extract key fields from rpm info
        rpm -qi "$PACKAGE" | grep -E 'Name|Version|License|Summary|URL'
    else
        echo "[WARN] Package '$PACKAGE' is NOT installed on this RPM system."
        echo "       Install with: sudo dnf install $PACKAGE"
    fi

elif command -v dpkg &>/dev/null; then
    # Debian-based system (Ubuntu, Debian, Mint)
    if dpkg -l "$PACKAGE" 2>/dev/null | grep -q "^ii"; then
        echo "[INFO] Package '$PACKAGE' is INSTALLED (Debian system)."
        echo ""
        echo "--- Package Details ---"
        # dpkg -s gives full package status info
        dpkg -s "$PACKAGE" | grep -E 'Package|Version|License|Description'
    else
        echo "[WARN] Package '$PACKAGE' is NOT installed on this Debian system."
        echo "       Install with: sudo apt install $PACKAGE"
    fi

else
    # Fallback: try 'which' to see if the binary exists in PATH
    if which "$PACKAGE" &>/dev/null; then
        echo "[INFO] '$PACKAGE' binary found at: $(which $PACKAGE)"
        # Show version directly from the tool itself
        "$PACKAGE" --version 2>/dev/null || echo "Version info unavailable"
    else
        echo "[WARN] Cannot determine if '$PACKAGE' is installed."
        echo "       No supported package manager (rpm/dpkg) found."
    fi
fi

echo ""
echo "--- Open Source Philosophy Note ---"

# --- Case statement: philosophy note based on package name ---
# This maps well-known FOSS packages to their philosophical significance
case "$PACKAGE" in
    git)
        echo "Git: Born from necessity — Linus Torvalds built Git in 2005"
        echo "     after BitKeeper revoked its free license for the Linux kernel."
        echo "     It proved that open-source tools could outperform proprietary ones."
        ;;
    httpd | apache2)
        echo "Apache: The web server that democratised the internet."
        echo "        Freely available to all, it powers a third of all websites globally."
        ;;
    mysql | mariadb)
        echo "MySQL: A dual-license story — open source at its core, yet"
        echo "       commercially licensed too. Forked into MariaDB when the"
        echo "       community feared Oracle would restrict its freedom."
        ;;
    firefox)
        echo "Firefox: A nonprofit's fight for an open web."
        echo "         Mozilla released it to prevent a single company"
        echo "         from controlling how the world browses the internet."
        ;;
    python3 | python)
        echo "Python: Shaped entirely by community consensus."
        echo "        The PSF license ensures it stays free and accessible"
        echo "        to every learner, researcher, and developer on earth."
        ;;
    vlc)
        echo "VLC: Built by students in Paris who just wanted to watch videos"
        echo "     over their university network. It now plays virtually any"
        echo "     format — freely, without asking permission."
        ;;
    *)
        echo "$PACKAGE: An open-source tool contributing to the shared"
        echo "          commons of software that powers the modern world."
        ;;
esac

echo "============================================================"
