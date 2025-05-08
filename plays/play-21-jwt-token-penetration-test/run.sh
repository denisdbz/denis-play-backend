#!/usr/bin/env bash
set -euo pipefail

TOKEN="${1:-<seu_token>}"
URL="${2:-http://localhost/api}"
echo "[INFO] Iniciando Play 21 — JWT Token Penetration Test"
python3 jwt_tester.py --token "$TOKEN" --url "$URL"
echo "[SUCESSO] Teste de penetração JWT concluído."
