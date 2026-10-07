#!/bin/bash
set -u

SCRIPT_DIR="/home/lumen/src/gost/scripts"
CONFORM="${SCRIPT_DIR}/gost-conform.sh"
REPORT_FILE="/home/lumen/src/gost/compliance_report.txt"

echo "=== RELATÓRIO DE AUDITORIA & CONFORMIDADE GOST v1.2.0 ===" > "$REPORT_FILE"
echo "Executado em: $(date -Iseconds)" >> "$REPORT_FILE"
echo "==========================================================" >> "$REPORT_FILE"

TOTAL=0
PERFECT=0
NEEDS_ATTENTION=0

for d in /home/lumen/src/*; do
  [ -d "$d/.git" ] || continue
  repo_name=$(basename "$d")
  TOTAL=$((TOTAL + 1))
  
  echo "" >> "$REPORT_FILE"
  echo "----------------------------------------------------------" >> "$REPORT_FILE"
  echo "Repositório: $repo_name ($d)" >> "$REPORT_FILE"
  echo "----------------------------------------------------------" >> "$REPORT_FILE"
  
  # Executa primeiro com --fix para auto-corrigir estruturas GOST
  "$CONFORM" --root "$d" --fix --quiet >/dev/null 2>&1 || true
  
  # Executa com --check para avaliar o status final
  OUTPUT=$("$CONFORM" --root "$d" --check 2>&1)
  RET=$?
  
  echo "$OUTPUT" >> "$REPORT_FILE"
  
  if [ $RET -eq 0 ]; then
    PERFECT=$((PERFECT + 1))
    echo "[$repo_name] -> 100% CONFORME"
  else
    NEEDS_ATTENTION=$((NEEDS_ATTENTION + 1))
    echo "[$repo_name] -> PENDÊNCIAS ENCONTRADAS"
  fi
done

echo "" >> "$REPORT_FILE"
echo "==========================================================" >> "$REPORT_FILE"
echo "RESUMO GERAL: Total: $TOTAL | 100% Conformes: $PERFECT | Com Pendências: $NEEDS_ATTENTION" >> "$REPORT_FILE"
echo "==========================================================" >> "$REPORT_FILE"

echo ""
echo "Concluído! Total: $TOTAL | 100% Conformes: $PERFECT | Com Pendências: $NEEDS_ATTENTION"
echo "Relatório gravado em: $REPORT_FILE"
