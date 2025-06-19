Homelab Caddy Container

A production-ready Caddy configuration inspired by Chris Short's homelab setup. This container handles multiple domains with automatic HTTPS, security headers, and reverse proxying to homelab services.

## Features

### 🔀 Smart Redirects
- **Social media shortcuts** - `blue.domain.com` → Bluesky, `purple.domain.com` → Mastodon
- **Professional links** - `meet.domain.com` → Calendly, `resume.domain.com` → Resume
- **Legacy domain consolidation** - Multiple old domains → main site
- **Newsletter redirects** - `devopsnewsletters.com` → DevOps news page

### 🏠 Homelab Integration
- **Uptime monitoring** - Status pages and health checks
- **Reverse proxy** - Internal services exposed securely
- **Service discovery** - Easy addition of new services

### 🔒 Security & Performance
- **Automatic HTTPS** - Let's Encrypt certificates with auto-renewal
- **Security headers** - HSTS, CSP, XSS protection, frame denial
- **Compression** - Gzip/Zstd for optimal performance
- **Privacy focused** - Minimal permissions, no tracking

### 📊 Monitoring & Logging
- **Health endpoints** - `/health` on each service for monitoring
- **Structured logging** - Individual log files per service

## Quick Start

### 1. Clone and Configure
```bash
git clone <this-repo>
cd homelab-caddy
cp .env.example .env
# Edit .env with your domains and settings
```

### 2. Build and Run
```bash
# Using Docker Compose (recommended)
docker-compose up -d

# Or build manually
docker build -t homelab-caddy .
docker run -d -p 80:80 -p 443:443 --env-file .env homelab-caddy
```

### 3. Configure DNS
Point your domains to your server:
```bash
# A records
yourdomain.com → YOUR_SERVER_IP
*.yourdomain.com → YOUR_SERVER_IP

# Specific domains
example.com → YOUR_SERVER_IP
```

## Configuration

### Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `CADDY_EMAIL` | Let's Encrypt email (required) | `admin@yourdomain.com` |
| `DOMAIN` | Main domain (required) | `yourdomain.com` |
| `BLUE_TARGET` | Bluesky profile redirect | `https://bsky.app/profile/yourdomain.com` |
| `MEET_TARGET` | Meeting scheduler | `https://calendly.com/username` |
| `MAIN_SITE` | Main site for legacy redirects | `https://yourdomain.com` |

### Adding New Services

1. **Add to Caddyfile:**
```caddyfile
newservice.{$DOMAIN} {
    reverse_proxy {$NEWSERVICE_BACKEND:localhost:8080}
    encode gzip zstd
    tls {
        issuer acme
        protocols tls1.3
    }
    header {
        X-Frame-Options "DENY"
        X-Content-Type-Options "nosniff"
        # ... other security headers
    }
}
```

2. **Add environment variable:**
```yaml
environment:
  - NEWSERVICE_BACKEND=internal-service:8080
```

3. **Update docker-compose (if needed):**
```yaml
newservice:
  image: your/service
  networks:
    - homelab
```

## Production Deployment

### Magic Containers Deployment
1. **Build and push:**
```bash
docker build -t your-registry/homelab-caddy .
docker push your-registry/homelab-caddy
```

2. **Deploy on Magic Containers:**
   - Create app with your image
   - Add Anycast endpoint (ports 80, 443)
   - Set environment variables
   - Point domains to Anycast IP

### Security Considerations
- ✅ All traffic uses HTTPS with strong ciphers (TLS 1.3)
- ✅ Security headers prevent XSS, clickjacking, content sniffing
- ✅ HSTS enforces HTTPS with preload directive
- ✅ Minimal permissions policy blocks unnecessary APIs
- ✅ Server header removed to reduce fingerprinting

### Monitoring
- Health endpoints at `/health` on each service
- Structured logging to `/var/log/caddy/`
- Compatible with external monitoring (since you have your own!)
- Docker health checks for container monitoring

## Architecture

This configuration demonstrates:
- **Multi-tenant redirects** - Handle dozens of domains efficiently
- **Security by default** - All the headers and policies you need
- **Homelab integration** - Reverse proxy pattern for internal services
- **Operational excellence** - Logging, monitoring, health checks
- **Scalability** - Easy to add new services and domains

Perfect for DevOps practitioners who want a production-grade edge for their homelab!

## Inspired By

This configuration is inspired by [Chris Short's](https://chrisshort.net) actual homelab setup - a real-world example of how DevOps professionals manage their personal infrastructure.