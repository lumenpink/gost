# GOST-005 — ZERO-BINARIES-IN-GIT

## Severidade
`ERROR` (Bloqueante)

## Escopo
`git-history`

## Descrição do Requisito
Tolerância zero a arquivos binários compilados (.apk, .exe, .so, .bin, .dll, .dylib) versionados no git.

## Caso Prático de Erro
O motor de governança emite `[FAIL] GOST-005` quando qualquer arquivo com extensão de binário compilado for encontrado sob rastreamento do Git.

## Como Resolver
1. Remova o artefato binário do rastreamento do Git (`git rm --cached <arquivo>`).
2. Adicione a extensão ou diretório no arquivo `.gitignore`.
3. Re-execute o comando de verificação para certificar-se da integridade do repositório.

## Desativação Declarativa
Regras fundamentais de integridade constitucional não admitem desativação declarativa arbitrária.
