#!/bin/bash
echo "[*] Iniciando varredura Nmap..."
nmap -sS -Pn -T4 -p- 127.0.0.1
echo "[✓] Varredura finalizada."
