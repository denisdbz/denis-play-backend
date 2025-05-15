#!/bin/bash

echo "[*] Iniciando teste de API com curl..."
sleep 1

# Faz a requisição real
RESPONSE=$(curl -s https://jsonplaceholder.typicode.com/posts)

# Verifica se a requisição foi bem-sucedida
if [[ $? -eq 0 ]]; then
  echo "[✓] Teste de API executado com sucesso."
  echo
  echo "[→] Exibindo os 3 primeiros resultados:"

  echo "$RESPONSE" | jq '.[0:3]'
  echo
  echo "[✓] Teste finalizado com sucesso."
else
  echo "[X] Erro ao executar a requisição com curl."
fi
