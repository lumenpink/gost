# GOST (ГОСТ) — Padrão Técnico para Repositórios Abertos

> **Norma Técnica Unificada para Repositórios, Governança, Ciclo de Desenvolvimento e Documentação Pública.**

O **GOST** (*General Open Source Standard*, inspirado nos históricos padrões técnicos ГОСТ) é uma especificação aberta que estabelece os requisitos mínimos de higiene, arquitetura de arquivos, rastreabilidade de desenvolvimento, padrões operacionais e publicação de documentação para novos projetos.

---

## 📑 Estrutura da Especificação e Plataforma

* **[Norma Técnica Universal (`SPEC.md`)](./SPEC.md)**: A especificação normativa completa consolidada.
* **[Especificações por Idioma & Normas Modulares (`specs/`)](./specs/)**:
  - **[Português (`specs/pt/SPEC.md`)](./specs/pt/SPEC.md)**: Fonte primária em Português.
  - **[English (`specs/en/SPEC.md`)](./specs/en/SPEC.md)**: Canonical international technical baseline.
  - **[Política & Arquitetura de Licenciamento (`specs/legal/licenses.md`)](./specs/legal/licenses.md)**: Matriz de perfis, licença raiz e satélites.
  - **[Regras como Dado (`specs/rules.json`)](./specs/rules.json)**: Schema de validação formal consumível por linters e CLI (`cccp`).
* **[Módulos Técnicos por Linguagem (`specs/languages/`)](./specs/languages/)**:
  - **[PHP (`specs/languages/php.md`)](./specs/languages/php.md)**: Pest, PHPStan (max), Pint, Infection, Composer.
  - **[Rust (`specs/languages/rust.md`)](./specs/languages/rust.md)**: Cargo test, Clippy, rustfmt, cargo-mutants, Tarpaulin/llvm-cov.
  - **[POSIX Shell (`specs/languages/shell.md`)](./specs/languages/shell.md)**: ShellSpec, kcov, ShellCheck, shfmt, XDG nativo.
  - **[JavaScript / TypeScript (`specs/languages/javascript.md`)](./specs/languages/javascript.md)**: Biome/Prettier, Playwright E2E, Lockfiles.
  - **[R (`specs/languages/r.md`)](./specs/languages/r.md)**: testthat, covr, lintr, styler, renv (Twelve-Factor R reprodutível).
* **[Guias de Migração (`upgrades/`)](./upgrades/)**: Diff e passos de transição entre versões (ex: [de 0.1 para 1.0.0](./upgrades/from-0.1-to-1.0.md)).
* **[Perfil Lumen (`profiles/lumen.md`)](./profiles/lumen.md)**: O perfil de implementação concreto do ecossistema Lumen (Codeberg/Forgejo, CLI `cccp`, deploy em `*.2lp.in` via Cloudflare Workers e registro no `catalog.json`).

---

## 🏷️ Como Declarar Conformidade em Aplicações (`GOSTVER`)

Repositórios desenvolvidos sob o padrão GOST **não copiam a norma inteira**. Eles mantêm seu próprio `SPEC.md` de regras de negócio da aplicação e declaram conformidade com a norma através do arquivo **`GOSTVER`** na raiz, especificando opcionalmente as linguagens ativas para carregar apenas os módulos necessários (anti-bloat):

```bash
# GOSTVER — Declaração de Conformidade com o Padrão GOST
GOST_VERSION="1.0.0"
GOST_PROFILE_URL="https://codeberg.org/lumenpink/profiles/raw/branch/main/lumen.md"
GOST_LANGUAGES="php,javascript"   # Baixa apenas php.md e javascript.md em .gost/languages/
```

O CLI `cccp` utiliza essas variáveis para sincronizar o cache local em `.gost/` e auditar a conformidade técnica do repositório (`cccp gost check`).

---

## ⚡ Pilares da Especificação

### 1. Filosofia de Licenciamento & Arquitetura Modular
* **Princípio da Menor Permissividade:** O arquivo raiz `LICENSE` define a licença padrão do repositório (GPLv3 para apps, Apache-2.0 para comrades/libs, CC-BY-SA para specs).
* **Satélites Canônicos:** Exceções declaradas e mapeadas no `README.md` (`LICENSE-MEDIA`, `LICENSE-LOGO`, `LICENSE-APACHE`).
* **Anti-Boilerplate:** Cada repositório implementa estritamente o seu perfil real, sem textos genéricos desnecessários.

### 2. O Ciclo de Desenvolvimento (DD-TDD) & Tickets Obrigatórios
* **Zero Commits sem Ticket:** Nenhum commit é aceito sem referência formal a um ticket (`(ref #<id>)` nos intermediários e `(closes #<id>)` na finalização). Hooks locais bloqueiam commits soltos.
* **Branches por Ticket:** Desenvolvimento estritamente isolado em `feat/<id>-<slug>` ou `fix/<id>-<slug>`. Proibido commitar na `main`.
* **As 5 Etapas:** Ticket $\to$ Doc in develop $\to$ Failing Test $\to$ Fix / Implement $\to$ Finish Docs & Close.
* **Protocolo para Agentes de IA:** Comandos mnemônicos determinísticos (`DCPD`, `DCP`, `PLAN`, `TDD`, `AUDIT`, `FIX`, `RELEASE`).

### 3. Estratégia e Qualidade de Testes
* **Pirâmide Completa:** Validação em camadas com testes unitários, funcionais, de integração e E2E (via **Playwright**).
* **Cobertura Rígida:** Piso obrigatório mantido permanentemente em **> 90%** (quebrando o CI em caso de regressão), com foco contínuo em alcançar **100%**.
* **Testes de Mutação & Hermeticidade:** Validação qualitativa dos asserts contra falsos positivos e isolamento absoluto de rede externa.

### 4. Análise Estática & Tolerância Zero a Avisos
* **Zero Warnings:** Linters e compiladores executam com flags equivalentes a `-D warnings`. Qualquer aviso pendente quebra o build.
* **Anti-Bloat & Segurança:** Dependências externas mínimas e justificadas no ticket com auditoria automática contínua.

### 5. Arquitetura de Domínio & SOLID Pragmático
* **Portas & Adaptadores (DIP):** Desacoplamento estrito entre o Core e I/O.
* **In-Memory Fakes:** Testes unitários herméticos rodando em microssegundos sem mocks dinâmicos pesados.
* **Parse, Don't Validate:** Validação na borda com tipos primitivos confiáveis no Core e Enums nativos para máquinas de estado.

### 6. Padrões de Sistema, 12-Factor & Containers OCI
* **XDG Base Directory:** Conformidade obrigatória com fallbacks universais (`~/.config`, `~/.local/share`, `~/.local/state`, `~/.cache`, `/run/user/$UID`).
* **Precedência de Config:** Flags > Env > `.env` > Config Local > XDG Config > `/etc` > Defaults. Formato plano `CHAVE=VALOR` amigável a POSIX Shell.
* **Twelve-Factor Universal:** Princípios aplicados a daemons, microsserviços e ferramentas de terminal.
* **Streams Unix & NO_COLOR:** `stdout` puro para dados, `stderr` para logs; suporte nativo a `NO_COLOR` e detecção de TTY.
* **Containers OCI:** Multi-stage obrigatório com imagens base mínimas (`scratch`/`alpine`), execução non-root (`USER 1000:1000`), banimento de `:latest` e padrão `compose.yaml`.

### 7. Vitrine Pública & Internacionalização
* **Vitrine `./site/`:** Publicação estática contínua na borda com cabeçalhos de segurança HTTP.
* **Matriz das 10 Línguas:** Paridade total nas 10 línguas oficiais (`en`, `pt`, `es`, `fr`, `de`, `it`, `ru`, `zh`, `ja`, `ar`) e suporte a RTL.
* **Cards Sociais KokoroSim:** Banners em 1200x630 com Safe Zone 4:3 centralizada contra recortes móveis.

---

## 🚀 Como Iniciar um Novo Projeto (Perfil Lumen)

Consulte o passo a passo completo no [Perfil Lumen](./profiles/lumen.md):
1. Crie o repositório remoto no Codeberg via API.
2. Inicialize o git local (`git init -b main`).
3. Crie os arquivos base (`GOSTVER`, `.cccprc`, `.gitignore`, `VERSION`, `CHANGELOG.md`, `LICENSE`, `wrangler.jsonc`, `site/`).
4. Execute `cccp install` para ativar os hooks de validação e release.
5. Registre no catálogo central `~/src/catalog.json`.

---

## 🌐 Documentação Online

A documentação estática desta especificação está publicada em:
👉 **[https://gost.2lp.in](https://gost.2lp.in)**

---

## 📄 Licença

* **Especificação Técnica e Textos Normativos:** Licenciados sob [Creative Commons Atribuição-CompartilhaIgual 4.0 Internacional (CC-BY-SA 4.0)](./LICENSE).
* **Esquemas JSON, Metadados e Templates de Configuração:** Dedicados ao domínio público sob [Creative Commons Zero 1.0 Universal (CC0-1.0)](https://creativecommons.org/publicdomain/zero/1.0/).
* **Identidade Visual, Insígnias e Escudo GOST:** Licenciados sob [Creative Commons Atribuição-SemDerivações 4.0 Internacional (CC-BY-ND 4.0)](./LICENSE-LOGO).
