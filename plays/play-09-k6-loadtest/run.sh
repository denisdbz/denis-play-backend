#!/usr/bin/env bash
echo "[INFO] Play 09 – k6 LoadTest"
if ! command -v k6 &> /dev/null; then
  echo "[WARN] k6 não instalado no container"
  exit 0
fi
k6 run scripts/api-load.js
