#!/bin/bash
echo "[+] Iniciando varredura com nmap..."
sleep 1
nmap -Pn -T4 -F scanme.nmap.org
echo "[+] Varredura concluída!"
