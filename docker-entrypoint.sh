#!/bin/sh
set -e

# Security: Ensure script runs with proper permissions
if [ "$(id -u)" = "0" ]; then
    echo "❌ Script should not run as root"
    exit 1
fi

# Replace environment variables in Caddyfile if needed
# This allows for dynamic configuration

echo "🚀 Starting Homelab Caddy Server"
echo "📧 Email: ${CADDY_EMAIL:-admin@example.com}"
echo "🌐 Domain: ${DOMAIN:-example.com}"
echo "🔄 Redirect configuration loaded"
echo "🕒 Timezone: ${TZ:-UTC}"

# Create log directory with proper permissions
mkdir -p /var/log/caddy
chmod 755 /var/log/caddy

# Validate Caddyfile syntax
echo "✅ Validating Caddyfile..."
if caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile; then
    echo "✅ Caddyfile is valid"
else
    echo "❌ Caddyfile validation failed"
    exit 1
fi

# Format Caddyfile for better readability in logs
echo "📋 Caddyfile structure:"
caddy fmt --config /etc/caddy/Caddyfile --adapter caddyfile --diff || true

# Execute the CMD
exec "$@"