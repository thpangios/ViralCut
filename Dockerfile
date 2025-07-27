# Use the official n8n base image
FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install FFmpeg and tools
RUN apk add --no-cache ffmpeg imagemagick curl wget bash \
    && mkdir -p /tmp/videos /tmp/clips /tmp/processing \
    && chown -R node:node /tmp/videos /tmp/clips /tmp/processing

# Copy your custom video processor
COPY video-processor.sh /usr/local/bin/video-processor.sh
RUN chmod +x /usr/local/bin/video-processor.sh \
    && chown node:node /usr/local/bin/video-processor.sh

# Switch back to node
USER node

# Keep original n8n entrypoint and command
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["n8n"]
