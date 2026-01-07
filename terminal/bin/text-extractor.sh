#!/bin/bash

# Temp file for screenshot
TEMP_SCREENSHOT="/tmp/ocr-screenshot.png"
TEMP_CLEAN="/tmp/ocr-cleaned.png"

# Cleanup previous files
rm -f "$TEMP_SCREENSHOT" "$TEMP_CLEAN"

# Capture screenshot using Spectacle
spectacle -b -r -n 0 -o "$TEMP_SCREENSHOT"

# Wait for screenshot (max 5 seconds)
for ((i=0; i<10; i++)); do
    [ -f "$TEMP_SCREENSHOT" ] && break
    sleep 0.5
done

# Verify screenshot was captured
if [ ! -f "$TEMP_SCREENSHOT" ] || [ ! -s "$TEMP_SCREENSHOT" ]; then
    notify-send "OCR Failed" "No screenshot was captured" -u critical
    exit 1
fi

# Clean the image for better OCR
if ! convert "$TEMP_SCREENSHOT" -colorspace Gray -contrast-stretch 1% -sharpen 0x1 "$TEMP_CLEAN" 2>/dev/null; then
    # Fallback to original if conversion fails
    cp "$TEMP_SCREENSHOT" "$TEMP_CLEAN"
fi

# Run OCR and capture both stdout and stderr
OCR_OUTPUT=$(tesseract "$TEMP_CLEAN" stdout --psm 6 --oem 3 2>&1)
OCR_STATUS=$?

# Check if OCR succeeded
if [ $OCR_STATUS -ne 0 ] || [ -z "$OCR_OUTPUT" ]; then
    notify-send "OCR Failed" "Could not extract text\n$OCR_OUTPUT" -u critical
    exit 1
fi

# Copy to clipboard
qdbus org.kde.klipper /klipper setClipboardContents "$OCR_OUTPUT" 2>/dev/null || echo -n "$OCR_OUTPUT" | wl-copy 2>/dev/null || echo -n "$OCR_OUTPUT" | xclip -selection clipboard

# Small delay to ensure Klipper registers the text
sleep 0.5

# Success notification
notify-send "OCR Successful" "Text copied to clipboard:\n${OCR_OUTPUT:0:40}..." -t 5000

# Cleanup
rm -f "$TEMP_SCREENSHOT" "$TEMP_CLEAN"