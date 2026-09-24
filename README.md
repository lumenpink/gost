# GOST (ГОСТ) — Padrão Técnico para Repositórios Abertos

> **Norma Técnica Unificada para Repositórios, Governança, Ciclo de Desenvolvimento e Documentação Pública.**

O **GOST** (*General Open Source Standard*, inspirado nos históricos padrões técnicos ГОСТ) é uma especificação aberta que estabelece os requisitos mínimos de higiene, arquitetura de arquivos, rastreabilidade de desenvolvimento e publicação de documentação para novos projetos.

---

## 📑 Documentos da Especificação

* **[Norma Técnica Universal (`SPEC.md`)](./SPEC.md)**: A especificação normativa completa, agnóstica a fornecedores e tecnologias (requisitos de licenciamento, anatomia da raiz, ciclo DD-TDD, CI/CD e vitrine estática).
* **[Perfil Lumen (`profiles/lumen.md`)](./profiles/lumen.md)**: O perfil de implementação concreto do ecossistema Lumen (Codeberg/Forgejo, CLI `cccp`, deploy em `*.2lp.in` via Cloudflare Workers e registro no `catalog.json`).

---

## ⚡ Pilares da Especificação

### 1. Filosofia de Licenciamento
* **Presunção Padrão:** **`The Unlicense`** (dedicação direta ao domínio público, sem atritos burocráticos).
* **Exceção Estratégica:** **`GPLv3`** (ou `AGPL-3.0`) para projetos que exigem salvaguarda explícita contra fechamento ou comercialização predatória.

### 2. O Ciclo de Desenvolvimento (DD-TDD)
O fluxo padrão de trabalho impõe rastreabilidade em 5 etapas estritas orientadas a commits:

1. **Ticket / Issue:** Formalização do problema ou requisito no issue tracker.
2. **Doc in develop (Commit):** Documentação prévia do comportamento e arquitetura antes de escrever código.
3. **Failing Test (Commit):** Criação de teste automatizado comprovando o bug ou a ausência da funcionalidade (**deve falhar**).
4. **Fix / Implement (Commit):** Código mínimo que faz o teste passar.
5. **Finish Docs & Close (Commit):** Polimento final da documentação pública e encerramento formal do ticket.

### 3. Vitrine Pública Obrigatória
Todo repositório expõe sua documentação pública em `./site/` com cabeçalhos de segurança HTTP em `site/_headers`, publicada continuamente via CI/CD.

---

## 🚀 Como Iniciar um Novo Projeto (Perfil Lumen)

Consulte o passo a passo completo no [Perfil Lumen](./profiles/lumen.md):
1. Crie o repositório remoto no Codeberg via API.
2. Inicialize o git local (`git init -b main`).
3. Crie os arquivos base (`.cccprc`, `.gitignore`, `VERSION`, `CHANGELOG.md`, `LICENSE`, `wrangler.jsonc`, `site/`).
4. Execute `cccp install` para ativar os hooks de validação e release.
5. Registre no catálogo central `~/src/catalog.json`.

---

## 🌐 Documentação Online

A documentação estática desta especificação está publicada em:
👉 **[https://gost.2lp.in](https://gost.2lp.in)**

---

## 📄 Licença

Este projeto e toda a especificação GOST são dedicados ao domínio público sob a [The Unlicense](./UNLICENSE).
