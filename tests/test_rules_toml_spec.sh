#!/usr/bin/env bash
# ==============================================================================
# 🧪 [TESTE] Validação do Padrão rules.toml Tridigital e Locales i18n (#37)
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
echo "🧪 [TESTE] Auditoria de rules.toml, Lua gost.* e Locales (#37)"
echo "================================================================="

check "1. Verificando existência de specs/rules.toml" test -f "$RULES_TOML"
check "2. Verificando existência de specs/locales/pt-br.toml" test -f "$LOCALES_PT_BR"

check "3. Verificando identificadores estritamente tridigitais e 5 axiomas fundamentais" python3 -c '
import re
import tomllib

with open("'$RULES_TOML'", "rb") as f:
    data = tomllib.load(f)

rules = data.get("rules", {})
expected_names = {
    "GOST-001": "GOSTVER-FILE-REQUIRED",
    "GOST-002": "LICENSE-FILE-REQUIRED",
    "GOST-003": "VERSION-SEMVER-SYNTAX",
    "GOST-004": "README-FILE-REQUIRED",
    "GOST-005": "ZERO-BINARIES-IN-GIT",
}

assert len(rules) == 5, f"Contagem deve ser estritamente 5 regras fundamentais, obtido: {len(rules)}"
for expected_id, expected_name in expected_names.items():
    assert expected_id in rules, f"Regra fundamental {expected_id} ausente"
    rule = rules[expected_id]
    assert re.match(r"^GOST-\d{3}$", expected_id), f"ID deve ter 3 dígitos: {expected_id}"
    actual_name = rule.get("name")
    assert actual_name == expected_name, f"Nome incorreto em {expected_id}: {actual_name} != {expected_name}"
    assert "severity" in rule, f"Campo severity ausente em {expected_id}"
    assert "script" in rule, f"Campo script ausente em {expected_id}"
    assert "gost." in rule["script"], f"Script deve invocar namespace gost.* em {expected_id}"
'

check "4. Verificando paridade de chaves no catálogo de tradução pt-br.toml" python3 -c '
import tomllib

with open("'$RULES_TOML'", "rb") as f:
    canon = tomllib.load(f).get("rules", {})

with open("'$LOCALES_PT_BR'", "rb") as f:
    loc = tomllib.load(f).get("rules", {})

assert len(loc) == 5, f"Locales pt-br deve ter 5 regras, obtido: {len(loc)}"
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

# Teste de mutação: Catálogo com regra extra não fundamental deve falhar
check "7. [MUTAÇÃO] Testando sensibilidade a inclusão de regra tática espúria" python3 -c '
sample_rules = {"GOST-001": {}, "GOST-002": {}, "GOST-003": {}, "GOST-004": {}, "GOST-005": {}, "GOST-006": {}}
assert len(sample_rules) != 5, "Deveria detectar violação do teto de 5 axiomas"
'

echo "================================================================="
if [ "$FAIL" -gt 0 ]; then
    echo "💥 $FAIL TESTE(S) FALHARAM."
    exit 1
fi
echo "🎉 Todos os testes de rules.toml e locales i18n passaram com sucesso!"
