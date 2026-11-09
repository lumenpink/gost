# Especificação Técnica — Saneamento do Catálogo de Regras Fundamentais GOST 3.0 (#37)

## 1. Contexto e Motivação
A norma GOST v3.0 adota o Princípio da Tríade Normativa Fechada com quatro tiers rigorosamente estratificados:
1. **Tier 1 (GOST):** Axiomas Fundamentais universais de integridade do repositório.
2. **Tier 2 (GOSPLAN):** Diretrizes Estratégicas e fluxo de trabalho (DD-TDD, governança de tickets, documentação viva).
3. **Tier 3 (KOLLONTAI):** Decretos Regulamentadores de Engenharia (parâmetros técnicos, OpenAPI, limites de linhas, linter, Docker/Compose, i18n).
4. **Tier 4 (LILYA):** Portarias Operacionais da Tulipa (regras idiossincráticas de fábrica, proibição de prefixo 'v', identidade travesti).

Anteriormente, o `specs/rules.toml` da GOST continha regras táticas e operacionais (como formatação de branch, commits, relatórios de fechamento, linters e cabeçalhos de site), violando a pureza do Tier Fundamental.

---

## 2. Requisitos Mandatórios

### 2.1 Cinco Axiomas Fundamentais (GOST-001 a GOST-005)
O `specs/rules.toml` conterá estritamente os 5 axiomas universais:
1. **GOST-001 (`GOSTVER-FILE-REQUIRED`):** Existência de arquivo `GOSTVER` não-vazio na raiz do repositório.
2. **GOST-002 (`LICENSE-FILE-REQUIRED`):** Existência de arquivo `LICENSE` não-vazio na raiz do repositório.
3. **GOST-003 (`VERSION-SEMVER-SYNTAX`):** Arquivo `VERSION` com sintaxe válida segundo SemVer 2.0.0.
4. **GOST-004 (`README-FILE-REQUIRED`):** Existência de arquivo `README.md` não-vazio na raiz do repositório.
5. **GOST-005 (`ZERO-BINARIES-IN-GIT`):** Ausência de artefatos binários compilados (`.apk`, `.exe`, `.so`, `.bin`, `.dll`, `.dylib`) no repositório Git.

### 2.2 Numeração Estritamente Tridigital
- Todos os identificadores seguem a expressão regular `^GOST-\d{3}$`.
- Sem sufixos alfabéticos (proibido `003A` ou `003B`).
- Contagem reiniciada em 001.

### 2.3 Paridade de Localização e Documentação Individual
- `specs/locales/pt-br.toml` com descrição e mensagens para cada regra GOST-001 a GOST-005.
- `docs/rules/GOST-001.md` a `docs/rules/GOST-005.md` com as seções `## Severidade`, `## Caso Prático de Erro` e `## Como Resolver`.
