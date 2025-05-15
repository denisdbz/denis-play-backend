#!/bin/bash
echo "[*] Iniciando teste de carga com JMeter..."
sleep 1

if [[ ! -f teste-carga.jmx ]]; then
  echo "[X] Arquivo teste-carga.jmx não encontrado."
  exit 1
fi

# Executa o teste
jmeter -n -t teste-carga.jmx -l resultados.jtl

# Verifica se a execução ocorreu com sucesso
if [[ $? -eq 0 ]]; then
  echo "[✓] Teste com JMeter finalizado. Logs salvos em resultados.jtl."
  echo "[✓] Teste finalizado com sucesso."
else
  echo "[X] Erro ao executar o JMeter."
fi
