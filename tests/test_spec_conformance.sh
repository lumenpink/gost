#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULES_FILE="${ROOT_DIR}/specs/rules.json"
SPEC_FILE="${ROOT_DIR}/SPEC.md"
METADATA_FILE="${ROOT_DIR}/.gost/metadata.json"

echo "★ Verificando conformidade da norma GOST v2.0.0 ★"

echo "[1/6] Validando schema e regras determinísticas em specs/rules.json..."
python3 -c "
import json
with open('$RULES_FILE', 'r', encoding='utf-8') as f:
    data = json.load(f)
assert data.get('version') == '2.0.0', f'Invalid version: {data.get(\"version\")}'
assert 'waiver_policy' in data, 'Missing waiver_policy'
assert data['waiver_policy'].get('require_ticket_id') is True, 'waiver require_ticket_id should be true'

expected_rules = [
    'GOST-01-LICENSE',
    'GOST-02-ANATOMY-ROOT',
    'GOST-03-VERSION-SEMVER-SYNC',
    'GOST-04-COMMIT-PHASE-TAG',
    'GOST-04-A-CLOSE-RESOLUTION-REPORT',
    'GOST-04-B-MAESTRO-SINGLE-ENTRYPOINT',
    'GOST-05-BRANCH-AND-LOCAL-FIRST',
    'GOST-06-CI-TEST-COVERAGE',
    'GOST-07-STATIC-ZERO-WARNINGS',
    'GOST-08-FORMAT-DETERMINISTIC',
    'GOST-09-SITE-SECURITY-HEADERS',
    'GOST-10-CI-HERMETIC-SINGLE-FILE',
    'GOST-11-INTL-10-LANGUAGES-PARITY',
    'GOST-12-BANNER-AND-OG-SYNC',
    'GOST-13-XDG-AND-STREAMS-DISCIPLINE',
    'GOST-14-CLI-AUTO-UPDATE-CONTRACT',
    'GOST-15-OCI-CONTAINERS-AND-COMPOSE',
    'GOST-20-SITE-TYPE-AND-SSOT-DOCS',
    'GOST-24-ZERO-BINARIES-IN-GIT',
    'GOST-25-REMOTES-AND-INBOX-QUARANTINE',
    'GOST-26-METADATA-MANIFEST-SSOT',
    'GOST-27-DDD-HEXAGONAL-PURITY'
]

ids = [r['id'] for r in data['rules']]
for er in expected_rules:
    assert er in ids, f'Regra obrigatória ausente em rules.json: {er}'

print('  rules.json v2.0.0 validado com todas as 22 regras canônicas!')
"

echo "[2/6] Validando cláusulas no SPEC.md..."
if ! grep -q "O Maestro de Governança" "$SPEC_FILE"; then
  echo "ERRO: Seção do Maestro ausente em SPEC.md"
  exit 1
fi
if ! grep -q "\[Resumo\]:" "$SPEC_FILE"; then
  echo "ERRO: Cabeçalho [Resumo]: do Laudo ausente em SPEC.md"
  exit 1
fi
if ! grep -q "Pureza Arquitetural do Domínio" "$SPEC_FILE" && ! grep -q "Pureza de Domínio" "$SPEC_FILE"; then
  echo "ERRO: Cláusula de Pureza de Domínio ausente em SPEC.md"
  exit 1
fi

echo "[3/6] Validando especificações modulares por linguagem..."
for lang in rust go python php shell javascript r; do
  spec_path="${ROOT_DIR}/specs/languages/${lang}.md"
  if [ ! -f "$spec_path" ]; then
    echo "ERRO: Especificação de linguagem ausente: $spec_path"
    exit 1
  fi
  if ! grep -qi "GOST-27" "$spec_path"; then
    echo "ERRO: Regra GOST-27 não referenciada em $spec_path"
    exit 1
  fi
done
echo "  Todas as 7 linguagens canônicas presentes e com GOST-27 referenciado!"

echo "[4/6] Validando manifesto .gost/metadata.json..."
python3 -c "
import json
with open('$METADATA_FILE', 'r', encoding='utf-8') as f:
    meta = json.load(f)

required_keys = ['slug', 'title', 'site_type', 'tagline', 'summary', 'abstract', 'tags', 'icon', 'theme']
for k in required_keys:
    assert k in meta, f'Missing metadata key: {k}'

assert len(meta['slug']) <= 24, 'slug too long'
assert len(meta['title']) <= 25, 'title too long'
assert len(meta['tagline']) <= 60, 'tagline too long'
assert len(f\"{meta['title']} — {meta['tagline']}\") <= 65, 'title + tagline too long'
assert 50 <= len(meta['summary']) <= 140, f'summary length out of bounds: {len(meta[\"summary\"])}'
assert 150 <= len(meta['abstract']) <= 500, f'abstract length out of bounds: {len(meta[\"abstract\"])}'
assert 3 <= len(meta['tags']) <= 8, 'tags count out of bounds'

forbidden = ['soberano', 'soberana', 'hexagonal', 'ssot', 'rust puro', 'em rust', 'em php', 'wasm']
for term in forbidden:
    assert term not in meta['summary'].lower(), f'forbidden term in summary: {term}'
    assert term not in meta['abstract'].lower(), f'forbidden term in abstract: {term}'

print('  .gost/metadata.json aprovado estritamente pela Regra GOST-26!')
"

echo "[5/6] Validando teto de 50 linhas no README.md..."
readme_lines=$(wc -l < "${ROOT_DIR}/README.md")
if [ "$readme_lines" -gt 50 ]; then
  echo "ERRO: README.md excede 50 linhas ($readme_lines linhas)"
  exit 1
fi
echo "  README.md tem $readme_lines linhas (<= 50 linhas)."

echo "[6/6] Validando ausência de referências nominais e pessoais na norma base..."
if grep -rnE "banca\.2lp\.in|gambi\.2lp\.in|lumen\.pink" "${ROOT_DIR}/SPEC.md" "${ROOT_DIR}/README.md"; then
  echo "ERRO: Detectadas referências nominais a domínios pessoais na norma base."
  exit 1
fi

echo "✔ Todas as verificações de conformidade da GOST v2.0.0 passaram com louvor!"
exit 0
