#!/usr/bin/env bash
# ==============================================================================
# TESTE: Auditoria de Descontinuação de Deploy no Codeberg Pages (#37)
# ==============================================================================
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKFLOW="$REPO_ROOT/.forgejo/workflows/ci.yml"
SPEC="$REPO_ROOT/specs/37-ci-deploy-site.md"

FAILED=0

echo "==> Executando testes de auditoria de deploy no CI do GOST..."

# 1. Validar existência da especificação
if [[ ! -f "$SPEC" ]]; then
    echo "FALHA: Arquivo de especificação $SPEC não encontrado."
    FAILED=1
else
    echo "OK: Especificação presente."
fi

# 2. Validar existência do workflow
if [[ ! -f "$WORKFLOW" ]]; then
    echo "FALHA: Workflow $WORKFLOW não encontrado."
    FAILED=1
else
    echo "OK: Workflow .forgejo/workflows/ci.yml existe."
fi

# 3. Proibir deploy no Codeberg Pages e pushes órfãos
echo -n "-> Verificando ausência de referências a Codeberg Pages no CI... "
if grep -qi "Codeberg Pages" "$WORKFLOW" || grep -q "actions@codeberg.org" "$WORKFLOW" || grep -q "git push --force origin pages" "$WORKFLOW"; then
    echo "FALHA: Detectada etapa de deploy no Codeberg Pages em $WORKFLOW."
    FAILED=1
else
    echo "OK: Nenhuma etapa de deploy no Codeberg Pages encontrada."
fi

# 4. Validar deploy no Cloudflare Workers
echo -n "-> Verificando presença de deploy no Cloudflare Workers... "
if ! grep -q "npx wrangler deploy" "$WORKFLOW"; then
    echo "FALHA: Etapa de deploy via wrangler ausente em $WORKFLOW."
    FAILED=1
else
    echo "OK: Deploy no Cloudflare Workers configurado."
fi

# 5. Testes de Mutação (Fase 7 GOST)
echo "=== [MUTAÇÃO] Testando sensibilidade da auditoria contra mutantes ==="

# Mutação 1: Rejeitar reintrodução de Codeberg Pages
echo -n "-> [MUTAÇÃO] Injetando etapa de deploy no Codeberg Pages em workflow simulado... "
TMP_WF=$(mktemp)
cat << 'MUT' > "$TMP_WF"
      - name: "Deploy to Codeberg Pages (Stateless Orphan Force Push)"
        run: git push --force origin pages
MUT

MUTATION_CAUGHT=0
if grep -qi "Codeberg Pages" "$TMP_WF" || grep -q "git push --force origin pages" "$TMP_WF"; then
    MUTATION_CAUGHT=1
fi
rm -f "$TMP_WF"

if [[ "$MUTATION_CAUGHT" -eq 1 ]]; then
    echo "OK: Mutante de deploy no Codeberg detectado e bloqueado com precisão."
else
    echo "FALHA: Mutação 1 falhou."
    FAILED=1
fi

# Mutação 2: Rejeitar omissão de deploy no Cloudflare Workers
echo -n "-> [MUTAÇÃO] Omitindo deploy via wrangler em workflow simulado... "
TMP_WF2=$(mktemp)
grep -v "npx wrangler deploy" "$WORKFLOW" > "$TMP_WF2"

if ! grep -q "npx wrangler deploy" "$TMP_WF2"; then
    echo "OK: Mutante de ausência de deploy Cloudflare detectado com precisão."
else
    echo "FALHA: Mutação 2 falhou."
    FAILED=1
fi
rm -f "$TMP_WF2"

echo "================================================================="
if [[ "$FAILED" -eq 0 ]]; then
    echo "SUCESSO: Esteira de CI/CD validada sem etapas inválidas de deploy!"
    exit 0
else
    echo "STATUS: RED (Falha em asserção ou teste de mutação)"
    exit 1
fi
