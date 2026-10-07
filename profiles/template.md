# Perfil de Implementação GOST: {{NOME_DO_ECOSSISTEMA}}

> **Instruções de Preenchimento:**  
> Este documento é o modelo canônico de Perfil de Implementação para o padrão **GOST**.  
> Copie este arquivo para o seu repositório de perfis (ou pasta local de especificação), substitua os marcadores `{{...}}` pelas escolhas concretas da sua organização e referencie a URL crua deste arquivo no campo `GOST_PROFILE_URL` do arquivo `GOSTVER` dos seus repositórios.

---

**Identificador do Perfil:** `{{slug_do_perfil}}` (ex: `corp`, `minhaorg`, `personal`)  
**Mantenedor / Organização:** `{{nome_ou_organizacao}}`  
**Norma GOST Alvo:** `1.0.0` (ou versão vigente)  
**URL Canônica deste Perfil:** `{{URL_DO_PERFIL_PUBLICO}}`  
**Licença do Documento:** `{{LICENCA}}` (ex: `CC-BY-SA-4.0` ou `CC0-1.0`)

---

## 1. Visão Geral

Descreva o ecossistema, os princípios arquiteturais e a motivação deste perfil.

* **Objetivo:** {{Defina o propósito deste conjunto de ferramentas e serviços}}
* **Ambiente de Destino:** {{Servidores próprios, PaaS, Cloud pública, bare metal, homelab}}
* **Filosofia:** {{Ex: Anti-bloat, hermeticidade estrita, minimalismo operacional, etc.}}

---

## 2. Forja de Código e Repositórios Remotos

Define o serviço de hospedagem Git e convenções de acesso e criação de projetos.

* **Forja Primária:** {{Codeberg / GitHub / GitLab / Forgejo Self-Hosted / Gitea}}
* **Namespace / Organização:** `{{seu_namespace_ou_usuario}}`
* **Padrão de URL Remota Git:**
  - SSH: `ssh://git@{{servidor_git}}/{{namespace}}/<repo>.git`
  - HTTPS: `https://{{servidor_git}}/{{namespace}}/<repo>`
* **Convenção de Branches:**
  - Branch estável/produção: `main` (protegida contra commits diretos)
  - Branches de trabalho DD-TDD: `feat/<id>-<slug>` ou `fix/<id>-<slug>`
* **Automação de Criação:**
  - {{Descreva a ferramenta ou script para criação remota via API, ex: `tea`, `gh`, `glab` ou curl}}

---

## 3. Gestão de Commits e Hooks de Integridade

Define as ferramentas e mecanismos que asseguram commits semânticos e rastreabilidade total de tickets.

* **Ferramenta de Governança Semântica:** {{`cccp` / `husky` + `commitlint` / scripts nativos em `.git/hooks`}}
* **Arquivo de Configuração no Repositório:** {{Ex: `.cccprc` ou `commitlint.config.js`}}
* **Regras de Validação:**
  - Padrão: Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`, etc.).
  - **Zero Commits sem Ticket:** Bloqueio rígido no hook `commit-msg` contra commits sem referência formal a tickets `(ref #ID)` ou fechamento `(closes #ID)`.
  - Proibição de push direto na branch `main`.

---

## 4. Publicação Web e Documentação Pública

Define onde e como a documentação estática e sites públicos dos projetos são hospedados.

* **Plataforma de Hospedagem:** {{Cloudflare Workers / GitHub Pages / Codeberg Pages / Netlify / Vercel / Nginx}}
* **Armazenamento Canônico de Artefatos & Binários:** {{Cloudflare R2 / S3-compatible Object Storage}}
* **Estrutura Local de Arquivos Web:** Diretório `./site` na raiz do repositório.
* **Padrão de Domínio / Subdomínio:** `https://<projeto>.{{seu-dominio.tld}}`
* **Cabeçalhos de Segurança (CSP / HSTS):** Declarados em `./site/_headers` ou na configuração do servidor web.
* **Higiene de Branches de Deploy (Stateless Force Push):** {{Worktree órfã de commit único com git push --force para evitar acúmulo de histórico}}
* **Estratégia de Redundância / Fallback:** {{Ex: deploy secundário em Pages da forja caso o CDN primário fique indisponível}}

---

## 5. Ferramental Padrão de Qualidade e Testes por Stack

Para cada linguagem suportada pelo seu perfil, especifique as ferramentas obrigatórias para atender às exigências de qualidade GOST (cobertura $\ge 90\%$ e zero warnings de análise estática).

### 5.1 {{Linguagem 1: ex. Rust}}
* **Test Runner:** `cargo test`
* **Cobertura de Código:** `cargo-tarpaulin` ou `llvm-cov` (mínimo obrigatório: $\ge 90\%$)
* **Testes de Mutação:** `cargo-mutants`
* **Linter & Formatação:** `clippy -D warnings` e `cargo fmt --check`

### 5.2 {{Linguagem 2: ex. PHP}}
* **Test Runner & Cobertura:** `pest --coverage --min=90` (ou `phpunit`)
* **Testes de Mutação:** `infection`
* **Linter & Formatação:** `phpstan analyse --level=max` e `pint --test`

### 5.3 {{Linguagem 3: ex. Shell / POSIX}}
* **Test Runner & Cobertura:** `shellspec` com `kcov` ($\ge 90\%$)
* **Linter & Formatação:** `shellcheck` e `shfmt -d`

### 5.4 Testes de Interface e Ponta a Ponta (E2E)
* **Ferramenta E2E:** {{Playwright / Cypress / Puppeteer}}

### 5.5 Validação Prévia Local Idêntica ao CI
* **Ferramenta de Execução Local:** {{`act` para workflows Dockerizados / `make test` / task runner}}

---

## 6. Pipeline de CI/CD

Define os arquivos e etapas de automação executados na forja remota.

* **Localização do Workflow:** {{Ex: `.forgejo/workflows/ci.yml` ou `.github/workflows/ci.yml`}}
* **Etapas Obrigatórias (Jobs):**
  1. `lint`: Análise estática com flag de Zero Warnings.
  2. `test`: Execução completa da suíte de testes unitários e de integração com medição de cobertura ($\ge 90\%$).
  3. `mutation`: Execução periódica ou por PR de testes de mutação.
  4. `deploy`: Publicação automatizada da pasta `./site` apenas após sucesso absoluto dos jobs anteriores.

---

## 7. Registro no Catálogo Central e Descoberta

Define o mecanismo pelo qual novos repositórios são catalogados e indexados para descoberta local ou corporativa.

* **Arquivo / Registro Central:** {{Ex: `~/src/catalog.json` local ou serviço de catálogo remoto}}
* **Campos Obrigatórios no Registro:**
  - `name`: Nome do projeto.
  - `forge`: Identificador da forja (`codeberg`, `github`, `gitlab`).
  - `slug`: Namespace e repositório (`<org>/<repo>`).
  - `description`: Resumo conciso de objetivo.
  - `topics`: Lista de palavras-chave padronizadas (incluindo `gost`).
  - `license`: Identificador SPDX da licença.
  - `website`: URL pública do site/docs.

---

## 8. Mapeamento do Ciclo DD-TDD e Comandos Operacionais

Define como o fluxo de Document-Driven e Test-Driven Development opera no ecossistema.

* **Rastreabilidade:** Ticket $\to$ Especificação/Documentação $\to$ Teste falhando $\to$ Implementação $\to$ Cobertura/Docs final $\to$ Fechamento de ticket.
* **Comandos Mnemônicos para Assistentes/Agentes de IA:**
  - `DCPD`: Do, Commit, Push, Deploy (implementação, testes, commit com `closes #ID`, push e deploy).
  - `DCP`: Do, Commit, Push (restrito à branch da issue, gerando URL do PR).
  - `PLAN`: Pesquisa e proposta de solução sem alteração de código.
  - `TDD`: Execução estrita do ciclo com commits granulares de docs, teste quebrado e código.
  - `AUDIT`: Execução de linters rigorosos, cobertura e mutação sem alterações.
  - `FIX`: Correção cirúrgica de avisos de formatação e análise estática.

---

## 9. Internacionalização (i18n)

Define os padrões de suporte a múltiplos idiomas em sites e aplicativos.

* **Língua Primária:** {{`pt-BR` / `en` / etc.}}
* **Estrutura de Arquivos Estáticos:** Matriz de pastas sob `./site/<lang>/` com roteador estático em `./site/index.html`.
* **Suporte a RTL:** Suporte a escrita da direita para a esquerda quando o idioma exigir (ex: `./site/ar/`).

---

## 10. Banners e Cards Sociais (Open Graph)

Define as diretrizes para compartilhamento em redes e prévias visuais.

* **Dimensão Canônica:** `1200x630` pixels em formato PNG.
* **Safe Zone Central:** `4:3` (840x630 centralizada) garantindo legibilidade sem cortes em telas móveis e feeds sociais.
* **Automação de Geração:** {{Script local em Python/Node/Shell gerando `./site/assets/og_preview.png`}}.

---

## 11. Arquitetura Pragmática & Estrutura de Diretórios

Define a organização de pastas recomendada para manter código desacoplado e hermético.

* **Separação de Camadas:**
  - Domínio puro / regras de negócio: `src/domain/` (sem dependências de I/O externo).
  - Adaptadores e infraestrutura: `src/adapters/` ou `src/infrastructure/` (bancos de dados, rede, CLI).
* **Fakes em Memória:** Implementação obrigatória de dublês em memória para dependências externas, permitindo testes rápidos e herméticos sem banco ou rede.

---

## 12. Padrões de Sistema e Containers

Define a conformidade operacional do ambiente Unix e conteinerização.

* **Diretórios XDG:** Resolução estrita com fallbacks:
  - Configuração: `$XDG_CONFIG_HOME` (fallback: `~/.config`)
  - Dados: `$XDG_DATA_HOME` (fallback: `~/.local/share`)
  - Estado: `$XDG_STATE_HOME` (fallback: `~/.local/state`)
  - Cache: `$XDG_CACHE_HOME` (fallback: `~/.cache`)
* **Arquivos de Configuração:** Sintaxe simples e plana baseada em variáveis (`CHAVE=VALOR`).
* **Containers Mínimos:**
  - Dockerfiles multi-stage.
  - Imagens finais de produção mínimas (ex: `scratch` para binários estáticos, `alpine` sem root para runtimes dinâmicos).
