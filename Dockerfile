FROM docker.io/n8nio/n8n:latest

USER root

# Install packages
RUN apk add --no-cache \
    ffmpeg \
    curl \
    bash \
    coreutils

# Create directories
RUN mkdir -p /tmp/videos /tmp/clips /tmp/processing && \
    chown -R node:node /tmp/videos /tmp/clips /tmp/processing

# Copy and setup script
COPY video-processor.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/video-processor.sh && \
    chown node:node /usr/local/bin/video-processor.sh

USER node

# Keep original entrypoint
ENTRYPOINT ["tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
