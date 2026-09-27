# Scripts de Automação GOST

Este diretório contém os utilitários canônicos de automação da norma **GOST** para inicialização e adequação de repositórios.

Os scripts foram desenhados para atender a dois propósitos simultâneos:
1. **Executáveis autônomos:** Funcionam em qualquer ambiente POSIX Shell (`/bin/sh`) sem dependências externas.
2. **Módulos integráveis ao `cccp`:** Podem ser incorporados como comandos nativos do ecossistema CCCP (ex: `cccp gost init` e `cccp gost conform`).

---

## 🛠️ Utilitários

### 1. `gost-init.sh` — Inicializador de Repositórios

Inicializa um diretório do zero com toda a anatomia raiz exigida pela norma GOST:
- `GOSTVER`
- `.gitignore` (agnóstico e completo)
- `VERSION` (`0.1.0-dev.1`)
- `CHANGELOG.md` (*Keep a Changelog*)
- `LICENSE` (CC0-1.0, MIT, GPL-3.0, CC-BY-SA-4.0 ou custom)
- `README.md`
- `site/index.html` e `site/_headers` (com cabeçalhos de segurança estrita)
- Inicialização do Git e ativação de hooks semânticos via `cccp install` (opcionais).

#### Uso Autônomo
```bash
# Inicializar no diretório atual com Rust e Shell sob licença MIT:
./scripts/gost-init.sh --lang rust,shell --license MIT

# Inicializar criando repositório Git em pasta alvo:
./scripts/gost-init.sh --root ~/src/meu-projeto --name meu-projeto --lang php --git --hooks

# Ver todas as opções:
./scripts/gost-init.sh --help
```

---

### 2. `gost-conform.sh` — Auditor e Adequador de Conformidade

Inspeciona e audita repositórios existentes em relação aos requisitos mínimos da norma GOST.
Opera de forma **idempotente**, nunca sobrescrevendo arquivos de código ou documentação já customizados.

- **Modo Auditoria (`--check` / `--dry-run`):** Apenas inspeciona o repositório e emite o checklist com o índice de conformidade. Retorna `0` se 100% conforme e `1` se houver pendências.
- **Modo Adequação (`--fix`):** Cria apenas os artefatos que estiverem ausentes. Quando `GOSTVER` não existir, infere automaticamente as linguagens do projeto (`Cargo.toml` $\to$ `rust`, `composer.json` $\to$ `php`, `package.json` $\to$ `javascript`, etc.).

#### Uso Autônomo
```bash
# Inspecionar conformidade (somente leitura):
./scripts/gost-conform.sh --check

# Adequar repositório existente:
./scripts/gost-conform.sh --root ~/src/projeto-existente --fix

# Ver todas as opções:
./scripts/gost-conform.sh --help
```

---

## 🔌 Incorporação no `cccp`

Ambos os scripts definem suas rotinas principais em funções exportáveis (`gost_init_main` e `gost_conform_main`) e possuem proteção de `source`:

```sh
# No cccp, para carregar o módulo:
export CCCP_SOURCED=1
. /caminho/para/gost-init.sh
. /caminho/para/gost-conform.sh

# Invocar diretamente:
gost_init_main "$@"
gost_conform_main "$@"
```

Dessa forma, o `cccp` pode empacotar ou despachar diretamente para esses utilitários nos subcomandos:
- `cccp gost init [opções]` $\to$ `gost_init_main`
- `cccp gost conform [opções]` $\to$ `gost_conform_main`
