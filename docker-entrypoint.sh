#!/bin/sh

# Replace environment variables in Caddyfile if needed
# This allows for dynamic configuration

echo "🚀 Starting Homelab Caddy Server"
echo "📧 Email: ${CADDY_EMAIL:-admin@example.com}"
echo "🌐 Domain: ${DOMAIN:-example.com}"
echo "🔄 Redirect configuration loaded"

# Create log directory
mkdir -p /var/log/caddy

# Validate Caddyfile
echo "✅ Validating Caddyfile..."
caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile

if [ $? -eq 0 ]; then
    echo "✅ Caddyfile is valid"
else
    echo "❌ Caddyfile validation failed"
    exit 1
fi

# Execute the CMD
exec "$@"