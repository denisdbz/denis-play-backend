#!/usr/bin/env bash
echo "[INFO] Play 08 – Nikto Scan"
TARGET=${1:-testphp.vulnweb.com}
nikto -host "$TARGET"
