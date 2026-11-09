# GOST-001 — GOSTVER-FILE-REQUIRED

## Severidade
`ERROR` (Bloqueante)

## Escopo
`root`

## Descrição do Requisito
O repositório deve conter um arquivo GOSTVER não vazio no diretório raiz declarando a especificação GOST adotada.

## Caso Prático de Erro
O motor de governança emite `[FAIL] GOST-001` quando o arquivo `GOSTVER` não é encontrado na raiz do projeto ou quando o seu conteúdo está vazio.

## Como Resolver
1. Crie o arquivo `GOSTVER` na raiz do repositório.
2. Declare a versão canônica do GOST e os perfis vinculados ao projeto (ex.: `3.0.0`).
3. Re-execute o comando de verificação para certificar-se da conformidade.

## Desativação Declarativa
Regras fundamentais de integridade constitucional não admitem desativação declarativa arbitrária.
