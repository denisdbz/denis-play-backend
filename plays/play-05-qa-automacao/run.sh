#!/bin/bash
echo "[*] Iniciando teste de API com httpie..."
http GET https://jsonplaceholder.typicode.com/posts/1 | tee resultado_httpie.log
echo "[✓] Teste finalizado com sucesso."
