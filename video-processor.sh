#!/bin/bash

echo "🎬 Video processor script loaded successfully"

# Simple validation
if [ $# -lt 3 ]; then
    echo "❌ Error: Need at least 3 parameters"
    echo "Usage: video-processor.sh <input_url> <start_time> <output_file> [effects_json]"
    exit 1
fi

INPUT_URL="$1"
START_TIME="$2"
OUTPUT_FILE="$3"
EFFECTS_JSON="${4:-{}}"

echo "📥 Input URL: $INPUT_URL"
echo "⏰ Start time: $START_TIME"
echo "📤 Output: $OUTPUT_FILE"

# Create output directory
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Simple test: Create a basic 8-second clip
echo "🚀 Creating 8-second clip..."

ffmpeg -y \
    -i "$INPUT_URL" \
    -ss "$START_TIME" \
    -t 8 \
    -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:black" \
    -c:v libx264 \
    -c:a aac \
    -preset ultrafast \
    -crf 23 \
    -pix_fmt yuv420p \
    -r 30 \
    -movflags +faststart \
    "$OUTPUT_FILE"

if [ -f "$OUTPUT_FILE" ]; then
    echo "✅ Video created successfully!"
    ls -la "$OUTPUT_FILE"
else
    echo "❌ Failed to create video"
    exit 1
fi
