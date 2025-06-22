FROM caddy:2.7-alpine

# Create necessary directories

RUN mkdir -p /var/log/caddy

# Copy configuration files

COPY Caddyfile /etc/caddy/Caddyfile
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Make entrypoint executable

RUN chmod +x /docker-entrypoint.sh

# Create caddy user directories

RUN mkdir -p /data /config

# Ensure caddy user/group exists

RUN addgroup --system caddy && adduser --system --ingroup caddy caddy

# Set proper ownership

RUN chown -R caddy:caddy /data /config /var/log/caddy

# Switch to caddy user

USER caddy

# Expose ports

EXPOSE 80 443

# Use custom entrypoint

ENTRYPOINT [”/docker-entrypoint.sh”]
CMD [“caddy”, “run”, “–config”, “/etc/caddy/Caddyfile”, “–adapter”, “caddyfile”]
