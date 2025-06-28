# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.1.x   | :white_check_mark: |
| 1.0.x   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

1. **Do not** create a public GitHub issue for security vulnerabilities
2. Email the maintainer directly at: <chrisshort@duck.com>
3. Include detailed information about the vulnerability
4. Allow reasonable time for a response before public disclosure

## Security Measures

This project implements several security measures:

- **Automated vulnerability scanning** via GitHub Actions
- **Non-root container execution**
- **Minimal base image** (Alpine Linux)
- **Regular dependency updates** via Dependabot
- **HTTPS enforcement** via Caddy
- **Health checks** for container monitoring

## Response Timeline

- Initial response: Within 3 days
- Vulnerability assessment: Within 2 weeks
- Security fix release: Within 2 weeks (for critical issues)

## Security Best Practices

When deploying this proxy:

1. Keep the Docker image updated
2. Use strong TLS certificates
3. Monitor container logs regularly
4. Implement network security policies
5. Regular security audits of your Caddyfile configuration
