#!/bin/bash
set -euo pipefail

# Caddy Configuration Backup Script
# Backs up Caddy configuration and certificates

BACKUP_DIR="/home/cbshort/Container/caddy-proxy/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="caddy-backup-$DATE.tar.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create backup
tar -czf "$BACKUP_DIR/$BACKUP_FILE" \
    -C /home/cbshort/repo/caddy-proxy Caddyfile docker-entrypoint.sh \
    -C /home/cbshort/Container/caddy-proxy data config

echo "Backup created: $BACKUP_DIR/$BACKUP_FILE"

# Keep only last 30 days of backups
find "$BACKUP_DIR" -name "caddy-backup-*.tar.gz" -mtime +30 -delete

echo "Old backups cleaned up"
