# Use the actual available Debian-based n8n image
FROM n8nio/n8n:latest-debian

# Switch to root to install custom node
USER root

# Install Telepilot node in the correct location
RUN cd /usr/local/lib/node_modules/n8n && \
    npm install @telepilotco/n8n-nodes-telepilot

# Switch back to n8n user
USER node

# Start worker
CMD ["n8n", "worker"]
