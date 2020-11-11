#!/bin/bash

# Creating archive of DSYM folder using zip

DSYM_FILE_NAME="MyBMW"
DSYM_ZIP_PATH="/tmp/$(date +%s)_${DSYM_FILE_NAME}.txt"

echo "Adding first line" > "$DSYM_ZIP_PATH"
echo "Adding first line replaced" > "$DSYM_ZIP_PATH"
echo "Appending second line " >> "$DSYM_ZIP_PATH"
echo "Appending third line" >> "$DSYM_ZIP_PATH"

echo "$DSYM_ZIP_PATH"

cat "$DSYM_ZIP_PATH"