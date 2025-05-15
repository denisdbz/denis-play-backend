#!/bin/bash

echo "[*] Iniciando teste de API com httpie..."
sleep 1

curl -s https://jsonplaceholder.typicode.com/posts

echo "[✓] Teste finalizado com sucesso."
