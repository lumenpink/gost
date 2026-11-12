---
standard: "gost"
tier: "fundamental"
version: "3.0.0"
locale: "pt-br"
authority: "Standards Committee"
published_at: "2026-11-07"
---

# GOST — Metanorma Fundamental para Repositórios Abertos
**Versão da Norma:** `3.0.0`  
**Status:** Oficial / Metanorma Fundamental  
**Referência:** ГОСТ (Государственный Стандарт / General Open Source Standard)

---

## 1. Escopo e Propósito

Esta especificação define a **Metanorma Fundamental** do ecossistema, estabelecendo a teoria geral das normas, a hierarquia de camadas, a gramática de requisitos, a anatomia documental canônica e as garantias de governança e integridade aplicáveis universalmente a repositórios de software aberto.

A GOST opera sob o princípio da neutralidade tecnológica perene: ela positiva as regras de validade, delegação e controle sem vincular-se a ferramentas utilitárias efêmeras ou tecnologias particulares.

As palavras-chave **DEVE** (*MUST*), **NÃO DEVE** (*MUST NOT*), **DEVERIA** (*SHOULD*), **NÃO DEVERIA** (*SHOULD NOT*) e **PODE** (*MAY*) neste documento devem ser interpretadas conforme descrito na [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

---

## 2. Teoria Geral das Normas e Hierarquia em Quatro Camadas

O ordenamento regulatório do ecossistema estrutura-se em quatro esferas subordinadas e interdependentes:

1. **Camada Fundamental (`tier: fundamental`):**
   - Papel constitucional e meta-regulatório do ecossistema (GOST).
   - Estabelece as regras sobre a criação, vigência, formato, tipicidade e controle de todas as normas subordinadas.
2. **Camada Estratégica (`tier: strategic`):**
   - Define o planejamento plurianual, filosofia de desenvolvimento, autonomia popular e metodologia de ciclo de vida (ex.: ciclo DD-TDD de 9 fases e protocolo do Dia Zero).
3. **Camada Tática (`tier: tactical`):**
   - Fixa as toolchains homologadas de engenharia, interfaces de interoperabilidade e contratos universais de CLI.
4. **Camada Operacional (`tier: operational`):**
   - Determina a infraestrutura concreta, topologia de storage, cotas de retenção, esteiras de deploy e serviços de suprimento/estado.
5. **Autonomia Local (`tier: local`):**
   - Regras e especificações customizadas do próprio repositório (`CUSTOM.md` e `custom-rules.toml`), respeitando os limites da hierarquia superior.

### 2.1 Princípio da Tríade Normativa Fechada
* Todo projeto regulado vincula-se formalmente a uma tríade imutável de normas: `Operacional X.Y.Z -> Tática A.B.C -> Estratégica D.E.F -> Fundamental G.H.I`.
* É vedada a vinculação a versões instáveis (`-dev.XX`), tags flutuantes (`latest`) ou o uso do prefixo `v` nas declarações de versão.
* A alteração de uma norma superior exige a emissão de nova versão imutável nas normas inferiores correspondentes, garantindo determinismo histórico e auditabilidade perene.

### 2.2 Anatomia Documental e Frontmatter Canônico
Todo documento normativo DEVE ser redigido em Markdown UTF-8 com Frontmatter YAML obrigatório em inglês declarando:
`standard`, `tier`, `version`, `locale`, `authority`, `published_at` e o bloco `inherits_from` com `base_url` canônica apontando para o portal público (`https://<norma>.2lp.in/<versao>/`).

---

## 3. Filosofia e Licenciamento

Todo projeto em conformidade com o GOST **DEVE** declarar sua licença de forma explícita na raiz do repositório através de um arquivo `LICENSE`. A especificação técnica detalhada, perfis e matriz normativa encontram-se em [specs/legal/licenses.md](./specs/legal/licenses.md).

### 2.1 Princípio da Menor Permissividade como Padrão Raiz
* **Regra da Raiz:** O arquivo `LICENSE` na raiz **DEVE** ser a licença padrão e geral de todo o repositório.
* Em repositórios com múltiplos tipos de artefatos (como monorepos ou aplicações híbridas), o arquivo `LICENSE` **DEVE** conter a licença menos permissiva (mais restritiva) adotada (ex: `GPL-3.0`).
* Quaisquer licenças mais permissivas (ex: `Apache-2.0` para sub-bibliotecas ou `CC-BY-SA-4.0` para mídias) funcionam como exceções modulares declaradas.

### 2.2 Tipologia por Perfil de Repositório
1. **Aplicações Completas / Monorepos Híbridos:** Adotam `GPL-3.0` (ou `AGPL-3.0` para serviços web) na raiz (`LICENSE`).
2. **Utilitários, Ferramentas Autônomas e Microapps:** Adotam `Apache-2.0` na raiz (`LICENSE`) diretamente, sem necessidade de arquivos satélites supérfluos.
3. **Bibliotecas, Protocolos e SDKs:** Adotam `Apache-2.0` na raiz (`LICENSE`) para máxima interoperabilidade.
4. **Especificações e Normas:** Adotam `CC-BY-SA-4.0` para os textos normativos na raiz (`LICENSE`), com esquemas e templates em `CC0-1.0` e marcas protegidas via satélite.

### 2.3 Arquivos Satélites Padronizados
Quando houver artefatos que exijam tratamentos jurídicos específicos, os seguintes arquivos canônicos **DEVEM** ser utilizados:
* `LICENSE-MEDIA`: Creative Commons Atribuição-CompartilhaIgual 4.0 Internacional (`CC-BY-SA-4.0`) para mídias, áudios, vídeos, fontes e ilustrações.
* `LICENSE-LOGO`: Creative Commons Atribuição-SemDerivações 4.0 Internacional (`CC-BY-ND-4.0`) para marcas, insígnias, ícones oficiais e logotipos.
* `LICENSE-APACHE`: Apache License 2.0 (`Apache-2.0`) para módulos, sub-crates ou bibliotecas desacopladas contidas em monorepos de aplicações.

### 2.4 Mapeamento Obrigatório no `README.md`
A presença de qualquer arquivo satélite (`LICENSE-MEDIA`, `LICENSE-LOGO` ou `LICENSE-APACHE`) **OBRIGA** a inclusão de uma seção explícita de mapeamento de diretórios e arquivos cobertos por cada licença no `README.md`.

### 2.5 Princípio Anti-Boilerplate
Cada repositório implementa exclusivamente as licenças condizentes com seu perfil real. É vedado copiar blocos genéricos de licenciamento e arquivos satélites vazios para projetos simples.

---

## 3. Anatomia Mínima da Raiz e Metadados

Todo repositório GOST **DEVE** conter em sua raiz a seguinte estrutura mínima independente da stack ou linguagem utilizada:

```text
.
├── GOSTVER                     # Declaração canônica de versão da norma e perfil
├── .gost/
│   └── metadata.json           # Manifesto SSOT de metadados do projeto (Regra GOST-26)
├── LICENSE                     # Termo legal de licenciamento padrão (Seção 2)
├── LICENSE-MEDIA               # (Opcional) Licença CC-BY-SA para mídias e assets
├── LICENSE-LOGO                # (Opcional) Licença CC-BY-ND para marcas e logos
├── LICENSE-APACHE              # (Opcional) Licença Apache-2.0 para bibliotecas internas
├── VERSION                     # Versão semântica em texto plano (Seção 4)
├── CHANGELOG.md                # Registro cronológico de mudanças (Seção 4)
├── README.md                   # Apresentação executiva e portal enxuto (Seção 9)
├── .gitignore                  # Higiene do repositório e arquivos ignorados
├── .editorconfig               # Configuração canônica de formatação para editores
├── site/                       # Portal estático de documentação pública (Seção 9)
│   ├── index.html              # Ponto de entrada da documentação
│   └── _headers                # Cabeçalhos HTTP de segurança (ou wrangler.jsonc)
└── .forgejo/workflows/ci.yml   # Esteira hermética de CI/CD em arquivo único (Seção 10)
```

### 3.1 Proibição de Poluição na Raiz
É terminantemente proibida a presença de arquivos avulsos de linters (`.prettierrc`, `.prettierrc.json`, `.eslintrc`, `.eslintrc.js`) ou arquivos de orquestração legados (`compose.yml`, `docker-compose.yml`, `docker-compose.yaml`). Arquivos de configuração devem residir em subdiretórios apropriados ou aderir estritamente aos nomes canônicos (`compose.yaml`).

### 3.2 Manifesto Canônico de Metadados (`.gost/metadata.json` — Regra `GOST-26`)
O arquivo `.gost/metadata.json` é a autoridade central (SSOT) para identidade, vitrine e catálogos:
* `slug`: Identificador único minúsculo em kebab-case ($\le 24$ caracteres, `^[a-z0-9-]+$`).
* `title`: Nome próprio legível do aplicativo ou biblioteca ($\le 25$ caracteres).
* `site_type`: Tipo de vitrine pública (`"doc"` para documentação/CLI ou `"app"` para aplicação web interativa).
* `tagline`: Subtítulo resumido em uma frase clara ($\le 60$ caracteres), respeitando `len(title + " — " + tagline) <= 65`.
* `summary`: Resumo executivo objetivo ($50$ a $140$ caracteres), consumido em meta tags Open Graph e feeds.
* `abstract`: Resumo expandido ($150$ a $500$ caracteres) utilizado no lead do `README.md` e hero do site.
* `tags`: Lista contendo entre 3 e 8 tags em kebab-case ($\le 20$ caracteres cada).
* `icon`: Ícone representativo ou caractere visual.
* `theme`: Objeto com `bg_color` e `accent_color` em formato hexadecimal.
* **Filtro Anti-Jargão:** As descrições em prosa **NÃO DEVEM** conter termos técnicos vazios ou autorreferenciais (`"autônomo"`, `"autônomo"`, `"hexagonal"`, `"ssot"`, `"rust puro"`, `"em rust"`, `"em php"`, `"wasm"`).

---

## 4. Versionamento Semântico e Histórico

### 4.1 Arquivo `VERSION` e Conformidade SemVer 2.0.0
* O repositório **DEVE** manter um arquivo `VERSION` na raiz contendo exclusivamente a versão atual do projeto em formato de texto puro UTF-8, finalizado por quebra de linha.
* O formato de versionamento **DEVE** aderir estritamente ao [Semantic Versioning 2.0.0](https://semver.org/) (`MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]`).
* **Exibição Dual Padronizada:**
  - *Versão Short:* `v{MAJOR}.{MINOR}.{PATCH}` (truncada antes do `-` ou `+`) para cabeçalhos, banners e títulos.
  - *Versão Long:* String integral idêntica ao arquivo `VERSION` para rodapés e CLI `--version`.
* **Sincronia Multi-Arquivo Mandatória:** A versão base declarada em `VERSION` deve coincidir rigorosamente com a versão declarada no topo do `CHANGELOG.md`, no arquivo `site/index.html` e nos manifestos de pacotes correspondentes (`Cargo.toml`, `package.json`, `composer.json`, `DESCRIPTION`).

### 4.2 Arquivo `CHANGELOG.md`
* O repositório **DEVE** manter um histórico de modificações legível por humanos e baseado no padrão [Keep a Changelog](https://keepachangelog.com/).
* As seções de cada versão **DEVEM** categorizar alterações em: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security` ou subdivisões semânticas convencionais.

---

## 5. Ciclo DD-TDD, Branches e o Protocolo de 9 Fases

O fluxo de trabalho em repositórios GOST **DEVE** seguir o ciclo rigoroso de **Documentation-Driven & Test-Driven Development (DD-TDD)** em 9 fases sequenciais e indivisíveis, governado pela regra de rastreabilidade estrita de tickets e isolamento em branches.

### 5.1 Cláusulas Pétreas do Ciclo

1. **Inviolabilidade das 9 Fases e Inferência Automática:** Todas as 9 etapas **DEVEM** ser seguidas em ordem sequencial estrita. O desenvolvedor não informa a fase manualmente; o Maestro de Governança deduz a fase (`ph3` a `ph9`) a partir do estado do histórico e dos arquivos alterados no commit.
2. **Zero Código sem Ticket e Documentação Prévia:** Nenhuma alteração em código de produção é permitida sem ticket aberto e especificação prévia de contrato/documentação.
3. **Isolamento Estrito da Fase de Documentação (Fase 3):** Na Fase 3, é terminantemente proibido alterar qualquer linha de código executável em `src/`, `lib/`, `bin/` ou `tests/`. Apenas especificações textuais, contratos e esquemas são aceitos.
4. **Rastreabilidade Estrita de Commits e Marcadores de Fase:**
   - Commits intermediários **DEVEM** seguir o padrão: `<tipo>: <resumo> (ref #<id> - ph<N>)` (onde `N` varia de 3 a 8).
   - O commit final de encerramento da Fase 9 **DEVE** seguir o padrão: `<tipo>: <resumo> (closes #<id> - ph9)`.
5. **Laudo Textual de Resolução Obrigatório na Fase 9:** O commit de fechamento da Fase 9 (`closes #<id> - ph9`) **DEVE** conter corpo textual ($\ge 80$ caracteres) com os cabeçalhos formais:
   - `[Resumo]:` Síntese objetiva do escopo tratado.
   - `[Solução]:` Descrição das modificações arquiteturais e técnicas efetuadas.
   - `[Validação]:` Relação dos testes determinísticos e gates executados para comprovação.  
   *No momento do merge, o Maestro extrai automaticamente esse laudo e o registra como comentário de fechamento no issue tracker.*
6. **Fast-Tracks Declarados:**
   - `docs`: Isenção formal das Fases 4 a 7 (exige estritamente as Fases 1, 2, 3, 8 e 9).
   - `chore`: Isenção formal das Fases 4 e 7 para manutenções de infraestrutura (exige estritamente as Fases 1, 2, 3, 5, 8 e 9).
7. **Proibição Absoluta de Commit Direto na `main`:** É estritamente proibido commitar diretamente na branch base `main`. Todo trabalho reside em branch de ticket isolada.

### 5.2 Estratégia de Branches e Governança Local-First
* **Branches de Trabalho:** Devem seguir o padrão `^(feat|fix|docs|refactor|test|chore)/([0-9]+)-([a-z0-9-]+)$`.
* **Governança Local-First:** As branches de trabalho existem exclusivamente no ambiente local. O envio de branches de trabalho para a forja remota é proibido, exceto se autorizado via flag explícita (`--multidev`).
* **Branches Persistentes Autorizadas:** Além da `main` (e `pages`), são autorizadas no remote `origin`:
  - Branches de manutenção de versão maior: `v<MAJOR>` ou `release/v<MAJOR>.x`.
  - Branches de épicos multi-ticket: `epic/<slug>`.
* **Protocolo de Gênese (Ticket #1):** Novos repositórios são inicializados pelo Maestro (`init`), abrindo a Issue #1 (`chore`), gerando a anatomia básica, emitindo o Laudo de Gênese no commit inaugural da `main` e disparando a publicação inicial.

### 5.3 As 9 Fases Canônicas do Ciclo DD-TDD

| Fase | Nome | Obrigatoriedade | Padrão do Commit |
| :---: | :--- | :---: | :--- |
| **1** | **Ticket / Issue** | ✅ **OBRIGATÓRIO** | *(Abertura no tracker — sem commit)* |
| **2** | **New Branch** | ✅ **OBRIGATÓRIO** | *(Criação da branch — sem commit)* |
| **3** | **Doc / Spec Contract** | ✅ **OBRIGATÓRIO** | `docs: specify <comportamento> (ref #<id> - ph3)` |
| **4** | **Red: Failing Test** | 🔴 **OBRIGATÓRIO** *(exceto fast-track)* | `test: add failing test for <requisito> (ref #<id> - ph4)` |
| **5** | **Green: Implement** | ✅ **OBRIGATÓRIO** | `feat: implement <funcionalidade> (ref #<id> - ph5)` ou `fix: resolve <bug> (ref #<id> - ph5)` |
| **6** | **Refactor to Excellence** | 🟡 **CONDICIONAL** | `refactor: optimize and polish <escopo> (ref #<id> - ph6)` |
| **7** | **Mutation Test & Fortify** | 🟡 **CONDICIONAL** *(ordem estrita)* | `test: eliminate surviving mutants in <escopo> (ref #<id> - ph7)` *(testes primeiro)*;<br>`refactor: eliminate dead code in <escopo> (ref #<id> - ph7)` *(código depois)* |
| **8** | **Fast Local Hygiene** | ✅ **OBRIGATÓRIO** | `fix: lint and formatting hygiene (ref #<id> - ph8)` *(se houver ajustes)* |
| **9** | **Finish Docs & Close** | ✅ **OBRIGATÓRIO** | `<tipo>: finalize <escopo> (closes #<id> - ph9)` *(com Laudo no corpo)* |

---

## 6. O Maestro de Governança

### 6.1 Política de Ponto Único de Entrada (*Single Entrypoint*) e Papéis Abstratos
O ecossistema divide as responsabilidades em cinco papéis abstratos cooperantes:
1. **Maestro Local:** Orquestra o ciclo de vida local do repositório, execução das fases DD-TDD, interceptação de convenções de commit, higiene e integração de branches.
2. **Autoridade de Forja e Abastecimento:** Gerencia a comunicação com forjas remotas, consulta e ciclo de vida de tickets, triagem assistida, inventário e operações de catálogo multi-repositório.
3. **Motor de Avaliação Normativa:** Avalia regras declarativas (`rules.toml`), laudos de conformidade e testes de sanidade em tempo de execução.
4. **Agente de Entrega e Orquestração Contínua (CD):** Valida artefatos compilados, orquestra o despacho para storages de distribuição, purga estágios efêmeros, comanda o deploy de serviços conteinerizados e propaga atualizações de versão em cascata.
5. **Controlador de Fronteira e Quarentena:** Gerencia a sincronização de espelhos públicos externos, reconciliação de webhooks multi-forja e o isolamento de contribuições externas no namespace de quarentena `refs/heads/inbox/*`.

O gerenciamento do ciclo de vida, git, tickets e conformidade deve ser operado exclusivamente através das ferramentas normatizadas do ecossistema. É terminantemente proibido o uso de comandos manuais do Git (`git commit`, `git merge`, `git push`, `git pull`, `git tag`) ou ferramentas ad-hoc de terceiros sem respaldo normativo (`tea`, `gh`, `glab`).

### 6.2 Contrato Universal de Subcomandos do Maestro
Qualquer implementação do Maestro de Governança compatível com a GOST deve expor a seguinte interface determinística:
* `init`: Inicializa repositório, estrutura e protocolo de gênese.
* `ticket`: Consulta, abertura, triagem e fechamento de tickets.
* `divan`: Assistente interativo de triagem e planejamento.
* `start <id>`: Cria e faz checkout da branch de trabalho padronizada.
* `status`: Audita a conformidade atual do repositório, branch e hooks.
* `commit`: Valida e cria commits com inserção determinística de tags de ticket e fase (`ph3` a `ph8`).
* `mutate`: Executa testes de mutação restritos ao diff local.
* `hygiene`: Executa os formatadores determinísticos e linters rápidos (Fase 8).
* `close`: Registra o laudo e gera o commit canônico de encerramento (`closes #<id> - ph9`).
* `merge`: Realiza o merge validando o laudo e a tag de fechamento.
* `push`: Executa pré-checagens e realiza o envio para o remote autorizado.
* `release`: Conduz o processo de tag semântica e auditoria pré-release.
* `gost sync/check`: Sincroniza e audita a conformidade das regras técnicas.

### 6.3 Protocolo de Comandos para Agentes de IA
Agentes autônomos de IA devem seguir o vocabulário de comandos operacionais determinísticos:
* `DCPD`: Despacho completo com planejamento e documentação prévia.
* `DCP`: Despacho padrão de implementação e correção.
* `PLAN`: Elaboração e detalhamento de plano de ação sem escrita de código.
* `TDD`: Execução estrita do ciclo Red-Green-Refactor.
* `AUDIT`: Auditoria estática de conformidade e integridade.
* `FIX`: Correção de bugs pontuais com teste de regressão comprovado.
* `RELEASE`: Preparação e condução de versão estável.

---

## 7. Estratégia de Testes e Cobertura

### 7.1 Taxonomia de Testes
1. **Testes Unitários:** Isolamento absoluto, sem dependência de I/O externo, execução em milissegundos.
2. **Testes Funcionais:** Validação de regras de negócio e transformações de dados.
3. **Testes de Integração:** Validação entre subsistemas internos e adaptadores concretos.
4. **Testes Ponta a Ponta (E2E):** Simulação de interação real de usuários em navegadores headless via Playwright quando aplicável.

### 7.2 Delegação de Cobertura para a Esteira
* **Piso Mínimo Inviolável:** A cobertura global de testes automatizados **DEVE** ser de no mínimo **`90%`**, com meta de **`100%`** no domínio.
* **Aferição na Esteira Remota:** A verificação estrita de cobertura com quebra de build é critério bloqueante delegado categoricamente à esteira remota hermética (`ci.yml`), liberando o fluxo de desenvolvimento local de overhead excessivo.

### 7.3 Mutação Restrita ao Diff
Na Fase 7 local, as ferramentas de teste de mutação devem operar restritas ao diff de alterações (`--in-diff` ou `--git-diff-lines`), deixando baterias globais de mutação para esteiras de auditoria periódica.

---

## 8. Análise Estática e Tolerância Zero a Avisos (*Zero Warnings*)

### 8.1 Tolerância Zero a Warnings
Linters e analisadores estáticos devem operar com severidade máxima (ex: `-D warnings`). Avisos são tratados como erros fatais e bloqueiam a integração. É proibida a permanência de tokens de depuração (`dbg!`, `debugger;`, `var_dump`, `dd()`, `print_r`) em código final.

### 8.2 Formatação Determinística e `.editorconfig`
Todo projeto deve adotar um formatador oficial determinístico verificado com flags `--check`. O arquivo `.editorconfig` é obrigatório na raiz e padroniza UTF-8, LF, newline final e remoção de espaços em branco.

---

## 9. Vitrine Pública, SSOT e Banners

### 9.1 Topologia de Vitrine e Arquétipos de Aplicação (`APP_TYPE` / `site_type`)
Todo repositório deve declarar sua natureza estrutural através do metadado `APP_TYPE` (ou `site_type`) no `GOSTVER` ou frontmatter de projeto, categorizado sob quatro arquétipos canônicos:
1. **`web` (Webapps Autônomas e Autorais):** O componente principal é uma aplicação gráfica interativa web (*ex.: Navalha, Lírica*). A frontpage é a própria aplicação ou manifesto vivo, com liberdade estética e de design absoluta. Documentação técnica e de apoio é embutida sob rota `/docs` ou diretório `docs/`.
2. **`hybrid` (Aplicações Híbridas):** O foco principal reside no utilitário binário ou serviço compilado, acompanhado de uma interface web por conveniência (*ex.: Lacraia, Lauda*). A frontpage apresenta o produto e documentação de usuário (`docs/user/`), reservando subdiretório dedicado (`web/` ou subrota `/app/`) para a webapp interativa.
3. **`binary` (Utilitários Binários Puros):** Ferramentas de linha de comando (CLI) ou daemons sem interface web interativa (*ex.: compiladores, utilitários de sistema e motores de auditoria*). O site institucional é 100% voltado à apresentação, manuais de usuário, documentação técnica e notas de versão, gerado de forma determinística por motor SSG padronizado.
4. **`manifesto` (Documentações e Manifestos Puros):** Projetos estritamente textuais, normativos ou literários sem compilação binária (*ex.: GOST, Travesti*). O site é uma publicação editorial de alta legibilidade, índice remissivo e preservação integral dos textos.

### 9.2 SSOT em Markdown e README Enxuto
* **SSOT:** Documentações, manuais e guias residem estritamente em Markdown. É proibido duplicar textos extensos manualmente em HTML.
* **README Enxuto:** O arquivo `README.md` na raiz deve ter um teto rígido de **50 linhas**, servindo como portal rápido para a vitrine oficial.

### 9.3 Banner Open Graph Minimalista
* **Resolução:** `1200 × 630 px` com Safe Zone centralizada 4:3 (`720–840px` $\times$ `500px`).
* **Conteúdo Visual:** Apenas o ícone/logo sobre as cores do tema e o texto `{title} — {tagline}` ($\le 65$ caracteres). Veto a badges de linguagem ou links impressos diretamente na imagem.
* **Sincronia de Meta Tags:** `<meta property="og:title">` deve equivaler a `{title} — {tagline}`, e `<meta property="og:description">` ao `{summary}` ($\le 140$ caracteres).

### 9.4 Rodapé Canônico em Duas Linhas
Aplicações e documentações estáticas devem exibir rodapé em duas linhas:
* **Linha 1 — Afirmação Identitária:** Definida e parametrizada conforme o perfil adotado.
* **Linha 2 — Metadados de Versão e Licença:** `{Nome do App} v{Versão} • [{Licença}](LICENSE)`.

### 9.5 Cabeçalhos HTTP de Segurança
A vitrine estática deve declarar cabeçalhos `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY` e `Referrer-Policy: strict-origin-when-cross-origin` em `site/_headers` ou `wrangler.jsonc`.

---

## 10. Esteira Hermética de CI/CD

### 10.1 Arquivo Único e Hermeticidade
O pipeline de automação reside estritamente em `.forgejo/workflows/ci.yml`. É proibida a existência da pasta `.github/workflows/`. São proibidos comandos de download ou instalação em runtime (`apt-get`, `apk add`, `pip install`, `npm i -g`, `cargo install`, `wget`, `curl`). Todas as ferramentas necessárias devem estar pré-instaladas na imagem base local do runner.

### 10.2 Filas Canônicas e Dependência Estrita
* Filas padronizadas: `test` (Quality Gate), `build`/`release` e `deploy`.
* A fila `test` é obrigatória; todas as filas posteriores devem declarar expressamente `needs: [test]`.
* Builds de release e empacotamento ocorrem exclusivamente na esteira; é proibido compilar releases pesadas na máquina local.

### 10.3 Zero Binários no Histórico Git (Regra `GOST-24`)
É expressamente proibido versionar artefatos compilados, arquivos ELF, pacotes ou tarballs (`.exe`, `.dll`, `.so`, `.tar.gz`, `.zip`, `.deb`, `.rpm`, `.apk`) no repositório Git.

### 10.4 Arquitetura de Distribuição Desacoplada e Retenção de Artefatos
* **Modelo Produtor–Curador Desacoplado:** A publicação de softwares opera sob divisão estrita de responsabilidades:
  - **Produtor (Repositório do Software):** Compila o código na esteira, calcula os hashes de integridade criptográfica (SHA-256), envia os artefatos diretamente para o storage de distribuição e notifica a autoridade curadora de catálogo via evento estruturado.
  - **Curador (Repositório Central de Catálogo):** Ouve os eventos, executa auditoria estrita de rede e integridade de checksum dos arquivos novos e do histórico ativo, gerencia a retenção no storage e publica o catálogo consolidado.
* **Política Mandatória de Retenção e Ciclo de Vida:** Todo catálogo ou esteira de distribuição **DEVE** adotar política formal de retenção e rotação de artefatos por canal de entrega (`stable`, `dev`, etc.), purgando compilações antigas excedentes para impedir a proliferação desgovernada de ativos e garantir previsibilidade de armazenamento. As cotas numéricas e particularidades operacionais são fixadas nos perfis operacionais.
* **Tolerância Zero a Links Quebrados:** Se qualquer artefato declarado (novo ou histórico ativo) falhar na verificação de rede ou apresentar divergência de checksum, a publicação do catálogo **DEVE** ser abortada preventivamente e um chamado/issue automático **DEVE** ser emitido para o repositório produtor.

---

## 11. Internacionalização (Intl)

### 11.1 Paridade Matemática de Chaves nas 10 Línguas
Projetos internacionalizados devem manter paridade estrita de chaves nos 10 idiomas canônicos: `en`, `pt`, `es`, `fr`, `de`, `it`, `ru`, `zh`, `ja` e `ar`.

### 11.2 Suporte RTL e Propriedades Lógicas
O idioma árabe (`ar`) requer ativação do atributo `dir="rtl"`. Interfaces devem empregar propriedades lógicas em CSS (`margin-inline`, `padding-inline`), banindo propriedades físicas horizontais estáticas.

---

## 12. Arquitetura de Domínio, DDD e SOLID (Regra `GOST-27`)

### 12.1 Pureza de Domínio (Zero I/O no Core)
O diretório e módulos de domínio/core (`src/domain/`, `lib/core.sh`, `internal/domain/`, etc.) **NÃO DEVEM** conter operações ou importações diretas de I/O (rede, filesystem, banco de dados, variáveis de ambiente ou chamadas a processos de sistema).

### 12.2 Inversão de Dependência e In-Memory Fakes
* O Core comunica-se com o mundo externo exclusivamente através de abstrações (Portas).
* Mocks dinâmicos pesados são rejeitados em favor de adaptadores em memória leves (*In-Memory Fakes*) baseados em tipos nativos da linguagem.
* Fakes e adaptadores reais compartilham a mesma suíte de testes de contrato (LSP).

### 12.3 Validação na Borda e Primitivos Confiáveis
A entrada de dados é validada e sanitizada nas bordas do sistema (*Parse, Don't Validate*). O Core opera com tipos confiáveis e enums nativos da linguagem para modelar estados finitos.

---

## 13. Aderência a Padrões de Sistema e Operação (XDG, 12-Factor & OCI)

### 13.1 Diretórios do Sistema (XDG Base Directory)
Aplicações devem respeitar `$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`, `$XDG_STATE_HOME`, `$XDG_CACHE_HOME` e `$XDG_RUNTIME_DIR`. É terminantemente proibido criar arquivos e pastas ocultas soltas na home do usuário (`~/.app`). Devem oferecer suporte a `NO_COLOR`.

### 13.2 Contêineres OCI e Compose
* Manifestos de orquestração devem adotar o nome canônico `compose.yaml`.
* Dockerfiles devem implementar build multi-stage, execução sob usuário não-root, healthchecks e banimento de tags `:latest`. É proibido o uso de Watchtower.

---

## 14. Perfis de Implementação e Política de Waivers

### 14.1 Herança em Cascata de Perfis
Perfis especializados (`profile.md`) especializam e complementam a norma central em ordem hierárquica de precedência através da diretiva `extends`.

### 14.2 Mecanismo de Waivers Auditados
Exceções temporárias a regras técnicas devem ser formalizadas com auditoria rastreável:
* **Arquivo `custom_rules.json`:** Declara regras ignoradas exigindo `rule_id`, `reason` ($\ge 20$ caracteres) e ID do ticket associado.
* **Diretiva Inline:** `gost-ignore: <RULE_ID> (ticket #<id> - <motivo>)`.
* Agentes autônomos de IA são terminantemente proibidos de criar ou editar diretivas de waiver.

---

## 15. Governança de Fronteira e Quarentena de Branches (`inbox/*`)

### 15.1 Topologia de Remotes Git
O remote `origin` na forja primária é o único destino autorizado para operações de push. Espelhos remotos públicos operam exclusivamente como mirrors de consulta e devem ser configurados com `pushurl = no_push`.

### 15.2 Quarentena de Contribuições Externas
Contribuições externas e Pull Requests vindos de espelhos são recebidos sob isolamento no namespace `refs/heads/inbox/*`, sujeitos a esteiras não-confiáveis offline antes de qualquer integração.

---

## 16. Taxonomia e Contratos dos Escopos de Avaliação de Regras

As regras e verificações declaradas em toda a hierarquia normativa (`rules.toml`) operam sob escopos canônicos de avaliação que delimitam estritamente o momento do ciclo de vida, o alvo inspecionado e o contexto dos dados injetados:

1. **Escopo `commit-msg` (Interceptação Atômica de Commit):**
   - **Gatilho de Execução:** Hook de interceptação `commit-msg` ou comando do Maestro Local.
   - **Alvo:** Mensagem e corpo do commit em preparação (`.git/COMMIT_EDITMSG`).
   - **Responsabilidade:** Validação de convenções sintáticas de Conventional Commits, referências obrigatórias a tickets, declaração explícita de fase DD-TDD e completude do laudo estruturado de fechamento na Fase 9.
2. **Escopo `project` (Auditoria Estática de Repositório):**
   - **Gatilho de Execução:** Auditoria local pelo Motor de Avaliação Normativa e esteiras de integração contínua (CI).
   - **Alvo:** Sistema de arquivos da árvore de trabalho do projeto.
   - **Responsabilidade:** Validação da anatomia mínima da raiz, metadados (`VERSION`, `CHANGELOG.md`, arquivos de configuração de perfil), manifestos de contêineres OCI, contratos OpenAPI e higiene documental permanente.
3. **Escopo `pre-push` (Interceptação de Envio Remoto):**
   - **Gatilho de Execução:** Hook `pre-push` ou comando de envio do Maestro Local.
   - **Alvo:** Branches locais contra referências remotas.
   - **Responsabilidade:** Prevenção de commits diretos na branch principal, confirmação de fechamento de tickets associados e checagens rápidas de integridade pré-publicação.
4. **Escopo `git-history` (Integridade Retroativa):**
   - **Gatilho de Execução:** Auditoria retroativa e checagem de integridade profunda.
   - **Alvo:** Grafo e cadeia de commits da branch contra a base canônica.
   - **Responsabilidade:** Garantia de que a sequência de fases DD-TDD e laudos históricos não foram alterados ou corrompidos.
5. **Escopo `post-build` (Sanidade e Conformidade de Artefatos Compilados):**
   - **Gatilho de Execução:** Pós-compilação em auditorias locais pelo Motor de Avaliação Normativa, rotinas de build e esteiras de integração contínua (CI/CD).
   - **Alvo:** Artefatos executáveis ou empacotados gerados em `target/debug`, `target/release` ou `dist/`.
   - **Responsabilidade:** Verificação funcional dinâmica (*smoke tests*), prevenção de falhas de segmentação (`SIGSEGV`) ou *panics* imediatos de inicialização, integridade de ligação dinâmica (*dynamic linking* / bibliotecas compartilhadas ausentes) e conformidade das interfaces mínimas (`--help`, `--version` idêntico à versão canônica e subcomandos de ciclo de vida).

