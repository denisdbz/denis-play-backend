#!/usr/bin/env bash
set -euo pipefail

echo "[INFO] Iniciando Play 17 — Kubernetes Config Audit"
kube-bench
echo "[SUCESSO] Auditoria de configuração concluída."
