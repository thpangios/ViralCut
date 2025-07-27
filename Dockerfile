# Use the latest n8n image as base
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install FFmpeg and video processing tools
RUN apt-get update && \
    apt-get install -y \
    ffmpeg \
    imagemagick \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create directories for video processing
RUN mkdir -p /tmp/videos /tmp/clips /tmp/processing
RUN chown -R node:node /tmp/videos /tmp/clips /tmp/processing

# Copy our custom video processing script
COPY video-processor.sh /usr/local/bin/video-processor.sh
RUN chmod +x /usr/local/bin/video-processor.sh
RUN chown node:node /usr/local/bin/video-processor.sh

# Switch back to node user
USER node

# Same entrypoint as original n8n
ENTRYPOINT ["tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
