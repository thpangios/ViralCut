# Start with the n8n image you're already using
FROM docker.n8n.io/n8nio/n8n:1.102.3

# Switch to root to install stuff
USER root

# Install FFmpeg (needed for video processing)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Install Remotion and video processing tools
RUN npm install -g \
    remotion \
    @remotion/renderer \
    @remotion/cli

# Create folder for our video templates
RUN mkdir -p /home/node/remotion-templates
COPY remotion-templates/ /home/node/remotion-templates/

# Switch back to node user
USER node

# Same ports as before
EXPOSE 5678
