# GOST Modular Specification: Política e Arquitetura de Licenciamento
**Identificador da Norma:** `legal-licenses`  
**Padrão Base:** GOST `1.0.0-draft` (Seção 2)  
**Status:** Oficial / Normativo  

---

## 1. Propósito e Filosofia

Esta especificação define a arquitetura jurídica de licenciamento para os repositórios desenvolvidos sob o padrão **GOST**.

O ecossistema reconhece que diferentes tipos de artefatos — código-fonte de sistemas executáveis, bibliotecas reutilizáveis, mídias criativas, marcas visuais e especificações normativas — demandam tratamentos jurídicos distintos para simultaneamente:
1. **Evitar Apropriação Predatória:** Proteger o código de aplicações completas contra fechamento por terceiros.
2. **Promover Interoperabilidade Máxima:** Facilitar a difusão de protocolos, bibliotecas e microapps utilitários sem atrito de licenciamento.
3. **Proteger a Identidade e Marcas:** Evitar adulteração de logotipos e insígnias de projetos consolidados.
4. **Garantir Liberdade de Expressão e Derivação Cultural:** Permitir remix e melhoria contínua de documentações e mídias via licenças livres de cultura.

---

## 2. Princípios Cardeais

### 2.1 Princípio da Menor Permissividade como Padrão Raiz
* O arquivo `LICENSE` na raiz do repositório **DEVE** representar a licença padrão e geral de todo o conteúdo não explicitamente excepcionado.
* Em repositórios com múltiplos tipos de artefatos (monorepos ou aplicações híbridas), o arquivo `LICENSE` da raiz **DEVE** conter a licença **menos permissiva** aplicável ao projeto (por exemplo, `GPL-3.0`).
* Quaisquer licenças mais permissivas (como `Apache-2.0` para um módulo de biblioteca ou `CC-BY-SA-4.0` para assets de mídia) ou com salvaguardas específicas de marca operam como **exceções explícitas**.

### 2.2 Princípio da Adequação Estrita ao Perfil (Anti-Bloat & Anti-Generic)
* **Cada repositório implementa estritamente o conjunto de licenças correspondente à sua natureza operacional.**
* **NÃO DEVE** haver colagem de textos genéricos universais de licenciamento em repositórios simples. Repositórios de microapps, comrades ou bibliotecas simples que utilizam exclusivamente `Apache-2.0` **NÃO DEVEM** conter arquivos satélites vazios (`LICENSE-MEDIA`, `LICENSE-LOGO`) nem referências no `README.md` a componentes que não existem no projeto.

---

## 3. Tipologia de Repositórios & Matriz de Licenças

| Perfil do Repositório | Escopo Típico | Arquivo Raiz `LICENSE` | Arquivos Satélites (se aplicável) | Justificativa |
|---|---|---|---|---|
| **Aplicações Completas & Monorepos Híbridos** | Apps de usuário final, ferramentas de terminal completas, daemons (ex: Mayak, Navalha) | `GPL-3.0` (ou `AGPL-3.0`) | `LICENSE-MEDIA`<br>`LICENSE-LOGO`<br>`LICENSE-APACHE` | Copyleft forte no software para coibir apropriação fechada; mídias livres e marca preservada. |
| **Microapps & Comrades** | Ferramentas pontuais, utilitários CLI minimalistas, automações auxiliares (ex: comrades/cli) | `Apache-2.0` | *Nenhum* (salvo presença real de mídias/logos isolados) | Baixo atrito, simplicidade extrema e livre distribuição no ecossistema. |
| **Bibliotecas, Protocolos & SDKs** | Crates, pacotes Composer/NPM/Python, interfaces de comunicação e clientes de rede | `Apache-2.0` | *Nenhum* | Máxima difusão e interoperabilidade com projetos GPL, proprietários ou corporativos. |
| **Especificações, Normas & Governança** | Documentos normativos, RFCs e diretrizes arquiteturais (ex: GOST) | `CC-BY-SA-4.0` | `LICENSE-LOGO` | Conhecimento público compartilhável sob mesma atribuição; esquemas/templates renunciados sob CC0. |

---

## 4. Arquivos Satélites Padronizados

Quando um repositório demandar tratamento diferenciado para subconjuntos de seus artefatos, ele **DEVE** utilizar as seguintes convenções canônicas de nomenclatura na raiz:

### 4.1 `LICENSE-MEDIA` (Creative Commons Atribuição-CompartilhaIgual 4.0 Internacional — `CC-BY-SA-4.0`)
* **Aplicação:** Imagens, ilustrações, texturas, arquivos de áudio, trilhas sonoras, vídeos, fontes tipográficas autorais e modelos 3D.
* **Exigência:** Obras derivadas devem manter o mesmo espírito livre e atribuir a autoria original.

### 4.2 `LICENSE-LOGO` (Creative Commons Atribuição-SemDerivações 4.0 Internacional — `CC-BY-ND-4.0`)
* **Aplicação:** Logotipos oficiais, marcas, insígnias, brasões, ícones de aplicação e identidade visual consolidada.
* **Exigência:** Permite a redistribuição e exibição pública sem custos (para referenciar o projeto), mas **proíbe alterações e versões modificadas da marca oficial** sem autorização explícita dos detentores da identidade.

### 4.3 `LICENSE-APACHE` (Apache License 2.0 — `Apache-2.0`)
* **Aplicação:** Bibliotecas, sub-crates ou módulos internos de código contidos dentro de um monorepo que são exportados como pacotes independentes para o ecossistema.
* **Exigência:** Permite que desenvolvedores externos consumam as bibliotecas sem a contaminação do copyleft integral da aplicação pai.

---

## 5. Mapeamento de Exceções no `README.md`

Todo repositório híbrido ou com arquivos satélites **DEVE** conter em seu `README.md`, sob a seção `## Licença`, uma tabela de mapeamento detalhando expressamente quais pastas ou arquivos estão subordinados a cada licença.

### 5.1 Exemplo: Aplicação Híbrida Completa (ex: Mayak / Navalha)
```markdown
## 📄 Licença

Este projeto é software livre licenciado sob a **GNU General Public License v3.0** (`GPL-3.0`), com exceções modulares para mídias, componentes reutilizáveis e identidade visual:

| Componente / Diretório | Licença | Arquivo |
|---|---|---|
| **Código-Fonte Geral da Aplicação** | GPLv3 | [`LICENSE`](./LICENSE) |
| **Mídias, Artes e Efeitos Sonoros** (`assets/media/`) | CC-BY-SA 4.0 | [`LICENSE-MEDIA`](./LICENSE-MEDIA) |
| **Logotipo e Identidade Visual** (`assets/brand/`) | CC-BY-ND 4.0 | [`LICENSE-LOGO`](./LICENSE-LOGO) |
| **Crate de Integração / SDK** (`crates/sdk/`) | Apache-2.0 | [`LICENSE-APACHE`](./LICENSE-APACHE) |
```

### 5.2 Exemplo: Microapp / Comrade (ex: comrade-cli)
```markdown
## 📄 Licença

Este projeto é distribuído sob os termos da **Apache License 2.0**.  
Consulte o arquivo [`LICENSE`](./LICENSE) para o texto legal completo.
```

### 5.3 Exemplo: Repositório de Especificação (ex: GOST)
```markdown
## 📄 Licença

* **Especificação Técnica e Textos Normativos:** Licenciados sob [Creative Commons Atribuição-CompartilhaIgual 4.0 Internacional (CC-BY-SA 4.0)](./LICENSE).
* **Esquemas JSON, Metadados e Templates de Configuração:** Dedicados ao domínio público sob [Creative Commons Zero 1.0 Universal (CC0-1.0)](https://creativecommons.org/publicdomain/zero/1.0/).
* **Identidade Visual e Insígnias Oficiais:** Licenciadas sob [Creative Commons Atribuição-SemDerivações 4.0 Internacional (CC-BY-ND-4.0)](./LICENSE-LOGO).
```

---

## 6. Validação Automatizada de Conformidade

O schema de regras `specs/rules.json` valida:
* A presença do arquivo raiz `LICENSE`.
* A conformidade da licença raiz com os valores válidos do GOST (`CC0-1.0`, `GPL-3.0`, `GPL-3.0-or-later`, `AGPL-3.0`, `Apache-2.0`, `CC-BY-SA-4.0`, `CC-BY-ND-4.0`).
* A conformidade com a convenção de satélites `LICENSE-MEDIA`, `LICENSE-LOGO` e `LICENSE-APACHE` quando declarados.
