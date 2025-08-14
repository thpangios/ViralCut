# Use official n8n latest with TelePilot support
FROM n8nio/n8n:latest

# Install TelePilot using official method
RUN cd ~/.n8n/ && mkdir -p nodes && cd nodes && npm install @telepilotco/n8n-nodes-telepilot

# Verify installation
RUN ls -la ~/.n8n/nodes/

# Set environment for Railway
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_WORKERS_ENABLED=false

# Use default entrypoint
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
