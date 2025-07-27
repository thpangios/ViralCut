#!/bin/bash

# Viral Video Processor Script for n8n
set -e  # Exit on any error

INPUT_URL="$1"
START_TIME="$2" 
OUTPUT_FILE="$3"
EFFECTS_JSON="$4"

# Validate inputs
if [ -z "$INPUT_URL" ] || [ -z "$START_TIME" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "❌ Error: Missing required parameters"
    exit 1
fi

echo "🎬 Starting viral video processing..."
echo "📥 Input: $INPUT_URL"
echo "⏰ Start time: $START_TIME seconds"
echo "📤 Output: $OUTPUT_FILE"

# Create temp files
TEMP_INPUT="/tmp/processing/input_$(date +%s).mp4"

# Download input video
echo "📥 Downloading input video..."
curl -L -o "$TEMP_INPUT" "$INPUT_URL"

if [ ! -f "$TEMP_INPUT" ]; then
    echo "❌ Failed to download input video"
    exit 1
fi

# Parse effects from JSON (basic parsing)
TEXT_OVERLAY=$(echo "$EFFECTS_JSON" | grep -o '"text_overlay":"[^"]*"' | cut -d'"' -f4 || echo "VIRAL!")

echo "🎭 Text overlay: $TEXT_OVERLAY"

# Build FFmpeg filter chain for TikTok format + text
FILTER_CHAIN="scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:black"

# Add text overlay if present
if [ -n "$TEXT_OVERLAY" ] && [ "$TEXT_OVERLAY" != "null" ] && [ "$TEXT_OVERLAY" != "VIRAL MOMENT!" ]; then
    # Clean text for FFmpeg
    CLEAN_TEXT=$(echo "$TEXT_OVERLAY" | sed "s/'//g" | sed 's/"//g' | sed 's/!/ /g')
    FILTER_CHAIN="$FILTER_CHAIN,drawtext=text='$CLEAN_TEXT':x=(w-text_w)/2:y=(h-text_h)/2+200:fontsize=72:fontcolor=white:box=1:boxcolor=black@0.8:boxborderw=8"
    echo "✅ Added text overlay: $CLEAN_TEXT"
fi

# Process video with FFmpeg
echo "🚀 Processing video with FFmpeg..."

ffmpeg -y \
    -i "$TEMP_INPUT" \
    -ss "$START_TIME" \
    -t 8 \
    -vf "$FILTER_CHAIN" \
    -c:v libx264 \
    -c:a aac \
    -preset medium \
    -crf 20 \
    -pix_fmt yuv420p \
    -r 30 \
    -movflags +faststart \
    "$OUTPUT_FILE"

# Verify output
if [ -f "$OUTPUT_FILE" ]; then
    FILE_SIZE=$(stat -c%s "$OUTPUT_FILE" 2>/dev/null || echo "0")
    echo "✅ Video processing completed successfully!"
    echo "📏 Output file size: $((FILE_SIZE / 1024))KB"
    
    # Cleanup temp files
    rm -f "$TEMP_INPUT"
    
    exit 0
else
    echo "❌ Video processing failed - output file not created"
    rm -f "$TEMP_INPUT"
    exit 1
fi
