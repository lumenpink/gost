# Especificação Técnica: Metanorma Fundamental GOST v3.0.0

- **Ticket:** [#32](https://gambi.2lp.in/lumen/gost/issues/32)
- **Status:** Proposto / Em Desenvolvimento
- **Tier:** Fundamental
- **Norma:** GOST v3.0.0

---

## 1. Contexto e Motivação
A evolução do ecossistema de software demanda a formalização da **GOST** como a **Metanorma Fundamental** (*Grundnorm* / *Constituição do Ecossistema*), caracterizada pela neutralidade tecnológica perene e pela delimitação estrita de competências entre as camadas normativas.

A GOST v3.0.0 não dita escolhas de linguagens específicas nem nomes de ferramentas utilitárias; ela positiva os princípios universais de validade, a tipologia de normas, a gramática dos requisitos, a integridade da tríade normativa e o contrato canônico de documentação.

---

## 2. A Hierarquia Normativa de Quatro Camadas

O ecossistema estrutura-se em quatro esferas subordinadas de competência:

```text
[1. Metanorma Fundamental (GOST)]
               │
               ▼
   [2. Nível Estratégico (Plano Plurianual / Metodologia)]
               │
               ▼
   [3. Nível Tático (Engenharia, Toolchains e Contratos)]
               │
               ▼
   [4. Nível Operacional (Infraestrutura, Suprimento e Serviços)]
               │
               ▼
   [Autonomia Local (CUSTOM.md e custom-rules.toml)]
```

1. **Camada Fundamental (`tier: fundamental`):**
   - Papel constitucional e meta-regulatório.
   - Define a gramática de requisitos, a taxonomia, o ciclo de vida, a anatomia de documentos e as garantias de autonomia local e contingência.
2. **Camada Estratégica (`tier: strategic`):**
   - Diretrizes de longo prazo, filosofia de desenvolvimento, autonomia popular e o ciclo metodológico (ex.: ciclo DD-TDD de 9 fases).
3. **Camada Tática (`tier: tactical`):**
   - Homologação de toolchains, ambientes de compilação, contratos universais de CLI e interfaces comuns de desenvolvimento.
4. **Camada Operacional (`tier: operational`):**
   - Topologia física de infraestrutura, limites numéricos de retenção, esteiras de deploy e serviços de suprimento/estado.
5. **Autonomia Local (`tier: local`):**
   - Regras específicas declaradas pelo próprio projeto em `.gost/CUSTOM.md` e `.gost/custom-rules.toml`.

---

## 3. Princípio da Tríade Normativa Fechada

1. **Vinculação Estrita de Versão:**
   - Todo repositório de software regulado vincula-se a uma única norma operacional em versão imutável.
   - Toda norma operacional vincula-se formalmente a uma única versão imutável da norma tática que a embasa.
   - Toda norma tática vincula-se formalmente a uma única versão imutável da norma estratégica que a norteia, a qual ancora-se na metanorma fundamental.
2. **Proibição de Tags Instáveis e Prefixos Flutuantes:**
   - As versões de normas são declaradas exclusivamente em formato SemVer 2.0 limpo (`X.Y.Z`), sem prefixo `v`, sem tags flutuantes como `latest` e sem sufixos de desenvolvimento em releases publicadas.
3. **Imutabilidade e Rastreabilidade Histórica:**
   - Uma vez publicada, a tríade `(Operacional X.Y.Z -> Tática A.B.C -> Estratégica D.E.F)` é imutável, garantindo que qualquer auditoria futura recupere exatamente o mesmo corpo normativo vigente no momento da publicação.

---

## 4. Anatomia Canônica do Documento Normativo e Frontmatter Universal

Todo texto normativo em conformidade com o GOST **DEVE** ser redigido em Markdown UTF-8 com Frontmatter YAML obrigatório em inglês no topo do arquivo principal:

```yaml
---
standard: "gost"
tier: "fundamental"               # fundamental | strategic | tactical | operational | local
version: "3.0.0"                  # SemVer 2.0 estrito (sem prefixo v)
locale: "pt-br"                   # locale do documento canônico
authority: "Standards Committee"  # Autoridade emissora
published_at: "2026-11-07"        # Data de publicação ISO 8601
inherits_from:                    # Obrigatório para strategic, tactical e operational
  standard: "gost"
  tier: "fundamental"
  version: "3.0.0"
  base_url: "https://gost.2lp.in/3.0.0/"
---
```

### 4.1 A Convenção da `base_url`
- O campo `inherits_from.base_url` aponta para o diretório canônico da versão da norma no portal público (`https://<norma>.2lp.in/<versao>/`).
- Sob essa base URL residem deterministicamente os artefatos daquele pacote normativo:
  - `rules.toml`: Manifesto canônico de requisitos e regras.
  - `locales/<locale>.toml`: Catálogo de mensagens de erro e descrições no idioma correspondente.
  - `docs/<locale>/SPEC.md`: Texto integral da norma no idioma correspondente.
  - `docs/<locale>/rules/PREF-NNN.md`: Documentação individualizada com casos práticos e soluções.

---

## 5. Garantias Constitucionais: Repositório Limpo, Desativação e Contingência

1. **Princípio do Repositório Limpo e Separação de Estados:**
   - O repositório de código-fonte destina-se exclusivamente a código de domínio, documentação, testes e configuração essencial de build.
   - É expressamente vedado armazenar bancos de dados efêmeros, catálogos estáticos de terceiros ou arquivos transitórios de estado global no git.
2. **Autonomia de Desativação em Lote (`DISABLED_RULES`):**
   - Todo projeto regulado pode dispensar regras específicas declarando a variável `DISABLED_RULES = PREF-001, PREF-002` no arquivo `.gost/config`.
   - O motor de auditoria reconhece a dispensa e emite o status `[SKIP]` no relatório.
3. **Válvula de Contingência Extraordinária (`--force`):**
   - Os motores de governança e ferramentas de conformidade devem prover uma opção de força maior para situações críticas. O uso é excepcional e exige registro de justificativa técnica no laudo de ciclo.
