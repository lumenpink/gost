# Especificação Técnica — Descontinuação de Deploy no Codeberg Pages (#37)

## 1. Contexto e Motivação
No modelo operacional do ecossistema GOST, o Codeberg atua estritamente como um espelho de código soberano (*code mirror*). A distribuição da documentação pública e dos manuais da norma (`gost.2lp.in`) é realizada exclusivamente via Cloudflare Workers / Pages a partir do diretório `./site`.

Anteriormente, o workflow `.forgejo/workflows/ci.yml` mantinha uma etapa legada denominada `Deploy to Codeberg Pages (Stateless Orphan Force Push)`. Esta etapa tentava executar `git push --force origin pages` utilizando credenciais ausentes nos runners do Forgejo Actions, provocando a quebra sistemática da esteira de CI/CD do repositório `gost` (conforme registrado no ticket `baquara-infra#37`).

---

## 2. Requisitos Mandatórios

### 2.1 Remoção do Deploy no Codeberg Pages
1. A etapa `Deploy to Codeberg Pages (Stateless Orphan Force Push)` DEVE ser totalmente removida de `.forgejo/workflows/ci.yml`.
2. É vedada qualquer tentativa de publicação em branch `pages` ou endereços do Codeberg dentro da esteira de integração contínua do repositório `gost`.

### 2.2 Preservação do Deploy no Cloudflare Workers
1. O job `deploy-site` deve manter a etapa de deploy no Cloudflare Workers via `npx wrangler deploy`, acionada sob a branch `main` mediante validação de `CLOUDFLARE_API_TOKEN`.

---

## 3. Critérios de Aceite (DD-TDD)
1. **Fase 4 (Red Test):** O script `tests/test_ci_deploy_site.sh` deve falhar se detectar qualquer menção a `Codeberg Pages` ou tentativas de push para `pages` no workflow de CI.
2. **Fase 5 (Green Implement):** Workflow atualizado; teste deve passar com sucesso.
3. **Fase 7 (Mutation Test):** Teste de mutação deve comprovar que a injeção acidental de etapas de deploy no Codeberg provoca falha imediata.
