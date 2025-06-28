FROM caddy:2-alpine

# Set metadata
LABEL maintainer="chrisshort@duck.com"
LABEL description="Production-ready Caddy proxy for homelab services"
LABEL version="1.1"

# Security: Update packages and remove unnecessary ones
RUN apk upgrade --no-cache && \
    apk add --no-cache ca-certificates tzdata && \
    rm -rf /var/cache/apk/*

# Create necessary directories with proper permissions
RUN mkdir -p /var/log/caddy /data /config && \
    chown -R caddy:caddy /var/log/caddy /data /config

# Copy configuration files with proper ownership
COPY --chown=caddy:caddy Caddyfile /etc/caddy/Caddyfile
COPY --chown=caddy:caddy docker-entrypoint.sh /docker-entrypoint.sh

# Make entrypoint executable
RUN chmod +x /docker-entrypoint.sh

# Security: Use non-root user from the start
USER caddy

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD caddy version || exit 1

# Expose ports
EXPOSE 80 443

# Use custom entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
