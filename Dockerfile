# Use the SAME base image that was working
FROM docker.n8n.io/n8nio/n8n:1.106.0

# Switch to root to install packages
USER root

# Install FFmpeg and video processing tools (same as your working version)
RUN apk add --no-cache \
    ffmpeg \
    curl \
    bash \
    coreutils

# Create directories for video processing
RUN mkdir -p /tmp/videos /tmp/clips /tmp/processing && \
    chown -R node:node /tmp/videos /tmp/clips /tmp/processing

# Copy and setup our video processing script
COPY video-processor.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/video-processor.sh && \
    chown node:node /usr/local/bin/video-processor.sh

# Set the working directory (CRITICAL - this was missing!)
WORKDIR /usr/local/lib/node_modules/n8n

# Switch back to node user
USER node

# Expose the port (same as your working version)
EXPOSE 5678

# DON'T override ENTRYPOINT - let n8n handle its own startup
# (Your working version didn't override this)
