#!/bin/bash
# =============================================================
# Script 1: System Identity Report
# Course  : Open Source Software
# Project : The Open Source Audit — Git
# Purpose : Display a welcome screen with key system info
#           and identify the open-source license of the OS.
# Concepts: variables, echo, command substitution $(), formatting
# =============================================================

# --- Student details (fill before submission) ---
STUDENT_NAME="Aarya Yasholaxmi Thakur"
ROLL_NUMBER="24bce10871"
SOFTWARE_CHOICE="Git"

# --- Gather system information using command substitution ---
KERNEL=$(uname -r)                          # Linux kernel version
DISTRO=$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')  # Distro name
USER_NAME=$(whoami)                         # Currently logged-in user
HOME_DIR=$HOME                              # Home directory of current user
UPTIME=$(uptime -p)                         # Human-readable uptime
CURRENT_DATE=$(date '+%A, %d %B %Y')        # Day, date, month, year
CURRENT_TIME=$(date '+%H:%M:%S')            # Current time in HH:MM:SS

# --- OS License note ---
# Linux (and most GNU/Linux distros) are licensed under GPL v2/v3
OS_LICENSE="GNU General Public License version 2 (GPL v2)"

# --- Display the identity report ---
echo "============================================================"
echo "       OPEN SOURCE AUDIT — SYSTEM IDENTITY REPORT          "
echo "============================================================"
echo " Student      : $STUDENT_NAME ($ROLL_NUMBER)"
echo " Software     : $SOFTWARE_CHOICE"
echo "------------------------------------------------------------"
echo " Distribution : $DISTRO"
echo " Kernel Ver   : $KERNEL"
echo " Logged In As : $USER_NAME"
echo " Home Dir     : $HOME_DIR"
echo " System Up    : $UPTIME"
echo " Date         : $CURRENT_DATE"
echo " Time         : $CURRENT_TIME"
echo "------------------------------------------------------------"
echo " OS License   : $OS_LICENSE"
echo " Note         : The Linux kernel is free software — you    "
echo "                have the freedom to run, study, share, and "
echo "                modify it under the terms of the GPL v2.   "
echo "============================================================"
