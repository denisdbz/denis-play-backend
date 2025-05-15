#!/bin/bash

echo "[*] Iniciando teste de carga com JMeter..."
sleep 1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
JMX_FILE="$SCRIPT_DIR/teste-carga.jmx"

if [[ ! -f "$JMX_FILE" ]]; then
  echo "[X] Arquivo teste-carga.jmx não encontrado em $JMX_FILE."
  exit 1
fi

# Corrige erro ForbiddenClassException
jmeter -n -t "$JMX_FILE" -l "$SCRIPT_DIR/resultados.jtl" \
  -Jclassloader.include=org.apache.jmeter.save.ScriptWrapper

if [[ $? -eq 0 ]]; then
  echo "[✓] Teste com JMeter finalizado. Logs salvos em resultados.jtl."
  echo "[✓] Teste finalizado com sucesso."
else
  echo "[X] Erro ao executar o JMeter."
fi
