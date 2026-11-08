# Especificação Técnica: Documentação Individual de Casos de Erro e Solução das Regras

- **Ticket:** [#34](https://gambi.2lp.in/lumen/gost/issues/34)
- **Status:** Proposto / Em Desenvolvimento
- **Tier:** Fundamental
- **Norma:** GOST v3.0.0

---

## 1. Contexto e Motivação
Na Metanorma Fundamental GOST v3.0.0, toda regra de auditoria deve ser autoexplicativa e resolúvel.
Quando o motor de governança acusa inconformidade (`[FAIL] GOST-NNN`), a desenvolvedora deve ter acesso imediato a:
1. Resumo claro do requisito.
2. Severidade da regra (`error` ou `warning`).
3. Caso prático de desconformidade que engatilha o erro.
4. Passo a passo exato para sanar o problema e restabelecer a conformidade.
5. Diretrizes para desativação autorizada via `DISABLED_RULES` ou uso excepcional de `--force`.

---

## 2. Anatomia Canônica da Documentação de Regra (`docs/rules/GOST-NNN.md`)

Todo documento de regra individual DEVE conter:
- `# GOST-NNN — [NOME DA REGRA]`
- `## Severidade`: `Bloqueante (Error)` ou `Recomendação (Warning)`.
- `## Escopo`: Contexto de aplicação (`root`, `src`, `doc`, `ci`, `git`).
- `## Descrição do Requisito`: Explicação da fundamentação da regra.
- `## Caso Prático de Erro`: Exemplo real de código ou estrutura que causa a falha.
- `## Como Resolver (Passo a Passo)`: Ações corretivas recomendadas.
- `## Desativação Declarativa`: Instrução de como dispensar via `DISABLED_RULES` em `.gost/config`.
