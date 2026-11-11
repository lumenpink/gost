# GOST-001 — RULES-PROFILE-REQUIRED

## Severidade
`ERROR` (Bloqueante)

## Escopo
`root`

## Descrição do Requisito
O repositório deve conter um arquivo `.rules/profile.toml` não vazio declarando seu perfil normativo.

## Caso Prático de Erro
O motor de governança emite `[FAIL] GOST-001` quando o arquivo `.rules/profile.toml` não é encontrado no projeto ou quando o seu conteúdo está vazio.

## Como Resolver
1. Crie o arquivo `.rules/profile.toml` no repositório.
2. Declare a URL do perfil e a versão adotada (ex.: `url = "https://lilya.2lp.in"`, `version = "2.1.0"`).
3. Re-execute o comando de verificação para certificar-se da conformidade.

## Desativação Declarativa
Regras fundamentais de integridade constitucional não admitem desativação declarativa arbitrária.
