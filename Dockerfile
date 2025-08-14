# Use Node.js Debian image (glibc compatible)
FROM node:20-bullseye

# Set environment variables
ENV N8N_VERSION=latest
ENV NODE_ENV=production

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libc6-dev \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Create n8n user
RUN useradd --create-home --shell /bin/bash node

# Install n8n globally
RUN npm install -g n8n@latest

# Switch to node user
USER node
WORKDIR /home/node

# Install TelePilot node in global n8n
USER root
RUN npm install -g @telepilotco/n8n-nodes-telepilot

# Create n8n directory
RUN mkdir -p /home/node/.n8n
RUN chown -R node:node /home/node/.n8n

# Switch back to node user
USER node

# Expose port
EXPOSE 5678

# Environment variables for Railway
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_WORKERS_ENABLED=false

# Start n8n (single container mode - no Redis needed)
CMD ["n8n"]
