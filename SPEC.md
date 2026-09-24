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

Todo projeto em conformidade com o GOST **DEVE** declarar sua licença de forma explícita na raiz do repositório através de um arquivo `LICENSE` ou `UNLICENSE`.

### 2.1 Presunção de Domínio Público (`Unlicense`)
* **Regra Geral:** Todo repositório **DEVE** presumir, por padrão, a renúncia de direitos autorais e liberação irrestrita em domínio público via **`The Unlicense`** (ou alternativamente **`CC0-1.0`**).
* **Justificativa:** O conhecimento, ferramentas e códigos devem fluir com o menor atrito burocrático e jurídico possível, permitindo reuso irrestrito para qualquer finalidade.

### 2.2 Exceção de Copyleft Forte (`GPL-3.0`)
* **Regra de Exceção:** Quando um projeto possuir natureza estratégica que exija proteção contra apropriação predatória, fechamento de código derivado ou mercantilização comercial sem repasse à comunidade, o projeto **DEVE** adotar a **`GNU General Public License v3.0` (GPL-3.0)** (ou `AGPL-3.0` para serviços web).
* Qualquer exceção à presunção padrão de `Unlicense` **DEVE** ser justificada no `README.md` do projeto.

---

## 3. Anatomia Mínima da Raiz

Todo repositório GOST **DEVE** conter em sua raiz a seguinte estrutura mínima independente da stack ou linguagem utilizada:

```
.
├── LICENSE / UNLICENSE         # Termo legal de licenciamento (Seção 2)
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

O fluxo de trabalho em repositórios GOST **DEVE** seguir o ciclo rigoroso de **Documentation-Driven & Test-Driven Development (DD-TDD)**, composto por 5 etapas sequenciais com rastreabilidade formal via commits:

```
[1. Ticket] ──> [2. Doc in Develop] ──> [3. Failing Test] ──> [4. Fix / Implement] ──> [5. Finish Docs & Close]
```

### Etapa 1: Ticket / Issue
* Nenhuma modificação substancial (nova funcionalidade, correção de bug ou refatoração estrutural) **DEVE** ser iniciada sem um ticket ou issue de referência registrado no rastreador do projeto.
* O ticket define o problema, o objetivo e os critérios de aceitação.

### Etapa 2: Documentação em Desenvolvimento (`Doc in develop`)
* **Ação:** Antes de escrever qualquer linha de código produtivo, o autor **DEVE** documentar o comportamento esperado, arquitetura, formato de dados ou interface pretendida.
* **Commit:** **DEVE** ser feito um commit dedicado documentando o design no branch de desenvolvimento.
* **Mensagem:** `docs: specify <comportamento> (ref #<ticket>)`

### Etapa 3: Teste Falho (`Failing Test`)
* **Ação:** O autor **DEVE** escrever um teste automatizado (unitário, de integração ou especificação) que comprove o bug ou a ausência da funcionalidade planejada.
* **Condição:** O teste **DEVE FALHAR** obrigatoriamente.
* **Commit:** **DEVE** ser feito um commit dedicado contendo exclusivamente o teste falho.
* **Mensagem:** `test: add failing test for <requisito> (ref #<ticket>)`

### Etapa 4: Correção ou Implementação (`Fix / Implement`)
* **Ação:** Implementação do código estritamente necessário para fazer o teste da Etapa 3 passar com sucesso.
* **Commit:** **DEVE** ser feito um commit com o código produtivo e os testes agora verdes.
* **Mensagem:** `feat: implement <funcionalidade> (ref #<ticket>)` ou `fix: resolve <bug> (ref #<ticket>)`

### Etapa 5: Finalização da Documentação e Encerramento (`Finish Docs & Close`)
* **Ação:** Polimento final da documentação pública, atualização de exemplos, guias no site estático e atualização do `CHANGELOG.md`.
* **Commit:** **DEVE** ser feito um commit final referenciando o encerramento do ticket.
* **Mensagem:** `docs: finalize documentation and guides (closes #<ticket>)`

---

## 6. Vitrine Pública e Documentação Web

Todo repositório GOST **DEVE** manter uma vitrine pública de documentação estática no diretório `./site`.

1. **Acessibilidade Universal:** O site de documentação **NÃO DEVE** depender de etapas de compilação complexas para visualização básica; HTML/CSS/JS puros ou geradores ultra-leves são encorajados.
2. **Segurança HTTP:** O diretório de publicação **DEVE** conter cabeçalhos HTTP mínimos de segurança (arquivo `_headers` ou equivalente):
   - `X-Content-Type-Options: nosniff`
   - `X-Frame-Options: DENY`
   - `Referrer-Policy: strict-origin-when-cross-origin`
3. **Publicação Contínua:** A documentação **DEVE** ser publicada automaticamente via pipeline de CI/CD a cada push no branch principal (`main`).

---

## 7. Integração e Validação Contínua (CI/CD)

Todo repositório GOST **DEVE** possuir um pipeline de integração contínua declarativo:
1. **Validação de Sintaxe & Estilo:** Verificação automática de linter e formatação.
2. **Execução de Testes:** Execução da suíte completa de testes automatizados a cada branch e Pull/Merge Request.
3. **Publicação Automatizada:** Deploy automático do diretório `./site` para o serviço de hospedagem de páginas estáticas do projeto.

---

## 8. Perfis de Implementação (*Profiles*)

Esta norma GOST estabelece requisitos agnósticos a fornecedores e tecnologias. Ambientes específicos (organizações, indivíduos ou ecossistemas) **DEVEM** declarar suas escolhas concretas de infraestrutura em documentos de perfil sob o diretório `profiles/` (ex: `profiles/<nome>.md`).

Um perfil de implementação define:
- Qual forja de código hospeda os repositórios (Codeberg, GitHub, GitLab, etc.).
- Qual infraestrutura serve o portal de documentação (`*.2lp.in`, Cloudflare Workers, Pages, Nginx).
- Quais ferramentas e CLI gerenciam versionamento e hooks (ex: `cccp`).
- Onde se localiza o catálogo central de descoberta de projetos.
