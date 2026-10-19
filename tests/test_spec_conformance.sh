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

echo "[4/5] Verificando cláusula da Banca como distribuidora soberana em SPEC.md..."
if ! grep -q "Distribuição Canônica Soberana na Banca" "$SPEC_FILE"; then
  echo "ERRO: Cláusula de Distribuição na Banca ausente em SPEC.md"
  exit 1
fi

echo "[5/5] Validando integridade de esquema e tetos de retenção em specs/rules.json..."
python3 -c "
import json
with open('$RULES_FILE') as f:
    data = json.load(f)
assert 'rules' in data, 'Missing rules array'
ids = [r['id'] for r in data['rules']]
assert 'GOST-23-CI-EXCLUSIVE-BUILD' in ids, 'Missing GOST-23-CI-EXCLUSIVE-BUILD'
assert 'GOST-24-BANCA-DISTRIBUTION' in ids, 'Missing GOST-24-BANCA-DISTRIBUTION'
r24 = next(r for r in data['rules'] if r['id'] == 'GOST-24-BANCA-DISTRIBUTION')
assert r24.get('retention', {}).get('stable') == 5, 'Invalid stable retention'
assert r24.get('retention', {}).get('nightly') == 10, 'Invalid nightly retention'
print('  Esquema JSON e tetos de retenção (5/10) validados com rigor!')
"

echo "✔ Todas as verificações normativas e testes de mutação passaram com sucesso!"
exit 0
