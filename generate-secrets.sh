#!/usr/bin/env bash
# Generates a ready-to-use .env from .env.example
# Run once before first `docker compose up`

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"
EXAMPLE_FILE="$SCRIPT_DIR/.env.example"

if [[ -f "$ENV_FILE" ]]; then
  echo ".env already exists — delete it first if you want to regenerate."
  exit 1
fi

PG_PASS=$(openssl rand -base64 36)
SECRET_KEY=$(openssl rand -base64 60)

sed \
  -e "s|^PG_PASS=.*|PG_PASS=$PG_PASS|" \
  -e "s|^AUTHENTIK_SECRET_KEY=.*|AUTHENTIK_SECRET_KEY=$SECRET_KEY|" \
  "$EXAMPLE_FILE" > "$ENV_FILE"

echo ".env created with fresh secrets."
echo ""
echo "  PG_PASS          : $PG_PASS"
echo "  SECRET_KEY       : $SECRET_KEY"
echo ""
echo "Edit .env to configure email or other optional settings, then:"
echo "  docker compose up -d"
