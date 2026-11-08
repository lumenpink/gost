# GOST-004 — COMMIT-PHASE-TAGGING

## Severidade
`ERROR` (Bloqueante)

## Escopo
`git`

## Descrição do Requisito
Commits de feat e fix devem referenciar a fase DD-TDD e a tag do ticket correspondente.

## Caso Prático de Erro
O motor de governança emite `[FAIL] GOST-004` quando a condição da regra é violada durante a auditoria local ou na esteira de integração contínua.

## Como Resolver
1. Inspecione o diagnóstico retornado pelo comando de verificação.
2. Ajuste o arquivo ou estrutura indicada para atender ao padrão canônico exigido pela norma.
3. Re-execute o comando de verificação local para certificar-se da conformidade.

## Desativação Declarativa
Caso este projeto possua uma deliberação formal justificando a isenção desta regra, declare seu identificador em `.gost/config`:
```ini
DISABLED_RULES = GOST-004
```
