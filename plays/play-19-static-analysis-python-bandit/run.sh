#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Iniciando Play 19 — Static Analysis Python (Bandit)"
bandit -r .
echo "[SUCESSO] Análise estática (Bandit) concluída."
