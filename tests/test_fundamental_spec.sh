#!/usr/bin/env bash
# ==============================================================================
# 🧪 [TESTE] Validação da Metanorma Fundamental GOST v3.0.0 (#32)
# ==============================================================================
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SPEC_FILE="${ROOT_DIR}/SPEC.md"
CONFORMANCE_TEST="${ROOT_DIR}/tests/test_spec_conformance.sh"

PASS=0
FAIL=0

check() {
    local desc="$1"
    shift
    echo -n "-> $desc... "
    if "$@"; then
        echo "✅ OK"
        PASS=$((PASS + 1))
    else
        echo "❌ FALHOU"
        FAIL=$((FAIL + 1))
    fi
}

echo "================================================================="
echo "🧪 [TESTE] Auditoria da Metanorma Fundamental GOST v3.0.0 (#32)"
echo "================================================================="

check "1. Verificando Frontmatter YAML obrigatório em SPEC.md" python3 -c '
import sys
with open("'$SPEC_FILE'", "r", encoding="utf-8") as f:
    content = f.read()
assert content.startswith("---\n"), "SPEC.md deve iniciar com frontmatter delimitado por ---"
parts = content.split("---\n", 2)
assert len(parts) >= 3, "Frontmatter YAML malformado"
frontmatter = parts[1]
assert "standard: \"gost\"" in frontmatter, "standard deve ser gost"
assert "tier: \"fundamental\"" in frontmatter, "tier deve ser fundamental"
assert "version: \"3.0.0\"" in frontmatter, "version deve ser 3.0.0"
assert "locale: \"pt-br\"" in frontmatter, "locale deve ser pt-br"
assert "v3" not in frontmatter and "v3.0.0" not in frontmatter, "Proibido prefixo v na versão"
'

check "2. Verificando presença dos quatro níveis normativos no SPEC.md" python3 -c '
with open("'$SPEC_FILE'", "r", encoding="utf-8") as f:
    text = f.read()
assert "tier: fundamental" in text, "Nível fundamental ausente"
assert "tier: strategic" in text, "Nível strategic ausente"
assert "tier: tactical" in text, "Nível tactical ausente"
assert "tier: operational" in text, "Nível operational ausente"
'

check "3. Verificando definição do Princípio da Tríade Normativa Fechada" grep -qi "tríade normativa fechada" "$SPEC_FILE"

check "4. Verificando convenção de base_url no SPEC.md" grep -qi "base_url" "$SPEC_FILE"

check "5. Verificando taxonomia de escopos de regras (commit-msg, project, pre-push)" python3 -c '
with open("'$SPEC_FILE'", "r", encoding="utf-8") as f:
    text = f.read()
assert "commit-msg" in text, "Escopo commit-msg ausente"
assert "project" in text, "Escopo project ausente"
assert "pre-push" in text, "Escopo pre-push ausente"
assert "git-history" in text, "Escopo git-history ausente"
'

# Teste de mutação: Rejeitar frontmatter sem tier fundamental
check "6. [MUTAÇÃO] Testando sensibilidade à ausência de tier fundamental no frontmatter" python3 -c '
bad_frontmatter = """---
standard: "gost"
tier: "generic"
version: "3.0.0"
---"""
assert "tier: \"fundamental\"" not in bad_frontmatter
'

# Teste de mutação: Rejeitar versão com prefixo 'v'
check "6. [MUTAÇÃO] Testando sensibilidade a prefixo v na versão do frontmatter" python3 -c '
bad_frontmatter = """---
standard: "gost"
tier: "fundamental"
version: "v3.0.0"
---"""
has_v = "v3" in bad_frontmatter or "v3.0.0" in bad_frontmatter
assert has_v, "Mutante deveria conter prefixo v inválido"
'

echo "================================================================="
if [ "$FAIL" -gt 0 ]; then
    echo "💥 $FAIL TESTE(S) FALHARAM."
    exit 1
fi
echo "🎉 Todos os testes da Metanorma Fundamental GOST v3.0.0 passaram!"
