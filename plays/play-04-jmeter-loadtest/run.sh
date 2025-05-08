#!/bin/bash
echo "[*] Iniciando teste de carga com JMeter..."
jmeter -n -t plano-teste.jmx -l resultados.jtl
echo "[✓] Teste com JMeter finalizado. Logs salvos em resultados.jtl."
