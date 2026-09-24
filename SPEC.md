# GOST — Padrão Técnico para Repositórios Abertos
**Versão da Norma:** `1.0.0-draft`  
**Status:** Oficial / Proposta Normativa  
**Referência:** ГОСТ (Государственный Стандарт / General Open Source Standard)

---

## 1. Escopo e Propósito

Esta especificação define os requisitos estruturais, metodológicos, de governança e de documentação para criação, manutenção e ciclo de vida de repositórios de software aberto.

O objetivo do GOST é eliminar atritos no surgimento de novos projetos, garantir rastreabilidade histórica completa, assegurar a máxima liberdade do código e impor rigor de engenharia orientado à documentação e testes.

As palavras-chave **DEVE** (*MUST*), **NÃO DEVE** (*MUST NOT*), **DEVERIA** (*SHOULD*), **NÃO DEVERIA** (*SHOULD NOT*) e **PODE** (*MAY*) neste documento devem ser interpretadas conforme descrito na [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

---

## 2. Filosofia e Licenciamento

Todo projeto em conformidade com o GOST **DEVE** declarar sua licença de forma explícita na raiz do repositório através de um arquivo `LICENSE`.

### 2.1 Presunção de Domínio Público (`CC0-1.0`)
* **Regra Geral:** Todo repositório **DEVE** presumir, por padrão, a renúncia de direitos autorais e liberação irrestrita em domínio público via **`CC0-1.0`** (Creative Commons Zero 1.0 Universal).
* **Justificativa:** O conhecimento, ferramentas e códigos devem fluir com o menor atrito burocrático e jurídico possível, garantindo validade jurídica internacional e reuso irrestrito para qualquer finalidade.

### 2.2 Exceção de Copyleft Forte (`GPL-3.0`)
* **Regra de Exceção:** Quando um projeto possuir natureza estratégica que exija proteção contra apropriação predatória, fechamento de código derivado ou mercantilização comercial sem repasse à comunidade, o projeto **DEVE** adotar a **`GNU General Public License v3.0` (GPL-3.0)** (ou `AGPL-3.0` para serviços web).
* Qualquer exceção à presunção padrão de `CC0-1.0` **DEVE** ser justificada no `README.md` do projeto.

---

## 3. Anatomia Mínima da Raiz

Todo repositório GOST **DEVE** conter em sua raiz a seguinte estrutura mínima independente da stack ou linguagem utilizada:

```
.
├── LICENSE                     # Termo legal de licenciamento (Seção 2)
├── VERSION                     # Versão semântica em texto plano (Seção 4)
├── CHANGELOG.md                # Registro cronológico de mudanças (Seção 4)
├── README.md                   # Apresentação executiva e guia rápido
├── .gitignore                  # Higiene do repositório e arquivos ignorados
├── site/                       # Portal estático de documentação pública (Seção 6)
│   ├── index.html              # Ponto de entrada da documentação
│   └── _headers                # Cabeçalhos HTTP de segurança
└── .forgejo/ / .github/        # Automação de CI/CD (Seção 7)
    └── workflows/ci.yml
```

Arquivos de configuração e metadados específicos de ferramentas **NÃO DEVEM** poluir a raiz sem necessidade e devem ser isolados em pastas de configuração ou perfis.

---

## 4. Versionamento e Histórico

### 4.1 Arquivo `VERSION`
* O repositório **DEVE** manter um arquivo `VERSION` na raiz contendo exclusivamente a versão atual do projeto em formato de texto puro UTF-8, finalizado por uma quebra de linha.
* O formato de versionamento **DEVE** aderir estritamente ao [Semantic Versioning 2.0.0](https://semver.org/) (`MAJOR.MINOR.PATCH[-PRERELEASE]`).
* Durante o estágio de desenvolvimento inicial, a versão **DEVERIA** seguir o padrão `0.1.0-dev.N`.

### 4.2 Arquivo `CHANGELOG.md`
* O repositório **DEVE** manter um histórico de modificações legível por humanos e baseado no padrão [Keep a Changelog](https://keepachangelog.com/).
* As seções de cada versão **DEVEM** categorizar alterações em: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.

---

## 5. Ciclo de Desenvolvimento GOST (DD-TDD)

O fluxo de trabalho em repositórios GOST **DEVE** seguir o ciclo rigoroso de **Documentation-Driven & Test-Driven Development (DD-TDD)**, governado pela regra de rastreabilidade estrita de tickets.

### 5.1 Cláusula Pétrea: Zero Commits sem Ticket
* **Regra Inviolável:** **NENHUM COMMIT DEVE EXISTIR SEM UM TICKET ASSOCIADO**.
* Todo trabalho (nova funcionalidade, correção de bug, refatoração, documentação ou manutenção) **DEVE** obrigatoriamente nascer de um ticket formal registrado no issue tracker antes de qualquer alteração no código.
* **Commits Intermediários:** Durante o ciclo de desenvolvimento, todo commit **DEVE** incluir a referência ao ticket no formato `(ref #<id>)`.
* **Commit de Fechamento:** O último commit do ciclo, após satisfazer todos os critérios de conclusão, **DEVE** conter `(closes #<id>)` para encerrar formalmente o ticket.
* **Bloqueio Automático:** Hooks de commit (`commit-msg`) e o pipeline de CI/CD **DEVEM** rejeitar imediatamente qualquer commit que não contenha a referência explícita a um ticket.

### 5.2 Estratégia de Branches por Ticket
* É estritamente **PROIBIDO** commitar diretamente no branch principal (`main`) durante o ciclo de trabalho.
* Todo ticket **DEVE** ser desenvolvido em um branch dedicado derivado de `develop` (ou `main`), com nomenclatura padronizada contendo o ID do ticket:
  - `feat/<id>-<slug-curto>` (ex: `feat/42-rate-limiting`)
  - `fix/<id>-<slug-curto>` (ex: `fix/55-jwt-timestamp-overflow`)
  - `docs/<id>-<slug-curto>` (ex: `docs/12-api-spec-update`)
  - `refactor/<id>-<slug-curto>`
* O merge do branch para a linha principal só é permitido após aprovação completa de testes, cobertura e linter no CI.

### 5.3 As 5 Etapas do Ciclo DD-TDD

```
[1. Ticket] ──> [2. Doc in Develop] ──> [3. Failing Test] ──> [4. Fix / Implement] ──> [5. Finish Docs & Close]
```

1. **Etapa 1: Ticket / Issue**
   - Abertura formal da issue com Contexto, Comportamento Esperado e Critérios de Aceite.
2. **Etapa 2: Documentação em Desenvolvimento (`Doc in develop`)**
   - Escrita prévia da documentação, interfaces e formatos no branch do ticket antes de codificar.
   - Commit: `docs: specify <comportamento> (ref #<id>)`
3. **Etapa 3: Teste Falho (`Failing Test`)**
   - Criação de teste automatizado comprovando a ausência da funcionalidade ou reproduzindo o defeito. O teste **DEVE falhar**.
   - Commit: `test: add failing test for <requisito> (ref #<id>)`
4. **Etapa 4: Correção ou Implementação (`Fix / Implement`)**
   - Escrita do código funcional estritamente necessário para fazer a suíte passar.
   - Commit: `feat: implement <funcionalidade> (ref #<id>)` ou `fix: resolve <bug> (ref #<id>)`
5. **Etapa 5: Finalização da Documentação e Encerramento (`Finish Docs & Close`)**
   - Polimento final dos manuais, guias, documentação estática do site e `CHANGELOG.md`.
   - Commit: `docs: finalize documentation and guides (closes #<id>)`

### 5.4 Critérios de Conclusão / Definition of Done (DoD)
Um ticket só pode ser considerado concluído e encerrado via `(closes #<id>)` se satisfizer integralmente o seguinte checklist:
- [ ] Ticket aberto previamente detalhando o problema e critérios.
- [ ] Branch dedicado criado no formato `<tipo>/<id>-<slug>`.
- [ ] Commit com teste falho registrado no histórico antes da implementação.
- [ ] Código funcional implementado e todos os testes passando.
- [ ] Cobertura global mantida comprovadamente **acima de 90%** (mirando 100%).
- [ ] Ausência de mutantes críticos sobreviventes (verificação de mutação).
- [ ] Documentação do `./site`, `README.md` e `CHANGELOG.md` atualizadas.
- [ ] Análise estática limpa (Zero Warnings).
- [ ] Pipeline de CI/CD 100% verde.

---

## 6. Estratégia e Qualidade de Testes

A integridade do software no padrão GOST baseia-se na verificação automatizada contínua com alta densidade de asserções e cobertura quantitativa e qualitativa.

### 6.1 Taxonomia de Testes Obrigatória
Todo projeto **DEVE** estruturar sua validação nas seguintes camadas, conforme aplicável à natureza do componente:

1. **Testes Unitários:**
   - Testam funções, métodos, tipos e módulos em isolamento absoluto.
   - Devem ter execução instantânea (milissegundos) e zero dependências de I/O externo.
2. **Testes Funcionais:**
   - Validam regras de negócio, transformações de dados e casos de uso específicos (dada uma entrada X, a saída deve ser Y).
3. **Testes de Integração:**
   - Validam a interoperabilidade entre componentes internos, persistência em disco (ex: SQLite), variáveis de ambiente ou protocolos de comunicação local (IPC/sockets).
4. **Testes Ponta a Ponta (E2E):**
   - Para aplicações com interface com usuário (web ou desktop), os testes **DEVEM** exercitar o sistema completo simulando a interação real de usuários em navegadores headless utilizando **Playwright**.

### 6.2 Política de Cobertura (*Code Coverage*)
* **Piso Mínimo Inviolável:** A cobertura global de código automatizada **DEVE** ser mantida permanentemente em no mínimo **`90%`**.
* **Meta de Excelência:** Todo projeto **DEVE** focar ativamente na meta de **`100%`** de cobertura nos módulos centrais de domínio e utilitários.
* **Critério de Bloqueio:** Qualquer alteração, pull request ou commit que rebaixe a cobertura global abaixo de 90% **DEVE** falhar o pipeline de integração contínua.

### 6.3 Validação Qualitativa: Testes de Mutação
* A cobertura percentual pura não atesta a eficácia das verificações. Para evitar testes cosméticos (linhas executadas sem asserções de valor real), o projeto **DEVERIA** empregar **Testes de Mutação** (*Mutation Testing*).
* O teste de mutação introduz falhas sintéticas no código (mutantes); se a suíte de testes continuar passando, o teste é considerado deficiente.

### 6.4 Hermeticidade e Determinismo
* **Isolamento de Rede:** As suítes de testes unitários, funcionais e de integração **NÃO DEVEM** depender de acesso à internet pública ou serviços remotos. Chamadas externas devem ser simuladas via *mocks*, *stubs* ou *fixtures*.
* **Limpeza de Estado:** Todo teste que instanciar arquivos, diretórios temporários ou registros em banco **DEVE** destruí-los ao término da execução, garantindo que os testes sejam estritamente idempotentes e executáveis em qualquer ordem.

---

## 7. Análise Estática e Tolerância Zero a Avisos (*Zero Warnings*)

A excelência e longevidade do código exigem rigor estrito antes de qualquer execução:

### 7.1 Tolerância Zero a Warnings
* Todo projeto **DEVE** configurar seus linters e analisadores estáticos com nível de severidade máximo.
* Avisos (*warnings*) **DEVEM** ser tratados como erros fatais (ex: flags equivalentes a `-D warnings`). Qualquer commit ou PR com alertas pendentes **DEVE quebrar o CI**.

### 7.2 Filosofia de Dependências Mínimas e Auditoria de Segurança
* **Princípio Anti-Bloat:** A adição de bibliotecas de terceiros **DEVE** ser estritamente justificada no ticket do projeto. Favorece-se soluções leves, bibliotecas padrão e código autônomo.
* **Auditoria de Vulnerabilidades:** O pipeline de CI **DEVE** executar verificações automatizadas de vulnerabilidades em dependências (*dependency auditing*).

---

## 8. Vitrine Pública e Documentação Web

Todo repositório GOST **DEVE** manter uma vitrine pública de documentação estática no diretório `./site`.

1. **Acessibilidade Universal:** O site de documentação **NÃO DEVE** depender de etapas de compilação complexas para visualização básica; HTML/CSS/JS puros ou geradores ultra-leves são encorajados.
2. **Segurança HTTP:** O diretório de publicação **DEVE** conter cabeçalhos HTTP mínimos de segurança (arquivo `_headers` ou equivalente):
   - `X-Content-Type-Options: nosniff`
   - `X-Frame-Options: DENY`
   - `Referrer-Policy: strict-origin-when-cross-origin`
3. **Publicação Contínua:** A documentação **DEVE** ser publicada automaticamente via pipeline de CI/CD a cada push no branch principal (`main`).

---

## 9. Integração e Validação Contínua (CI/CD)

### 9.1 Separação Obrigatória de Jobs: Testes vs. Publicação
Todo pipeline de CI **DEVE** declarar seus estágios em jobs estritamente separados:

* **Job `test`** (obrigatório em todo repositório):
  - Lint, análise estática e Zero Warnings
  - Execução completa da suíte de testes (unitários, funcionais, integração, E2E)
  - Gate de cobertura (≥ 90%)
  - Auditoria de dependências
* **Job `deploy-*`** (somente quando aplicável):
  - **DEVE** declarar `needs: [test]` — nunca roda sem testes aprovados
  - **DEVE** condicionar execução ao branch principal (`if: github.ref == 'refs/heads/main'`)
  - Publica artefatos, documentação estática ou binários de release

A separação explícita garante que o gate de pre-push local (Seção 9.2) possa executar exclusivamente o job `test` sem acidentalmente disparar deploys, e que cada estágio seja inspecionável de forma independente nos logs de CI.

### 9.2 Gate de Pre-Push: CI Local com Infraestrutura Idêntica
O problema do "passa localmente, quebra no CI" origina-se da divergência entre o ambiente local do desenvolvedor e o ambiente de execução do pipeline. Para eliminar essa divergência:

* Os repositórios **DEVERIAM** configurar um *pre-push gate* que execute o job `test` do pipeline em um ambiente **bit-for-bit idêntico** ao da forja remota, antes de permitir o `git push`.
* O gate é executado como hook `pre-push` do Git, bloqueando o push em caso de falha.
* O ambiente de execução local **DEVE** ser o mesmo container/VM utilizado pelo runner de CI remoto.

#### Propriedades do Gate de Pre-Push
1. **Idempotência:** A execução local do job `test` deve produzir resultados idênticos à execução remota.
2. **Isolamento de Publicação:** O gate **NUNCA DEVE** executar jobs de deploy, publish ou release — apenas `test`.
3. **Registro Persistente:** A saída completa de cada execução do gate **DEVE** ser armazenada em logs nomeados e datados para rastreabilidade e diagnóstico.
4. **Feedback Vivo:** O gate **DEVERIA** exibir progresso em tempo real (step atual, tempo decorrido) sem poluir o histórico do terminal.
5. **Bypass Consciente:** O bypass do gate (`git push --no-verify`) **DEVE** ser sempre possível e documentado como opção explícita e consciente — nunca automático.

### 9.3 Degradação Graciosa do Gate
Se o ambiente de execução local não estiver disponível (ex: Docker não iniciado, executor não instalado), o gate **DEVE**:
- Emitir aviso claro indicando que o gate foi ignorado
- **Nunca** bloquear o push por ausência do executor local
- Registrar o bypass involuntário para rastreabilidade

---

## 10. Internacionalização (Intl)

A norma GOST impõe disciplina linguística em camadas para conciliar cooperação global com acessibilidade multilíngue.

### 10.1 Segregação por Camadas
1. **Código-Fonte e Identificadores:** **DEVEM** ser escritos estritamente em **Inglês** (nomes de variáveis, funções, tipos, constantes e endpoints de API).
2. **Histórico de Commits e Tags:** **DEVEM** ser redigidos em **Inglês** seguindo a especificação de Conventional Commits (`feat:`, `fix:`, `docs:`, etc.).
3. **Triagem de Tickets:** Usuários **PODEM** relatar problemas e descrever features em qualquer idioma; ferramentas automatizadas de triagem (ex: `diva`) **DEVEM** estruturar o ticket na língua de trabalho configurada no repositório.

### 10.2 A Matriz Canônica das 10 Línguas Oficiais
Para a documentação pública e vitrines estáticas (`./site`), a norma GOST estabelece a **Matriz Oficial das 10 Línguas**, garantindo alcance global, inclusão demográfica e representação histórica:

| Código ISO | Idioma | Endônimo Nativo | Direção | Papel / Escopo |
|:---:|---|---|:---:|---|
| **`en`** | English | English | LTR | Baseline técnico universal e de engenharia |
| **`pt`** | Portuguese | Português (Brasil / Portugal) | LTR | Língua nativa do ecossistema central |
| **`es`** | Spanish | Español | LTR | Integração ibérica e América Latina |
| **`fr`** | French | Français | LTR | Comunidade internacional e difusão francófona |
| **`de`** | German | Deutsch | LTR | Engenharia e ecossistema de software europeu |
| **`it`** | Italian | Italiano | LTR | Comunidade técnica e polo de computação mediterrâneo |
| **`ru`** | Russian | Русский | LTR | Referência estética e técnica da linhagem soviética / GOST |
| **`zh`** | Chinese | 中文 (简体中文) | LTR | Maior base populacional e polos tecnológicos da Ásia |
| **`ja`** | Japanese | 日本語 | LTR | Vanguarda técnica, comunidade open source e estética |
| **`ar`** | Arabic | العربية | **RTL** | Grande bloco linguístico global e representação do Oriente Médio |

### 10.3 Requisito de Direcionalidade (RTL)
* Projetos que fornecerem a versão em Árabe (`ar`) **DEVEM** assegurar suporte nativo a layouts **Right-to-Left** (`<html dir="rtl" lang="ar">`).
* Folhas de estilo **DEVEM** utilizar propriedades lógicas de CSS (ex: `margin-inline-start`, `padding-inline`, `text-align: start`) para evitar quebras visuais na alternância de direcionalidade.

### 10.4 Arquitetura Estática de Localização
* A documentação de cada idioma **DEVE** residir em subdiretórios dedicados: `./site/<lang>/index.html`.
* A raiz `./site/index.html` **DEVE** atuar como roteador leve cliente:
  1. Detecta preferência salva em `localStorage.getItem('doc_lang')`.
  2. Detecta idioma do cliente via `navigator.language`.
  3. Redireciona com fallback seguro para `en/`.
  4. Expõe links canônicos `rel="alternate" hreflang="<lang>"` para indexação de motores de busca.

---

## 11. Metadados Sociais e Cards de Compartilhamento (Padrão KokoroSim)

O compartilhamento de links de repositórios em plataformas sociais e mensageiros (WhatsApp, Telegram, Twitter/X, Discord, LinkedIn, iMessage) exige blindagem técnica contra recortes arbitrários e truncamento de texto.

### 11.1 Dimensões e Formato do Banner Gráfico
* **Resolução Obrigatória:** Exatamente **1200 × 630 pixels** (proporção 1.91:1, formato PNG otimizado, RGB).
* **Localização Padrão:** `./site/assets/og_preview.png`.

### 11.2 Safe Zone 4:3 Centralizada (Anti-Recorte)
Plataformas móveis (notadamente o WhatsApp) costumam recortar o banner em **1:1 (quadrado)** ou em balões estreitos de chat. Para garantir legibilidade absoluta:
* **Miolo Central Útil:** Todo o conteúdo textual, logotipos, badges e selos **DEVE** estar contido dentro de um retângulo central com largura entre **720px e 840px** e altura de **500px**.
* **Sangrias Laterais de Segurança:** As faixas de **180px a 240px** em cada lateral **NÃO DEVEM** conter texto nem elementos essenciais, servindo unicamente para gradiente ou textura de fundo.
* **Margens Verticais:** Top padding mínimo de **52px** e Bottom padding mínimo de **85px** (para evitar que carimbos de hora, URLs de rodapé ou botões de sobreposição encubram a mensagem).

### 11.3 Limites Rígidos de Caracteres (Anti-Truncamento)
Para impedir que redes sociais apliquem elipses (`...`) decepando palavras:

1. **Meta Tag `<meta property="og:title">` e `twitter:title`:**
   - **Faixa Segura:** **50 a 65 caracteres** (limite absoluto: 70 caracteres).
2. **Meta Tag `<meta property="og:description">` e `twitter:description`:**
   - **Faixa Segura:** **120 a 155 caracteres** (limite absoluto: 160 caracteres).
   - Deve ser auto-contida e evitar redundância com o título.
3. **Badge Superior Impresso na Imagem:**
   - **Máximo:** **35 caracteres**, em caixa alta (ex: `OPEN SOURCE // RUST + WASM`).
4. **Título Principal na Imagem:**
   - **Máximo:** **35 a 45 caracteres** (distribuído em 1 ou 2 linhas nítidas, tipografia bold de alto contraste).
5. **Subtítulo / Linha de Apoio na Imagem:**
   - **Máximo:** **50 a 60 caracteres** em linha única.
6. **Rodapé Integrado na Imagem:**
   - Indicador de URL canônica limpa (`<repo>.2lp.in`) e termo de licença contidos na largura de 720px.

---

## 12. Perfis de Implementação (*Profiles*)

Esta norma GOST estabelece requisitos agnósticos a fornecedores e tecnologias. Ambientes específicos (organizações, indivíduos ou ecossistemas) **DEVEM** declarar suas escolhas concretas de infraestrutura em documentos de perfil sob o diretório `profiles/` (ex: `profiles/<nome>.md`).

Um perfil de implementação define:
- Qual forja de código hospeda os repositórios (Codeberg, GitHub, GitLab, etc.).
- Qual infraestrutura serve o portal de documentação (`*.2lp.in`, Cloudflare Workers, Pages, Nginx).
- Quais ferramentas e CLI gerenciam versionamento, tickets e hooks (ex: `cccp`).
- Quais frameworks e utilitários executam a suíte de testes, medem cobertura/mutação e aplicam linters com Zero Warnings.
- Como são gerados e validados os banners com Safe Zone 4:3 e os pacotes das 10 línguas.
- Onde se localiza o catálogo central de descoberta de projetos.



