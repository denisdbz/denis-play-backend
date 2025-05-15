#!/bin/bash

echo "[*] Iniciando teste de carga com JMeter..."
sleep 1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
JMX_FILE="$SCRIPT_DIR/teste-carga.jmx"
JMETER_HOME="/opt/apache-jmeter-5.6.2"


if [[ ! -f "$JMX_FILE" ]]; then
  echo "[X] Arquivo teste-carga.jmx não encontrado em $JMX_FILE."
  exit 1
fi

"$JMETER_HOME/bin/jmeter" -n \
  -t "$JMX_FILE" \
  -l "$SCRIPT_DIR/resultados.jtl" \
  -p "$JMETER_HOME/bin/user.properties"

if [[ $? -eq 0 ]]; then
  echo "[✓] Teste com JMeter finalizado. Logs salvos em resultados.jtl."
  echo "[✓] Teste finalizado com sucesso."
else
  echo "[X] Erro ao executar o JMeter."
fi
