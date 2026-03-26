#!/bin/bash
# =============================================================
# Script 5: Open Source Manifesto Generator
# Course  : Open Source Software
# Project : The Open Source Audit — Git
# Purpose : Interactively ask the user 3 questions and generate
#           a personalised open-source philosophy statement,
#           saved to a .txt file.
# Concepts: read for input, string concatenation, writing to
#           file with >, date command, aliases (demonstrated
#           in comments as a concept explanation)
# =============================================================

# --- Alias concept demonstration ---
# In Linux, aliases let you create shortcuts for commands.
# For example: alias today='date +%d-%m-%Y'
# Below we use the date command directly, but this is what
# an alias would simplify if added to your ~/.bashrc

# --- Generate output filename using current username ---
OUTPUT="manifesto_$(whoami).txt"
DATE=$(date '+%d %B %Y')
TIME=$(date '+%H:%M:%S')

echo "============================================================"
echo "        OPEN SOURCE MANIFESTO GENERATOR                    "
echo "============================================================"
echo ""
echo "Answer three questions and your personal open-source"
echo "philosophy statement will be generated and saved to a file."
echo ""

# --- Question 1: daily open-source tool ---
# read -p prints a prompt and waits for user input
read -p "1. Name one open-source tool you use every day: " TOOL

# --- Validate input is not empty ---
while [ -z "$TOOL" ]; do
    echo "   [Please enter a value]"
    read -p "1. Name one open-source tool you use every day: " TOOL
done

# --- Question 2: what freedom means ---
read -p "2. In one word, what does 'freedom' mean to you in software? " FREEDOM

while [ -z "$FREEDOM" ]; do
    echo "   [Please enter a value]"
    read -p "2. In one word, what does 'freedom' mean to you in software? " FREEDOM
done

# --- Question 3: something they would build and share ---
read -p "3. Name one thing you would build and share freely with the world: " BUILD

while [ -z "$BUILD" ]; do
    echo "   [Please enter a value]"
    read -p "3. Name one thing you would build and share freely with the world: " BUILD
done

echo ""
echo "--- Generating your manifesto... ---"
echo ""

# --- Compose the manifesto paragraph using string concatenation ---
# We build the manifesto line by line and write to the file using >
# Subsequent lines use >> to append without overwriting

# Write the header to the file (> creates/overwrites the file)
echo "============================================================" > "$OUTPUT"
echo "           MY OPEN SOURCE MANIFESTO                        " >> "$OUTPUT"
echo "       Generated on $DATE at $TIME                         " >> "$OUTPUT"
echo "============================================================" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Write the manifesto body — composed using the user's three answers
echo "I believe in the power of open source." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "Every day, I rely on $TOOL — a tool built not for profit," >> "$OUTPUT"
echo "but for the common good of every person who needs it." >> "$OUTPUT"
echo "It was made by people who understood that $FREEDOM" >> "$OUTPUT"
echo "is not just a feature — it is a right that software should protect." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "The open-source movement teaches us that knowledge grows fastest" >> "$OUTPUT"
echo "when it is shared, not hoarded. Code shared freely becomes the" >> "$OUTPUT"
echo "foundation on which others build things we cannot yet imagine." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "One day, I will build $BUILD — and I will share it freely," >> "$OUTPUT"
echo "because I understand that the best software is not owned," >> "$OUTPUT"
echo "it is given. Standing on the shoulders of those who came before me," >> "$OUTPUT"
echo "I will contribute to the commons that made my own learning possible." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "This is not just a philosophy. It is a responsibility." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "— $(whoami) | $DATE" >> "$OUTPUT"
echo "============================================================" >> "$OUTPUT"

# --- Confirm the file was saved ---
echo "[OK]  Manifesto saved to: $OUTPUT"
echo ""

# --- Display the manifesto on screen using cat ---
echo "--- Your Manifesto ---"
cat "$OUTPUT"

echo ""
echo "============================================================"
echo " File saved as: $OUTPUT"
echo " You can view it anytime with: cat $OUTPUT"
echo "============================================================"
