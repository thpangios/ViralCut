# Use Debian-based n8n image (NOT Alpine) to avoid musl build issues
FROM n8nio/n8n:latest-debian

# Switch to root to install packages
USER root

# Install FFmpeg, video processing tools, and build tools for native modules
RUN apt-get update && apt-get install -y \
    ffmpeg \
    curl \
    bash \
    coreutils \
    python3 \
    make \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create directories for video processing
RUN mkdir -p /tmp/videos /tmp/clips /tmp/processing && \
    chown -R node:node /tmp/videos /tmp/clips /tmp/processing

# Copy and setup our video processing script
COPY video-processor.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/video-processor.sh && \
    chown node:node /usr/local/bin/video-processor.sh

# Set the working directory
WORKDIR /usr/local/lib/node_modules/n8n

# Switch back to node user
USER node

# Expose n8n port
EXPOSE 5678
