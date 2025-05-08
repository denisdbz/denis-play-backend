#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Iniciando Play 22 — Dependency Supply Chain Check"
npm audit --json
echo "[SUCESSO] Verificação de supply-chain concluída."
