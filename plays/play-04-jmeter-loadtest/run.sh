#!/bin/bash

echo "[*] Iniciando teste de carga com JMeter..."
sleep 1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
JMX_FILE="$SCRIPT_DIR/teste-carga.jmx"

# 1. Usa o JMeter embutido (ideal para Railway)
if [[ -x "$SCRIPT_DIR/../../tools/apache-jmeter-5.6.2/bin/jmeter" ]]; then
  JMETER_EXEC="$SCRIPT_DIR/../../tools/apache-jmeter-5.6.2/bin/jmeter"
# 2. Fallback para instalações locais
elif [[ -x "/opt/apache-jmeter-5.6.2/bin/jmeter" ]]; then
  JMETER_EXEC="/opt/apache-jmeter-5.6.2/bin/jmeter"
elif [[ -x "/opt/jmeter/bin/jmeter" ]]; then
  JMETER_EXEC="/opt/jmeter/bin/jmeter"
else
  echo "[X] JMeter não encontrado. Verifique o ambiente."
  exit 1
fi

"$JMETER_EXEC" -n \
  -t "$JMX_FILE" \
  -l "$SCRIPT_DIR/resultados.jtl" \
  -p "$(dirname "$JMETER_EXEC")/../bin/user.properties"

if [[ $? -eq 0 ]]; then
  echo "[✓] Teste com JMeter finalizado. Logs salvos em resultados.jtl."
  echo "[✓] Teste finalizado com sucesso."
else
  echo "[X] Erro ao executar o JMeter."
fi
