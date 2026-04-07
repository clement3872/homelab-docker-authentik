# Authentik

Centralized auth for the homelab. OIDC-native integration with Proxmox, Nextcloud, Open WebUI, and Outline.
Hosted on the Raspberry Pi 5. TLS via Caddy → VPS nginx SNI passthrough.

## Structure

```
authentik/
├── docker-compose.yml       — PostgreSQL + Redis + server + worker
├── .env.example             — all config vars documented
├── generate-secrets.sh      — auto-generates .env with fresh secrets
├── caddy/
│   └── authentik.caddy      — Caddyfile snippet (import into your main one)
├── media/                   — mounted volume for uploads/avatars
├── certs/                   — mounted volume for managed certs
└── custom-templates/        — override Authentik UI templates if needed
```

## Deploy

```bash
bash generate-secrets.sh   # creates .env with fresh secrets
docker compose up -d
```

First-time admin setup: `https://auth.example.com/if/flow/initial-setup/`

## Before deploying

- Replace `auth.example.com` in `caddy/authentik.caddy` with your actual hostname
- Replace `<VPS_IP>` in `caddy/authentik.caddy` with your VPS IP (`trusted_proxies`)
- Optionally configure email in `.env` (password resets / notifications)

## MFA policy (Authentik UI)

- WireGuard / LAN → MFA bypassed
- External access → MFA enforced

Configure via: Admin → Flows → `default-authentication-flow` → add a Policy Binding using a
`Expression Policy` that checks the source IP against your LAN/WireGuard range.
