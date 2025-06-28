#!/bin/bash
set -euo pipefail

# Caddy Proxy Health Check Script
# Run this periodically to ensure the service is healthy

COMPOSE_DIR="/home/cbshort/repo/caddy-proxy"
LOG_FILE="/var/log/caddy-proxy-health.log"
DISCORD_WEBHOOK="${DISCORD_WEBHOOK:-}"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

check_container() {
    if docker compose -f "$COMPOSE_DIR/docker-compose.yml" ps caddy | grep -q "Up"; then
        return 0
    else
        return 1
    fi
}

check_http() {
    if curl -sf http://localhost:9080 > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

check_https() {
    if curl -sfk https://localhost:9443 > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

send_alert() {
    local message="$1"
    log "ALERT: $message"
    
    if [[ -n "$DISCORD_WEBHOOK" ]]; then
        curl -H "Content-Type: application/json" \
             -X POST \
             -d "{\"content\": \"🚨 Caddy Proxy Alert: $message\"}" \
             "$DISCORD_WEBHOOK" || log "Failed to send Discord alert"
    fi
}

main() {
    log "Starting health check..."
    
    if ! check_container; then
        send_alert "Container is not running"
        log "Attempting to restart..."
        cd "$COMPOSE_DIR"
        docker compose up -d || send_alert "Failed to restart container"
        exit 1
    fi
    
    if ! check_http; then
        send_alert "HTTP endpoint not responding"
        exit 1
    fi
    
    if ! check_https; then
        send_alert "HTTPS endpoint not responding" 
        exit 1
    fi
    
    log "All checks passed ✅"
}

main "$@"
