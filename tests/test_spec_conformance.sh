#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULES_FILE="${ROOT_DIR}/specs/rules.json"
SPEC_FILE="${ROOT_DIR}/SPEC.md"

echo "★ Verificando regras normativas de esteira e Banca no GOST ★"

echo "[1/4] Verificando regra GOST-23-CI-EXCLUSIVE-BUILD em rules.json..."
if ! grep -q '"GOST-23-CI-EXCLUSIVE-BUILD"' "$RULES_FILE"; then
  echo "ERRO: Regra GOST-23-CI-EXCLUSIVE-BUILD ausente em specs/rules.json"
  exit 1
fi

echo "[2/4] Verificando regra GOST-24-BANCA-DISTRIBUTION em rules.json..."
if ! grep -q '"GOST-24-BANCA-DISTRIBUTION"' "$RULES_FILE"; then
  echo "ERRO: Regra GOST-24-BANCA-DISTRIBUTION ausente em specs/rules.json"
  exit 1
fi

echo "[3/4] Verificando cláusula de compilação exclusiva na esteira em SPEC.md..."
if ! grep -q "Compilação Soberana Exclusiva na Esteira" "$SPEC_FILE"; then
  echo "ERRO: Cláusula de Compilação Soberana ausente em SPEC.md"
  exit 1
fi

echo "[4/4] Verificando cláusula da Banca como distribuidora soberana em SPEC.md..."
if ! grep -q "Distribuição Canônica Soberana na Banca" "$SPEC_FILE"; then
  echo "ERRO: Cláusula de Distribuição na Banca ausente em SPEC.md"
  exit 1
fi

echo "✔ Todas as verificações normativas passaram com sucesso!"
exit 0
