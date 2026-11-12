# Especificação Técnica — Ticket #39: Atualizar Papéis Abstratos na Especificação Fundamental

## 1. Contexto & Motivação
A especificação fundamental GOST constitui o nível estratégico e constitucional do ecossistema de software aberto. Como metanorma perene e de neutralidade tecnológica, ela deve fixar princípios, regras de governança, gramática de requisitos e papéis abstratos sem conter dependências ou menções nominais a ferramentas utilitárias concretas (como `cccp`, `gossnab` ou `lunokhod`).

## 2. Decisão Arquitetural
- **Definição Explícita da Tríade de Papéis Abstratos:**
  1. *Maestro Local:* Orquestra o ciclo de vida local do repositório, execução das fases DD-TDD, interceptação de convenções de commit, higiene e integração de branches.
  2. *Autoridade de Forja e Abastecimento:* Gerencia a comunicação com forjas remotas, consulta e ciclo de vida de tickets, triagem assistida, inventário e operações de catálogo multi-repositório.
  3. *Motor de Avaliação Normativa:* Avalia regras declarativas (`rules.toml`), laudos de conformidade e testes de sanidade em tempo de execução.
- **Expurgo Nominal:** Removidas todas as referências diretas aos nomes concretos de ferramentas (`cccp`, `lunokhod`, `gossnab`) dos textos de `SPEC.md` e `specs/pt/SPEC.md`.

## 3. Alternativas Descartadas (Para a Natasha)
- **Alternativa Descartada 1: Citar nomes de ferramentas a título exemplificativo na especificação fundamental.**
  *Motivo do Descarte:* Introduz acoplamento conceitual desnecessário e contamina a neutralidade perene da metanorma fundamental. As amarrações concretas de binários pertencem estritamente à camada operacional (`lilya`).
- **Alternativa Descartada 2: Manter os papéis abstratos implícitos.**
  *Motivo do Descarte:* Geraria ambiguidade na delegação de competências entre o maestro de ciclo local e a autoridade de forjas/abastecimento.

## 4. Verificação
- Verificação de ausência de termos concretos via regex `cccp|gossnab|lunokhod`.
- Sincronização estrita de `specs/pt/SPEC.md` com `SPEC.md`.
