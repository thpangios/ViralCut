# Use OFFICIAL Debian-based n8n image from GHCR
FROM ghcr.io/n8n-io/n8n:latest-debian

# Switch to root to install build tools
USER root

# Install essential build tools for native modules (should work with current repos)
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    git \
    && rm -rf /var/lib/apt/lists/*

# Switch back to node user
USER node

# Expose n8n port
EXPOSE 5678
