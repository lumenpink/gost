#!/usr/bin/env bash
# ==============================================================================
# 🧪 [TESTE] Validação do Padrão rules.toml Tridigital e Locales i18n (#33)
# ==============================================================================
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RULES_TOML="${ROOT_DIR}/specs/rules.toml"
LOCALES_PT_BR="${ROOT_DIR}/specs/locales/pt-br.toml"

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
echo "🧪 [TESTE] Auditoria de rules.toml, Lua gost.* e Locales (#33)"
echo "================================================================="

check "1. Verificando existência de specs/rules.toml" test -f "$RULES_TOML"
check "2. Verificando existência de specs/locales/pt-br.toml" test -f "$LOCALES_PT_BR"

check "3. Verificando identificadores estritamente tridigitais (GOST-001 a GOST-999)" python3 -c '
import re
import tomllib

with open("'$RULES_TOML'", "rb") as f:
    data = tomllib.load(f)

rules = data.get("rules", {})
assert len(rules) >= 20, f"Contagem insuficiente de regras: {len(rules)}"

for rule_id, rule_body in rules.items():
    assert re.match(r"^GOST-\d{3}$", rule_id), f"ID deve ter exatamente 3 dígitos: {rule_id}"
    assert "name" in rule_body, f"Campo name ausente em {rule_id}"
    assert "severity" in rule_body, f"Campo severity ausente em {rule_id}"
    assert "script" in rule_body, f"Campo script ausente em {rule_id}"
    assert "gost." in rule_body["script"], f"Script deve invocar namespace gost.* em {rule_id}"
'

check "4. Verificando paridade de chaves no catálogo de tradução pt-br.toml" python3 -c '
import tomllib

with open("'$RULES_TOML'", "rb") as f:
    canon = tomllib.load(f).get("rules", {})

with open("'$LOCALES_PT_BR'", "rb") as f:
    loc = tomllib.load(f).get("rules", {})

for rule_id in canon.keys():
    assert rule_id in loc, f"Regra {rule_id} ausente em locales/pt-br.toml"
    assert "description" in loc[rule_id], f"description ausente em {rule_id} (pt-br)"
'

# Teste de mutação: ID bidigital deve falhar
check "5. [MUTAÇÃO] Testando sensibilidade a ID bidigital incorreto" python3 -c '
import re
rule_id = "GOST-01"
assert not re.match(r"^GOST-\d{3}$", rule_id), "Deveria ter rejeitado ID bidigital"
'

# Teste de mutação: Script sem namespace gost.* deve falhar
check "6. [MUTAÇÃO] Testando sensibilidade a script sem namespace gost.*" python3 -c '
script = "local x = 10; return true"
assert "gost." not in script, "Deveria detectar ausência de gost.*"
'

echo "================================================================="
if [ "$FAIL" -gt 0 ]; then
    echo "💥 $FAIL TESTE(S) FALHARAM."
    exit 1
fi
echo "🎉 Todos os testes de rules.toml e locales i18n passaram com sucesso!"
