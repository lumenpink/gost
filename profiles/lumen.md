# Perfil de Implementação: Ecossistema Lumen
**Identificador do Perfil:** `lumen`  
**Norma Base:** GOST `1.0.0-draft`  
**Autor:** lumenpink  
**Status:** Ativo / Produção

---

## 1. Visão Geral

Este documento define as especificações concretas, serviços de nuvem, ferramentas de automação e infraestrutura adotadas no ecossistema pessoal e profissional da Lumen para satisfazer todos os requisitos normativos do padrão **GOST**.

---

## 2. Forja de Código e Repositórios Remotos

### 2.1 Forja Primária
* **Instância:** [Codeberg](https://codeberg.org/) (Software Forgejo).
* **Organização / Usuário:** `lumenpink`.
* **URL do Repositório:** `https://codeberg.org/lumenpink/<nome-do-repo>`.
* **Remote Git SSH Padrão:** `ssh://git@codeberg.org/lumenpink/<nome-do-repo>.git`.
* **Branch Padrão:** `main`.

### 2.2 Criação Automatizada via API
A criação de repositórios remotos utiliza a API v1 do Codeberg autenticada via `$CODEBERG_TOKEN`:

```bash
curl -X POST \
  -H "Authorization: token $CODEBERG_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "<nome-do-repo>",
    "description": "<Descrição curta e objetiva do projeto>",
    "private": false,
    "auto_init": false
  }' \
  "https://codeberg.org/api/v1/user/repos"
```

---

## 3. Gestão de Commits e Hooks (`cccp`)

O ecossistema Lumen utiliza a CLI **`cccp`** como ferramenta central de versionamento, hooks do Git e integridade semântica.

### 3.1 Arquivo `.cccprc`
Todo repositório no perfil Lumen **DEVE** conter na raiz o arquivo `.cccprc`:

```ini
codeberg_owner = lumenpink
codeberg_repo = <nome-do-repo>
agent_md_url = https://gist.githubusercontent.com/lumenpink/ebaded4f8bfb956346c28b64f48754fb/raw/c48a2f9cfb4fd73dcb944c4e47a5b17b8f3a3a2e/AGENTS.md
agent_var_lang = english
```

### 3.2 Ativação dos Hooks
Após criar ou clonar o projeto, os hooks **DEVEM** ser inicializados via:
```bash
cccp install
```
Isso instala:
* `commit-msg`: Validador de conformidade com Conventional Commits.
* `post-commit`: Sincronizador de versão (`VERSION`), atualização do `CHANGELOG.md` e metadados.

---

## 4. Publicação Web e Documentação (`*.2lp.in`)

### 4.1 Infraestrutura: Cloudflare Workers
A vitrine de documentação pública (`./site`) é publicada na borda da Cloudflare sob o domínio unificado `*.2lp.in`.

### 4.2 Arquivo `wrangler.jsonc`
```jsonc
{
  "$schema": "node_modules/wrangler/config-schema.json",
  "name": "<nome-do-projeto>",
  "compatibility_date": "2024-09-23",
  "routes": [
    {
      "pattern": "<nome-do-projeto>.2lp.in",
      "custom_domain": true
    }
  ],
  "assets": {
    "directory": "./site"
  }
}
```

### 4.3 Cabeçalhos de Segurança (`site/_headers`)
```http
/*
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  Referrer-Policy: strict-origin-when-cross-origin
```

### 4.4 Fallback: Codeberg Pages
Como contingência e redundância estática, o pipeline de CI publica a pasta `./site` também no Codeberg Pages (`https://lumenpink.codeberg.page/<nome-do-repo>/`).

---

## 5. Pipeline de CI/CD (`.forgejo/workflows/ci.yml`)

O workflow no Forgejo Actions orquestra validação e deploy contínuo:

```yaml
name: "CI / CD Pipeline"

on:
  push:
    branches: [main, develop]
  pull_request:

jobs:
  test:
    name: "Run Test Suite"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # Passos específicos da stack (cargo test, composer test, npm test, etc.)

  deploy-site:
    name: "Deploy Documentation Site"
    runs-on: ubuntu-latest
    needs: [test]
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: "Deploy to Cloudflare Workers"
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
        run: |
          if [ -n "$CLOUDFLARE_API_TOKEN" ]; then
            npx wrangler deploy
          fi
      - name: "Deploy to Codeberg Pages (Fallback)"
        uses: https://codeberg.org/actions/pages@v1
        with:
          path: site
```

---

## 6. Registro no Catálogo Central (`~/src/catalog.json`)

Todo repositório sob o perfil Lumen deve ser registrado no arquivo central de descoberta `~/src/catalog.json`:

```json
{
  "name": "<nome-do-projeto>",
  "forge": "codeberg",
  "slug": "lumenpink/<nome-do-projeto>",
  "description": "<Descrição objetiva em uma linha>",
  "topics": ["palavra-chave-1", "palavra-chave-2"],
  "license": "Unlicense",
  "website": "https://<nome-do-projeto>.2lp.in",
  "is_upstream": false
}
```

Isso garante indexação pelo `cccp catalog`, ferramentas de busca local e dashboards do ecossistema.

---

## 7. Mapeamento do Ciclo DD-TDD no Perfil Lumen

No dia a dia do ecossistema Lumen, o ciclo DD-TDD opera integrado ao Codeberg Issues e ao CLI `cccp`:

1. **Ticket:** Criado no issue tracker do Codeberg (`https://codeberg.org/lumenpink/<repo>/issues/<id>`).
2. **Doc in develop (Commit):**
   ```bash
   git commit -m "docs(spec): document API contracts for auth endpoint (ref #42)"
   ```
3. **Failing Test (Commit):**
   ```bash
   git commit -m "test(auth): add failing integration test for JWT expiry (ref #42)"
   ```
4. **Fix / Code (Commit):**
   ```bash
   git commit -m "feat(auth): validate token expiration timestamp (ref #42)"
   ```
5. **Finish Docs & Close (Commit):**
   ```bash
   git commit -m "docs(auth): update swagger and deployment notes (closes #42)"
   ```
