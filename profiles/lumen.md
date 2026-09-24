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

### 3.2 Ativação e Bloqueios dos Hooks
Após criar ou clonar o projeto, os hooks **DEVEM** ser inicializados via:
```bash
cccp install
```
Isso instala:
* **`commit-msg`:**
  - Validador rigoroso de Conventional Commits.
  - **Enforcement de Tickets:** Rejeita qualquer commit que não contenha a referência explícita ao ticket da issue no padrão `(ref #<id>)` ou `(closes #<id>)`. Bloqueia commits sem ticket na raiz.
* **`post-commit`:** Sincronizador atômico de versão (`VERSION`), atualização do `CHANGELOG.md` e metadados.
* **`pre-push`:** Gate de CI local com `act` (ver Seção 5.6).

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

## 5. Stack e Ferramental Padrão de Testes

Para atender aos requisitos de alta cobertura (>90%, foco em 100%) e mutação da norma GOST, o ecossistema Lumen adota as seguintes ferramentas padronizadas por linguagem:

### 5.1 Shell Scripting / CLI de Sistema
* **Runner de Testes:** **`shellspec`** (BDD framework para POSIX shell / bash).
* **Estrutura:** Especificações organizadas sob `spec/` (ex: `spec/*_spec.sh`).
* **Cobertura:** Mensuração via `kcov` integrada ao shellspec (`shellspec --kcov`).

### 5.2 Rust (Sistemas, Milters, Daemons e CLI)
* **Runner de Testes:** **`cargo test`** (testes unitários in-source em `src/` e testes de integração em `tests/`).
* **Cobertura:** **`cargo-tarpaulin`** ou **`cargo-llvm-cov`** (com flag obrigatória de bloqueio `--fail-under 90`).
* **Testes de Mutação:** **`cargo-mutants`** para detecção de testes ineficazes e mutantes sobreviventes.

### 5.3 PHP (IndieWeb, APIs e Aplicações Web)
* **Runner de Testes:** **`pest`** (PHP Testing Framework elegante e veloz).
* **Cobertura:** Execução contínua com verificação estrita:
  ```bash
  vendor/bin/pest --coverage --min=90
  ```
* **Testes de Mutação:** **`infection`** (`vendor/bin/infection --min-msi=80`).

### 5.4 Web, Interfaces e Ponta a Ponta (E2E)
* **Runner E2E:** **`playwright`** (`npx playwright test`).
* **Escopo:** Navegação automatizada *headless* em Chromium, Firefox e WebKit simulando as jornadas reais do usuário e garantindo ausência de erros de console, layout e renderização.

### 5.5 Análise Estática & Zero Warnings por Stack
* **Rust:**
  - Linter: `cargo clippy --all-targets --all-features -- -D warnings`
  - Formatação: `cargo fmt -- --check`
  - Auditoria de Dependências: `cargo audit`
* **PHP:**
  - Análise Estática: `vendor/bin/phpstan analyse --level=max`
  - Estilo de Código: `vendor/bin/pint --test`
  - Auditoria de Dependências: `composer audit`
* **Shell Scripting:**
  - Linter: `shellcheck` (zero avisos tolerados em todos os scripts)

### 5.6 Gate de Pre-Push com `act` (CI Local Idêntico)
O ecossistema Lumen usa **`act`** — executor local de Forgejo/GitHub Actions baseado em Docker — para rodar o job `test` do pipeline em um ambiente **bit-for-bit idêntico** ao do Forgejo antes de cada `git push`.

#### Ferramenta
* **`act`** ([`nektos/act`](https://github.com/nektos/act)): lê `.forgejo/workflows/ci.yml` e executa os jobs dentro dos mesmos containers Docker usados pelo Forgejo Actions.
* **Pré-requisito:** Docker em execução na máquina de desenvolvimento (sempre presente no ecossistema Lumen).

#### Comportamento do Hook `pre-push`
```
git push
  └─► pre-push hook (instalado por cccp install)
        ├─ Verifica se act + Docker estão disponíveis
        │    └─ Não disponíveis: emite aviso, NÃO bloqueia push
        ├─ Executa: act -j test --no-pull
        │    └─ Saída completa → .git/act-logs/<data>_<hora>_<branch>_<sha-curto>.log
        ├─ Mostra: spinner vivo + step atual + tempo decorrido
        └─ Exit 0: push prossegue  |  Exit 1: push abortado + resumo + path do log
```

#### Formato dos Logs
```
.git/act-logs/
  2026-09-24_09-41_feat-42-rate-limit_a4b3c2d.log
  2026-09-24_08-17_main_cd62fd5.log
```
* Diretório `.git/act-logs/` é automaticamente ignorado pelo git.
* Consulta rápida ao log mais recente: `cccp act log`

#### UX do Gate no Terminal
```
⠸ [pre-push] Running CI gate locally...
  Job: test › cargo clippy -- -D warnings     [0:12]
  Log: .git/act-logs/2026-09-24_09-41_feat-42_a4b3c2d.log
```
Sucesso:
```
✅ CI gate passed (1m 34s) — pushing to origin/main
```
Falha:
```
❌ CI gate failed (0m 47s) — push aborted
   → Step failed: cargo test (3 failures)
   → Log: .git/act-logs/2026-09-24_09-41_feat-42_a4b3c2d.log
   → Bypass consciente: git push --no-verify
```

#### Bypass Explícito
```bash
git push --no-verify  # bypass consciente e documentado — não use por hábito
```

---

## 6. Pipeline de CI/CD (`.forgejo/workflows/ci.yml`)

O workflow no Forgejo Actions declara **obrigatoriamente** jobs separados: `test` (roda também localmente via `act`) e `deploy-site` (exclusivo do Forgejo, após push):

```yaml
name: "CI / CD Pipeline"

on:
  push:
    branches: [main, develop]
  pull_request:

jobs:
  test:
    name: "Run Test Suite & Enforce Coverage (>90%)"
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # Passos da stack (ex: pest --coverage --min=90, cargo llvm-cov --fail-under 90, etc.)

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

## 7. Registro no Catálogo Central (`~/src/catalog.json`)

Todo repositório sob o perfil Lumen deve ser registrado no arquivo central de descoberta `~/src/catalog.json`:

```json
{
  "name": "<nome-do-projeto>",
  "forge": "codeberg",
  "slug": "lumenpink/<nome-do-projeto>",
  "description": "<Descrição objetiva em uma linha>",
  "topics": ["palavra-chave-1", "palavra-chave-2"],
  "license": "CC0-1.0",
  "website": "https://<nome-do-projeto>.2lp.in",
  "is_upstream": false
}
```

Isso garante indexação pelo `cccp catalog`, ferramentas de busca local e dashboards do ecossistema.

---

## 8. Mapeamento do Ciclo DD-TDD no Perfil Lumen

No dia a dia do ecossistema Lumen, o ciclo DD-TDD opera integrado ao Codeberg Issues, branches dedicados e ao CLI `cccp`:

### 8.1 Passo a Passo Operacional:
1. **Abertura do Ticket:**
   - Criado via interface do Codeberg ou via CLI:
     ```bash
     tea issue create --title "Rate limiting no endpoint de autenticação"
     # Issue #42 criada
     ```
2. **Criação do Branch Dedicado:**
   - Nunca commitar na `main`:
     ```bash
     git checkout -b feat/42-rate-limit
     ```
3. **Doc in develop (Commit):**
   - Documentação prévia dos contratos e schemas:
     ```bash
     git commit -m "docs(auth): document rate limit headers and error payloads (ref #42)"
     ```
4. **Failing Test (Commit):**
   - Teste automatizado que falha comprovando a ausência da proteção:
     ```bash
     git commit -m "test(auth): add failing integration test for 61st request (ref #42)"
     ```
5. **Fix / Code (Commit):**
   - Código que faz o teste passar com linter limpo (Zero Warnings):
     ```bash
     git commit -m "feat(auth): implement token bucket rate limiter (ref #42)"
     ```
6. **Finish Docs & Close (Commit):**
   - Atualização da documentação no `./site`, `CHANGELOG.md` e fechamento formal:
     ```bash
     git commit -m "docs(auth): update security guide and finalize tickets (closes #42)"
     ```

### 8.2 Gestão de Releases e Publicação Semântica
Quando um conjunto de tickets/milestones atinge maturidade:
```bash
cccp release minor   # ou patch / major
git push --tags origin main
```
Isso consolida o `CHANGELOG.md`, atualiza `VERSION` para versão estável e cria a tag Git correspondente.

---

## 9. Internacionalização no Perfil Lumen

O ecossistema Lumen adota o padrão de roteamento e estrutura multilíngue validado no `indieinabox`:

### 9.1 Matriz de 10 Línguas Suportadas no `./site`
```javascript
var supported = ['en', 'pt', 'es', 'fr', 'de', 'it', 'ru', 'zh', 'ja', 'ar'];
```

### 9.2 Roteador Estático Cliente (`site/index.html`)
Na raiz de documentação `./site/index.html`, inclui-se o script de redirecionamento automático com detecção e persistência:
```html
<script>
    (function() {
        var supported = ['en', 'pt', 'es', 'fr', 'de', 'it', 'ru', 'zh', 'ja', 'ar'];
        var saved = localStorage.getItem('doc_lang');
        if (saved && supported.indexOf(saved) !== -1) {
            window.location.replace(saved + '/');
            return;
        }
        var navLang = (navigator.language || navigator.userLanguage || 'en').toLowerCase().substring(0, 2);
        if (supported.indexOf(navLang) !== -1) {
            window.location.replace(navLang + '/');
        } else {
            window.location.replace('en/');
        }
    })();
</script>
```

### 9.3 Suporte Obrigatório a RTL para o Árabe (`site/ar/`)
As páginas sob `site/ar/` utilizam:
```html
<html lang="ar" dir="rtl">
```

---

## 10. Banners e Cards Sociais (Padrão KokoroSim)

Todo repositório Lumen que publique site estático deve manter a automação para geração do banner Open Graph em `./site/assets/og_preview.png`.

### 10.1 Script de Geração (`scripts/generate_og_image.py`)
Utiliza Python + Pillow para renderizar o banner em 1200x630 com Safe Zone 4:3 centralizada (largura de 720px a 840px), evitando cortes em pré-visualizações móveis e do WhatsApp:
- **Resolução:** 1200x630 px
- **Safe Zone:** Miolo central com sangria lateral mínima de 180px.
- **Tipografia:** Fonte condensada geométrica para títulos de alto impacto.

### 10.2 Preview de Cards (`site/card_preview.html`)
Para validação visual fiel antes do deploy, recomenda-se incluir em `site/card_preview.html` a simulação de renderização em WhatsApp (Dark Mode) e Twitter/X (Summary Large Image), conforme arquitetura do KokoroSim.

