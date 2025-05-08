#!/bin/bash
echo "[INFO] Iniciando Play 10 — API Validation"

STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/health)
if [ "$STATUS" -eq 200 ]; then
  echo "[SUCESSO] API retornou 200 OK."
else
  echo "[ERRO] API retornou código $STATUS."
fi
