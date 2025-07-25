# Start with the n8n image you're already using
FROM docker.n8n.io/n8nio/n8n:1.102.3

# Switch to root to install stuff
USER root

# Install FFmpeg (Alpine Linux uses apk, not apt-get)
RUN apk add --no-cache \
    ffmpeg \
    python3 \
    make \
    g++

# Install Remotion and video processing tools
RUN npm install -g \
    remotion \
    @remotion/renderer \
    @remotion/cli

# Create folder for our video templates
RUN mkdir -p /home/node/remotion-templates
COPY remotion-templates/ /home/node/remotion-templates/

# Build the Remotion bundle
WORKDIR /home/node/remotion-templates
RUN npm install
RUN npm run build

# Switch back to original working directory
WORKDIR /usr/local/lib/node_modules/n8n

# Switch back to node user
USER node

# Same ports as before
EXPOSE 5678
