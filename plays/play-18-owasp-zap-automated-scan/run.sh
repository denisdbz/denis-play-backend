#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-http://localhost}"
echo "[INFO] Iniciando Play 18 — OWASP ZAP Automated Scan"
zap-baseline.py -t "$TARGET" -r zap_report.html
echo "[SUCESSO] Scan OWASP ZAP concluído."
