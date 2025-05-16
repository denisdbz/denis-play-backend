#!/usr/bin/env bash

# Play 03 — SQLMap DVWA em produção (shebang corrigido)
# Autentica no DVWA e roda sqlmap sem interatividade
set -euo pipefail

# Define host DVWA (sem porta)
TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

echo "[*] Autenticando no DVWA em https://$TARGET_HOST/login.php..."

# Resolve path absoluto do script e diretório
SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
COOKIE_FILE="$SCRIPT_DIR/cookies.txt"

# 1. Login e captura cookies (segue redirect)
curl -s -c "$COOKIE_FILE" -L \
  -d "username=admin&password=password&Login=Login" \
  "https://$TARGET_HOST/login.php" > /dev/null

echo "[*] Definindo segurança para LOW..."
curl -s -b "$COOKIE_FILE" -L \
  "https://$TARGET_HOST/security.php?security=low" > /dev/null

# 2. Extrai valor do PHPSESSID do cookie file
# 2. Extrai valor do PHPSESSID do cookie file
PHPSESSID=$(awk '/PHPSESSID/ {print $7}' "$COOKIE_FILE")
COOKIE="security=low; PHPSESSID=$PHPSESSID"
