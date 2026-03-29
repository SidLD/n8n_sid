#!/usr/bin/env bash
# Issue TLS with HTTP-01 while nginx uses http-only.conf (see .env.example).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

DOMAIN="${DOMAIN:?Set DOMAIN e.g. n8n.yourdomain.com}"
EMAIL="${EMAIL:?Set EMAIL for Let's Encrypt}"

docker compose run --rm --no-deps certbot certonly \
  --webroot -w /var/www/certbot \
  --email "$EMAIL" -d "$DOMAIN" \
  --rsa-key-size 4096 --agree-tos --no-eff-email --non-interactive

echo "1) Replace n8n.example.com with $DOMAIN in nginx/nginx.conf and nginx/http-only.conf"
echo "2) Set NGINX_CONF=./nginx/nginx.conf in .env"
echo "3) Point N8N_HOST / WEBHOOK_URL at https://$DOMAIN/"
echo "4) docker compose up -d --force-recreate nginx"
