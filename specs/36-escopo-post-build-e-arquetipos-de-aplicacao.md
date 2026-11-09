# Especificação Técnica — Ticket #36: Escopo `post-build` e 4 Arquétipos de Aplicação

## 1. Escopo Canônico `post-build` (Seção 16 do SPEC.md)
O escopo `post-build` é o quinto escopo formal de avaliação de regras do padrão GOST v3.0.0.
- **Momento:** Disparado imediatamente após a compilação ou geração de artefatos executáveis ou empacotados.
- **Contexto:** Recebe os artefatos gerados em `target/debug`, `target/release`, `dist/` ou caminhos configurados.
- **Responsabilidades:**
  1. *Smoke tests* de execução rápida (validação de encerramento sem `SIGSEGV` ou *panics* imediatos).
  2. Integridade de ligação dinâmica (*dynamic linking* / bibliotecas compartilhadas ausentes).
  3. Conformidade das interfaces de utilidade (`--help`, `--version` estritamente idêntico ao `VERSION`/`Cargo.toml` e subcomandos de ciclo de vida).

## 2. Tipologia Canônica dos 4 Arquétipos de Aplicação (Seção 9 do SPEC.md)
O metadado `APP_TYPE` no `GOSTVER` (ou frontmatter do projeto) formaliza a natureza da aplicação:
1. `web` — **Webapps Autônomas e Autorais** (*ex: Navalha, Lírica*): A interface gráfica web é a própria vitrine e frontpage. Liberdade estética e de manifesto total. Documentação técnica embutida sob rota `/docs/` ou subdiretório `docs/`.
2. `hybrid` — **Aplicações Híbridas** (*ex: Lacraia, Lauda*): O foco é o binário/serviço, acompanhado de interface web por conveniência. A frontpage apresenta o produto e documentação de usuário (`docs/user/`), dedicando uma pasta/rota (`web/`) para a webapp.
3. `binary` — **Utilitários Binários Puros** (*ex: CCCP, Kombinat, Lunokhod*): Sem interface web. Site institucional 100% gerado automaticamente pelo SSG Tachinha a partir de metadados, `README.md`, `docs/user/`, `docs/dev/` e `SPEC.md`.
4. `manifesto` — **Documentações e Manifestos Puros** (*ex: GOST, Travesti*): Aplicações puramente textuais e normativas, sem compilação binária. O SSG Tachinha compila em formato editorial de alta legibilidade.
