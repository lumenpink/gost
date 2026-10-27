# GOST — Padrão Técnico para Repositórios Abertos

> **Norma Técnica Canônica para Arquitetura de Repositórios, Governança, Ciclo DD-TDD e Qualidade de Software.**

O **GOST** (General Open Source Standard) é uma especificação aberta que estabelece requisitos de higiene de diretórios, metadados canônicos, governança via Maestro CLI e o ciclo rigoroso de **Documentation-Driven & Test-Driven Development (DD-TDD)** em 9 fases determinísticas.

---

## 📑 Navegação e Especificações

* **[Norma Técnica Canônica (`SPEC.md`)](./SPEC.md)**: Especificação normativa completa (v2.0.0).
* **[Regras Determinísticas (`specs/rules.json`)](./specs/rules.json)**: Catálogo auditável de regras e política de waivers.
* **[Módulos por Linguagem (`specs/languages/`)](./specs/languages/)**:
  - [Rust](./specs/languages/rust.md) • [Go](./specs/languages/go.md) • [Python](./specs/languages/python.md) • [PHP](./specs/languages/php.md) • [JavaScript/TypeScript](./specs/languages/javascript.md) • [POSIX Shell](./specs/languages/shell.md) • [R](./specs/languages/r.md)
* **[Perfis de Implementação (`profiles/`)](./profiles/)**: Especialização de infraestrutura e ferramentas por ecossistema.
* **[Vitrine Web (`site/`)](./site/)**: Ponto de entrada estático e documentação pública.

---

## 🏛️ Governança e Metadados

1. **O Maestro de Governança:** Ponto único de entrada CLI (`init`, `ticket`, `commit`, `hygiene`, `close`, `merge`, `push`). Comandos manuais de Git são proibidos no fluxo diário.
2. **Ciclo DD-TDD (9 Fases):** Ticket $\to$ Branch $\to$ Spec $\to$ Red $\to$ Green $\to$ Refactor $\to$ Mutation $\to$ Hygiene $\to$ Close (com Laudo Textual de Resolução). Fast-tracks formais para `docs` e `chore`.
3. **Manifesto `.gost/metadata.json`:** Autoridade central de metadados para identificação, taxonomia e vitrine pública.
4. **Pureza de Domínio (GOST-27):** Zero I/O no Core de negócio e adaptadores em memória obrigatórios para testes instantâneos.

---

## 📄 Licenciamento e Mapeamento de Satélites

* **Especificação Técnica e Textos Normativos:** [CC-BY-SA-4.0](./LICENSE).
* **Esquemas JSON, Metadados e Templates:** [CC0-1.0](https://creativecommons.org/publicdomain/zero/1.0/).
* **Identidade Visual, Insígnias e Marcas (`site/assets/`, `LICENSE-LOGO`):** [CC-BY-ND-4.0](./LICENSE-LOGO).
