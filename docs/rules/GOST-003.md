# GOST-003 — VERSION-SEMVER-SYNTAX

## Severidade
`ERROR` (Bloqueante)

## Escopo
`root`

## Descrição do Requisito
O arquivo `VERSION` na raiz deve conter uma versão válida segundo a especificação SemVer 2.0.0.

## Caso Prático de Erro
O motor de governança emite `[FAIL] GOST-003` quando o arquivo `VERSION` está ausente, vazio ou não segue a sintaxe de versão semântica (`MAJOR.MINOR.PATCH`).

## Como Resolver
1. Inspecione o arquivo `VERSION` na raiz do projeto.
2. Certifique-se de que contém uma versão semântica válida (ex.: `1.0.0`).
3. Re-execute o comando de verificação para validar a conformidade.

## Desativação Declarativa
Regras fundamentais de integridade constitucional não admitem desativação declarativa arbitrária.
