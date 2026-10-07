# Perfis de Implementação GOST (*Implementation Profiles*)

A especificação central da norma **GOST** define princípios de arquitetura de software, ciclo de desenvolvimento (DD-TDD), metas rígidas de qualidade de testes e governança semântica agnósticos a fornecedores de nuvem, forjas de código e ferramentas específicas.

Para tornar esses requisitos operacionais no dia a dia, cada ecossistema, organização ou mantenedor declara suas escolhas concretas de infraestrutura em um **Perfil de Implementação**.

---

## 📋 Como Criar o Perfil da sua Organização

1. Copie o modelo oficial:
   👉 **[`profiles/template.md`](./template.md)**
2. Preencha as seções com as convenções da sua equipe (forja Git, plataforma de deploy web, runners de teste, linters e regras de CI/CD).
3. Hospede o documento do seu perfil em um repositório Git público ou gist.
4. Declare a URL direta do perfil no arquivo `GOSTVER` na raiz dos seus projetos:

```bash
# GOSTVER — Declaração de Conformidade com o Padrão GOST
GOST_VERSION="1.0.0"
GOST_PROFILE_URL="https://exemplo.org/meu-ecossistema/raw/branch/main/profile.md"
GOST_LANGUAGES="rust,shell"
```

---

## 🌐 Perfis de Referência

- **[gost-profile-kollontai](https://codeberg.org/lumenpink/gost-profile-kollontai)**: Perfil de implementação canônico Kollontai (Codeberg, CLI `cccp`, deploy em `*.2lp.in` via Cloudflare Workers / R2 e catálogo central).
