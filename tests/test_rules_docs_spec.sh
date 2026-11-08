#!/usr/bin/env bash
# ==============================================================================
# 🧪 [TESTE] Validação da Documentação Individual de Regras (#34)
# ==============================================================================
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULES_TOML="${ROOT_DIR}/specs/rules.toml"
RULES_DOCS_DIR="${ROOT_DIR}/docs/rules"

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
echo "🧪 [TESTE] Auditoria de Documentação Individual de Regras (#34)"
echo "================================================================="

check "1. Verificando existência do diretório docs/rules" test -d "$RULES_DOCS_DIR"

check "2. Verificando presença de documentação para todas as regras de rules.toml" python3 -c '
import os
import tomllib

with open("'$RULES_TOML'", "rb") as f:
    rules = tomllib.load(f).get("rules", {})

missing = []
for rule_id in rules.keys():
    doc_path = os.path.join("'$RULES_DOCS_DIR'", f"{rule_id}.md")
    if not os.path.isfile(doc_path):
        missing.append(rule_id)

assert len(missing) == 0, f"Regras sem documentação dedicada em docs/rules/: {missing}"
'

check "3. Verificando seções obrigatórias em cada documento de regra" python3 -c '
import os
import tomllib

with open("'$RULES_TOML'", "rb") as f:
    rules = tomllib.load(f).get("rules", {})

required_sections = ["## Severidade", "## Caso Prático de Erro", "## Como Resolver"]
for rule_id in rules.keys():
    doc_path = os.path.join("'$RULES_DOCS_DIR'", f"{rule_id}.md")
    with open(doc_path, "r", encoding="utf-8") as f:
        text = f.read()
    for sec in required_sections:
        assert sec in text, f"Seção \"{sec}\" ausente no documento {doc_path}"
'

# Teste de mutação: Documento sem seção 'Como Resolver' deve falhar
check "4. [MUTAÇÃO] Testando sensibilidade a documento sem seção Como Resolver" python3 -c '
sample_doc = "# GOST-001\n## Severidade\nError\n## Caso Prático de Erro\nErro..."
assert "## Como Resolver" not in sample_doc, "Deveria detectar ausência de Como Resolver"
'

echo "================================================================="
if [ "$FAIL" -gt 0 ]; then
    echo "💥 $FAIL TESTE(S) FALHARAM."
    exit 1
fi
echo "🎉 Todos os testes de documentação individual de regras passaram!"
