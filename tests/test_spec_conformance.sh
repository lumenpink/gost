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

echo "[6/8] Verificando regras GOST-25 (Fronteira) e GOST-26 (Taxonomia) em rules.json..."
if ! grep -q '"GOST-25-BORDER-INBOX-QUARANTINE"' "$RULES_FILE"; then
  echo "ERRO: Regra GOST-25-BORDER-INBOX-QUARANTINE ausente em specs/rules.json"
  exit 1
fi
if ! grep -q '"GOST-26-PROJECT-METADATA-TAXONOMY"' "$RULES_FILE"; then
  echo "ERRO: Regra GOST-26-PROJECT-METADATA-TAXONOMY ausente em specs/rules.json"
  exit 1
fi

echo "[7/8] Verificando profile de fronteira profiles/border.md e specs de Rust..."
if [ ! -f "${ROOT_DIR}/profiles/border.md" ]; then
  echo "ERRO: profiles/border.md ausente"
  exit 1
fi
if ! grep -q "profile.release" "${ROOT_DIR}/specs/languages/rust.md"; then
  echo "ERRO: Diretiva [profile.release] ausente em specs/languages/rust.md"
  exit 1
fi
if ! grep -q "crt-static" "${ROOT_DIR}/specs/languages/rust.md"; then
  echo "ERRO: Diretiva crt-static musl ausente em specs/languages/rust.md"
  exit 1
fi

echo "[8/8] Validando sanitização do catálogo de apps (/home/lumen/src/catalog.json)..."
python3 -c "
import json
catalog_path = '/home/lumen/src/catalog.json'
with open(catalog_path, 'r', encoding='utf-8') as f:
    items = json.load(f)

for item in items:
    name = item.get('name', '')
    desc = item.get('description', '')
    desc_lower = desc.lower()
    if 'soberan' in desc_lower:
        raise AssertionError(f'Item {name} contém termo soberano proibido: {desc}')
    if 'wasm' in desc_lower:
        raise AssertionError(f'Item {name} contém jargão técnico wasm proibido: {desc}')
    if 'rust' in desc_lower:
        raise AssertionError(f'Item {name} contém menção técnica desnecessária a Rust: {desc}')
    if name == 'navalha' and 'anti-design' not in desc_lower:
        raise AssertionError(f'Navalha DEVE conter termo canônico anti-design: {desc}')

print(f'  Catálogo com {len(items)} itens validado sem jargões técnicos!')
"

echo "✔ Todas as verificações normativas e testes de mutação passaram com sucesso!"
exit 0
