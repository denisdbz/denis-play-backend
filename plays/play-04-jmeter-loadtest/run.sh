#!/bin/bash
echo "[*] Iniciando teste de carga com JMeter..."
jmeter -n -t teste-carga.jmx -l resultados.jtl
echo "[✓] Teste com JMeter finalizado. Logs salvos em resultados.jtl."
