#!/usr/bin/env bash
set -euo pipefail

DIR="${1:-.}"
echo "[INFO] Iniciando Play 20 — IaC Security Audit (Terraform)"
checkov -d "$DIR"
echo "[SUCESSO] Auditoria Terraform concluída."
