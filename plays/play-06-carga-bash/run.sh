#!/bin/bash
echo "[*] Iniciando carga via shell com curl..."
for i in {1..10}; do
  curl -s -o /dev/null -w "%{http_code}\n" https://httpbin.org/get
  sleep 1
done
echo "[✓] Carga simulada finalizada."
