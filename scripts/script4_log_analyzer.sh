#!/bin/bash
# =============================================================
# Script 4: Log File Analyzer
# Course  : Open Source Software
# Project : The Open Source Audit — Git
# Purpose : Read a log file line by line, count occurrences of
#           a keyword, display last 5 matching lines, and retry
#           if the file is empty.
# Concepts: while read loop, if-then, counters, $1 arguments,
#           do-while style retry, tail + grep
# Usage   : ./script4_log_analyzer.sh /path/to/logfile [KEYWORD]
# Example : ./script4_log_analyzer.sh /var/log/syslog error
# =============================================================

# --- Accept command-line arguments ---
LOGFILE=$1              # First argument: path to log file
KEYWORD=${2:-"error"}   # Second argument: keyword to search (default: error)
COUNT=0                 # Counter for keyword matches
MAX_RETRIES=3           # Maximum retry attempts if file is empty
ATTEMPT=1               # Current retry attempt number

echo "============================================================"
echo "              LOG FILE ANALYZER                            "
echo "============================================================"

# --- Validate that a log file path was provided ---
if [ -z "$LOGFILE" ]; then
    echo "[ERROR] No log file specified."
    echo "Usage  : $0 /path/to/logfile [keyword]"
    echo "Example: $0 /var/log/syslog error"
    exit 1
fi

# --- Check if the file exists ---
if [ ! -f "$LOGFILE" ]; then
    echo "[ERROR] File not found: $LOGFILE"
    echo "        Please check the path and try again."
    exit 1
fi

echo "[INFO]  Log file  : $LOGFILE"
echo "[INFO]  Keyword   : '$KEYWORD'"
echo ""

# --- Do-while style retry loop if file is empty ---
# Bash has no native do-while, so we use a while loop with a break condition
while [ $ATTEMPT -le $MAX_RETRIES ]; do

    # Check if file has content (size greater than 0 bytes)
    if [ -s "$LOGFILE" ]; then
        echo "[OK]    File has content. Starting analysis..."
        break   # Exit retry loop and proceed with analysis
    else
        echo "[WARN]  Attempt $ATTEMPT/$MAX_RETRIES: File is empty: $LOGFILE"

        if [ $ATTEMPT -lt $MAX_RETRIES ]; then
            echo "        Waiting 2 seconds before retrying..."
            sleep 2
        else
            echo "[ERROR] File is still empty after $MAX_RETRIES attempts."
            echo "        Please ensure the log file contains data."
            exit 1
        fi
    fi

    # Increment attempt counter
    ATTEMPT=$((ATTEMPT + 1))

done

echo ""
echo "--- Scanning log file line by line ---"

# --- Read log file line by line and count keyword matches ---
# IFS= preserves leading/trailing whitespace in each line
# -r flag prevents backslash interpretation
while IFS= read -r LINE; do

    # Case-insensitive search using grep -iq
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))    # Increment match counter
    fi

done < "$LOGFILE"   # Redirect file into the while loop as input

echo ""
echo "--- Analysis Results ---"
echo "Keyword  : '$KEYWORD'"
echo "Found    : $COUNT time(s) in $LOGFILE"
echo ""

# --- Show last 5 matching lines for context ---
if [ $COUNT -gt 0 ]; then
    echo "--- Last 5 lines containing '$KEYWORD' ---"
    # Combine grep (filter) with tail (last N lines)
    grep -i "$KEYWORD" "$LOGFILE" | tail -5
else
    echo "[INFO]  No lines matched keyword '$KEYWORD' in this log file."
fi

echo ""
echo "--- Log File Summary ---"
# Count total lines in file using wc -l
TOTAL_LINES=$(wc -l < "$LOGFILE")
echo "Total lines in file : $TOTAL_LINES"
echo "Matching lines      : $COUNT"

# Calculate percentage if total lines > 0
if [ "$TOTAL_LINES" -gt 0 ]; then
    # Use awk for floating point percentage calculation
    PERCENT=$(awk "BEGIN {printf \"%.2f\", ($COUNT/$TOTAL_LINES)*100}")
    echo "Match percentage    : $PERCENT%"
fi

echo "============================================================"
