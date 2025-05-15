#!/bin/bash

echo "[*] Iniciando teste de API com curl..."
sleep 1

RESPONSE=$(curl -s https://jsonplaceholder.typicode.com/posts)

if [[ $? -eq 0 ]]; then
  echo "[✓] Teste de API executado com sucesso."
  echo
  echo "[→] Exibindo os 3 primeiros resultados (resumo):"
  
  echo "$RESPONSE" | grep -E '"userId"|"id"|"title"' | head -n 9
  echo
  echo "[✓] Teste finalizado com sucesso."
else
  echo "[X] Erro ao executar a requisição com curl."
fi
