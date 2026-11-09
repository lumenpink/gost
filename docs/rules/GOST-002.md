# GOST-002 — LICENSE-FILE-REQUIRED

## Severidade
`ERROR` (Bloqueante)

## Escopo
`root`

## Descrição do Requisito
O repositório deve conter um arquivo LICENSE não vazio no diretório raiz declarando os termos de licenciamento do software.

## Caso Prático de Erro
O motor de governança emite `[FAIL] GOST-002` quando o arquivo `LICENSE` está ausente na raiz ou tem tamanho zero.

## Como Resolver
1. Adicione a licença de software apropriada (ex.: AGPL-3.0, MIT, Apache-2.0) no arquivo `LICENSE` na raiz.
2. Certifique-se de que o arquivo contém o texto integral da licença.
3. Re-execute o comando de verificação para validar a conformidade.

## Desativação Declarativa
Regras fundamentais de integridade constitucional não admitem desativação declarativa arbitrária.
