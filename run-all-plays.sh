#!/usr/bin/env bash
set -euo pipefail

# Total de plays que queremos executar
TOTAL=22
SUCESSOS=0

# Arquivo para marcar o início da execução
START_TIME=$(date +%s)

echo "🚀 Iniciando execução dos $TOTAL plays..."

for DIR in plays/play-*/; do
  echo -ne "\n▶️ Executando ${DIR%/}...\n"
  if bash "$DIR/run.sh"; then
    echo "   ✅ ${DIR%/} concluído com sucesso."
    SUCESSOS=$((SUCESSOS+1))
  else
    echo "   ❌ ${DIR%/} falhou."
  fi
done

# Tempo total decorrido
END_TIME=$(date +%s)
ELAPSED=$((END_TIME-START_TIME))
MINUTES=$((ELAPSED/60))
SECONDS=$((ELAPSED%60))

echo -ne "\n⏱️ Tempo total: ${MINUTES}m ${SECONDS}s\n"

if [ "$SUCESSOS" -eq "$TOTAL" ]; then
  # Aqui você pode usar notify-send, mail, Slack webhook, etc.
  echo "🎉 Todos os $TOTAL plays finalizaram com sucesso!"
else
  echo "⚠️ Apenas $SUCESSOS de $TOTAL plays terminaram com sucesso."
fi
