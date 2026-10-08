#!/bin/sh
# =============================================================================
# gost-conform.sh — Auditor e Adequador de Conformidade GOST
# =============================================================================
# Este script verifica e adequa repositórios existentes aos padrões da norma
# GOST. Pode rodar em modo passivo (--check) para auditoria ou ativo (--fix)
# para criar arquivos ausentes. Pode ser executado de forma autônoma ou
# incorporado diretamente pelo CLI cccp (ex: 'cccp gost conform' ou 'cccp check').
# =============================================================================
set -eu

_gost_conform_colors() {
  if [ -z "${NO_COLOR:-}" ] && [ -t 1 ]; then
    GC_C_RESET='\033[0m'
    GC_C_BOLD='\033[1m'
    GC_C_GREEN='\033[0;32m'
    GC_C_YELLOW='\033[0;33m'
    GC_C_CYAN='\033[0;36m'
    GC_C_RED='\033[0;31m'
  else
    GC_C_RESET=''
    GC_C_BOLD=''
    GC_C_GREEN=''
    GC_C_YELLOW=''
    GC_C_CYAN=''
    GC_C_RED=''
  fi
}

gost_conform_usage() {
  cat << 'EOF'
Uso: gost-conform.sh [opções]

Audita e adequa um repositório existente aos padrões da norma GOST.

Opções:
  --root <dir>        Diretório alvo para inspeção/adequação (padrão: '.')
  --check, --dry-run  Apenas inspeciona e reporta ausências sem modificar arquivos (padrão)
  --fix               Cria os arquivos e estruturas ausentes de forma idempotente
  --lang <langs>      Força lista de linguagens caso GOSTVER precise ser criado
  -q, --quiet         Modo silencioso, útil para verificação em scripts e CI
  -h, --help          Exibe esta ajuda e sai

Códigos de Retorno:
  0                   Repositório 100% conforme ou adequação realizada com sucesso
  1                   Conformidade incompleta (quando em modo --check)
  2                   Erro de sintaxe nos argumentos

Exemplos:
  ./gost-conform.sh --root meu-app --check
  ./gost-conform.sh --root meu-app --fix
EOF
}

_gost_detect_languages() {
  _dir="$1"
  _detected=""

  [ -f "${_dir}/Cargo.toml" ] && _detected="${_detected:+$_detected,}rust"
  [ -f "${_dir}/composer.json" ] && _detected="${_detected:+$_detected,}php"
  [ -f "${_dir}/package.json" ] && _detected="${_detected:+$_detected,}javascript"
  [ -f "${_dir}/DESCRIPTION" ] && _detected="${_detected:+$_detected,}r"

  # Detecta scripts shell ou specs shellspec
  if [ -d "${_dir}/spec" ] || [ -n "$(find "$_dir" -maxdepth 2 -name "*.sh" 2>/dev/null | head -n 1)" ]; then
    _detected="${_detected:+$_detected,}shell"
  fi

  if [ -z "$_detected" ]; then
    echo "shell"
  else
    echo "$_detected"
  fi
}

gost_conform_main() {
  _gost_conform_colors

  GC_ROOT="."
  GC_MODE="check"
  GC_LANG=""
  GC_QUIET=0

  while [ $# -gt 0 ]; do
    case "$1" in
      --root)
        [ $# -gt 1 ] || { printf "%bErro: --root requer um caminho de diretório.%b\n" "$GC_C_RED" "$GC_C_RESET" >&2; return 2; }
        GC_ROOT="$2"
        shift 2
        ;;
      --check|--dry-run)
        GC_MODE="check"
        shift
        ;;
      --fix)
        GC_MODE="fix"
        shift
        ;;
      --lang)
        [ $# -gt 1 ] || { printf "%bErro: --lang requer uma lista de linguagens.%b\n" "$GC_C_RED" "$GC_C_RESET" >&2; return 2; }
        GC_LANG="$2"
        shift 2
        ;;
      -q|--quiet)
        GC_QUIET=1
        shift
        ;;
      -h|--help)
        gost_conform_usage
        return 0
        ;;
      *)
        printf "%bErro: Opção não reconhecida '%s'. Use --help para instruções.%b\n" "$GC_C_RED" "$1" "$GC_C_RESET" >&2
        return 2
        ;;
    esac
  done

  if [ ! -d "$GC_ROOT" ]; then
    printf "%bErro: Diretório '%s' não existe.%b\n" "$GC_C_RED" "$GC_ROOT" "$GC_C_RESET" >&2
    return 1
  fi

  _total_items=0
  _passed_items=0
  _failed_items=0
  _fixed_items=0

  _check_file() {
    _rel_path="$1"
    _rule_id="$2"
    _rule_desc="$3"
    _fix_cmd="$4"

    _total_items=$((_total_items + 1))
    _full_path="${GC_ROOT}/${_rel_path}"

    if [ -f "$_full_path" ] && [ -s "$_full_path" ]; then
      _passed_items=$((_passed_items + 1))
      if [ "$GC_QUIET" -eq 0 ]; then
        printf "  %b[PASS]%b  %-22s : %s (%s)\n" "$GC_C_GREEN" "$GC_C_RESET" "$_rule_id" "$_rule_desc" "$_rel_path"
      fi
    else
      if [ "$GC_MODE" = "fix" ] && [ -n "$_fix_cmd" ]; then
        eval "$_fix_cmd"
        _fixed_items=$((_fixed_items + 1))
        _passed_items=$((_passed_items + 1))
        if [ "$GC_QUIET" -eq 0 ]; then
          printf "  %b[FIXED]%b %-22s : %s (criado %s)\n" "$GC_C_CYAN" "$GC_C_RESET" "$_rule_id" "$_rule_desc" "$_rel_path"
        fi
      else
        _failed_items=$((_failed_items + 1))
        if [ "$GC_QUIET" -eq 0 ]; then
          printf "  %b[FAIL]%b  %-22s : %s (ausente ou vazio: %s)\n" "$GC_C_RED" "$GC_C_RESET" "$_rule_id" "$_rule_desc" "$_rel_path"
        fi
      fi
    fi
  }

  if [ "$GC_QUIET" -eq 0 ]; then
    printf "\n%b☭ GOST Conform — Auditoria & Adequação de Repositório%b\n" "$GC_C_BOLD" "$GC_C_RESET"
    printf "  Diretório Alvo : %s\n" "$GC_ROOT"
    printf "  Modo de Ação   : %s\n" "$GC_MODE"
    printf "────────────────────────────────────────────────────────────────────\n"
  fi

  # Auto-detecção de linguagens para geração se necessário
  _detected_lang="$GC_LANG"
  if [ -z "$_detected_lang" ]; then
    _detected_lang=$(_gost_detect_languages "$GC_ROOT")
  fi

  # 1. GOSTVER
  _total_items=$((_total_items + 1))
  _gostver_path="${GC_ROOT}/GOSTVER"
  if [ -f "$_gostver_path" ] && grep -q 'GOST_VERSION="1.4.0"' "$_gostver_path" 2>/dev/null; then
    _passed_items=$((_passed_items + 1))
    if [ "$GC_QUIET" -eq 0 ]; then
      printf "  %b[PASS]%b  %-22s : %s (GOSTVER v1.4.0)\n" "$GC_C_GREEN" "$GC_C_RESET" "GOST-01-GOSTVER" "Declaração de versão e escopo GOST"
    fi
  else
    if [ "$GC_MODE" = "fix" ]; then
      if [ -f "$_gostver_path" ]; then
        sed -i 's/GOST_VERSION=.*/GOST_VERSION="1.4.0"/' "$_gostver_path"
      else
        cat > "$_gostver_path" << EOF
# GOSTVER — Declaração de Conformidade com o Padrão GOST
GOST_VERSION="1.4.0"
GOST_PROFILE_URL=""
GOST_LANGUAGES="$_detected_lang"
EOF
      fi
      _fixed_items=$((_fixed_items + 1))
      _passed_items=$((_passed_items + 1))
      if [ "$GC_QUIET" -eq 0 ]; then
        printf "  %b[FIXED]%b %-22s : %s (atualizado para v1.4.0 em GOSTVER)\n" "$GC_C_CYAN" "$GC_C_RESET" "GOST-01-GOSTVER" "Declaração de versão e escopo GOST"
      fi
    else
      _failed_items=$((_failed_items + 1))
      if [ "$GC_QUIET" -eq 0 ]; then
        printf "  %b[FAIL]%b  %-22s : %s (GOSTVER ausente ou versão anterior)\n" "$GC_C_RED" "$GC_C_RESET" "GOST-01-GOSTVER" "Declaração de versão e escopo GOST"
      fi
    fi
  fi

  # 2. LICENSE
  _fix_license="cat > \"${GC_ROOT}/LICENSE\" << 'EOF'
CC0 1.0 Universal (CC0 1.0) Public Domain Dedication

The person who associated a work with this deed has dedicated the work to the
public domain by waiving all of his or her rights to the work worldwide under
copyright law, including all related and neighboring rights, to the extent
allowed by law.

You can copy, modify, distribute and perform the work, even for commercial
purposes, all without asking permission.
EOF"
  _check_file "LICENSE" "GOST-02-LICENSE" "Arquivo de licença de software" "$_fix_license"

  # 3. VERSION
  _fix_version="printf '%s\n' '0.1.0-dev.1' > \"${GC_ROOT}/VERSION\""
  _check_file "VERSION" "GOST-03-VERSION" "Arquivo SemVer 2.0.0" "$_fix_version"

  # 4. CHANGELOG.md
  _fix_changelog="cat > \"${GC_ROOT}/CHANGELOG.md\" << 'EOF'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Adequação aos padrões de engenharia da norma GOST.
EOF"
  _check_file "CHANGELOG.md" "GOST-04-CHANGELOG" "Histórico Keep a Changelog" "$_fix_changelog"

  # 5. README.md
  _proj_name=$(basename "$(cd "$GC_ROOT" && pwd)")
  _fix_readme="cat > \"${GC_ROOT}/README.md\" << EOF
# $_proj_name

Repositório adaptado ao padrão GOST.

## 📋 Conformidade GOST

Este projeto adota a norma **[GOST](https://codeberg.org/lumenpink/gost)** (Gosplan Standard for Technical Software).
EOF"
  _check_file "README.md" "GOST-05-README" "Documentação de entrada do repositório" "$_fix_readme"

  # 6. .gitignore
  _fix_gitignore="cat > \"${GC_ROOT}/.gitignore\" << 'EOF'
/target/
/vendor/
/node_modules/
/dist/
/build/
.cache/
*.tmp
*.log
.antigravity/
EOF"
  _check_file ".gitignore" "GOST-06-GITIGNORE" "Padrões de arquivos ignorados" "$_fix_gitignore"

  # 7. site/_headers
  _fix_headers="mkdir -p \"${GC_ROOT}/site\" && cat > \"${GC_ROOT}/site/_headers\" << 'EOF'
/*
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  Referrer-Policy: strict-origin-when-cross-origin
EOF"
  _check_file "site/_headers" "GOST-07-HEADERS" "Cabeçalhos HTTP de segurança estática" "$_fix_headers"

  # 8. site/index.html
  _fix_site="mkdir -p \"${GC_ROOT}/site\" && cat > \"${GC_ROOT}/site/index.html\" << EOF
<!DOCTYPE html>
<html lang=\"pt-BR\">
<head>
  <meta charset=\"UTF-8\">
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
  <title>$_proj_name — Documentação</title>
</head>
<body>
  <h1>$_proj_name</h1>
  <p>Documentação pública estática em conformidade com o padrão GOST.</p>
  <footer class=\"site-footer\" style=\"margin-top:2.5rem; padding-top:1.5rem; border-top:1px solid #333; text-align:center; font-size:0.85rem; line-height:1.6;\">
    <div>Orgulhosamente produzido por uma <a href=\"https://travesti.2lp.in/pt/\" target=\"_blank\" rel=\"noopener\">travesti latina</a> 🏳️‍⚧️ :)</div>
    <div style=\"margin-top:0.4rem; color:#888;\">$_proj_name • por <a href=\"https://lumen.pink\" target=\"_blank\" rel=\"noopener\">Lumen Pink</a> • Brasil 🇧🇷</div>
  </footer>
</body>
</html>
EOF"
  _check_file "site/index.html" "GOST-08-SITE" "Página estática de documentação pública" "$_fix_site"

  # 9. .antigravity/rules.md (Governança DD-TDD de Agentes de IA)
  _fix_rules="mkdir -p \"${GC_ROOT}/.antigravity\" && cat > \"${GC_ROOT}/.antigravity/rules.md\" << 'EOF'
# Regras de Repositório GOST para Agentes de IA

1. **Inviolabilidade das 9 Fases do Ciclo DD-TDD:**
   Todo trabalho neste repositório DEVE seguir estritamente o ciclo de 9 fases:
   \`Ticket (1) ➔ New Branch (2) ➔ Doc/Spec Contract (3) ➔ Red Failing Test (4) ➔ Green Implement (5) ➔ Refactor (6) ➔ Mutation Test (7) ➔ Quality Gate (8) ➔ Finish & Close (9)\`.

2. **Zero Código sem Ticket e Spec:**
   - É TERMINANTEMENTE PROIBIDO alterar qualquer linha de código de produção sem antes existir um ticket aberto e a especificação preliminar de documentação/contrato.
   - Na Fase 3 (Doc/Spec), é estritamente proibido alterar código de produção. Apenas arquivos de documentação, esquemas e contratos são permitidos.

3. **Isolamento de Branches:**
   - Nunca comitar ou realizar alterações diretamente na branch \`main\` ou \`develop\`.
   - Sempre criar branch dedicada no padrão \`<tipo>/<id>-<slug>\` (ex: \`feat/42-new-feature\`, \`fix/10-bug-fix\`).

4. **Blindagem de Testes & Mutation Testing:**
   - O teste deve ser comprovado falhando (Fase 4) antes de qualquer código ser escrito.
   - Na Fase 7, é obrigatório executar testes de mutação e aniquilar mutantes sobreviventes antes de fechar o ticket.

5. **Padrão Estrito de Commits:**
   - Todo commit intermediário DEVE conter \`(ref #<id>)\`.
   - O commit final de encerramento da Fase 9 DEVE conter \`(closes #<id>)\`.
   - Nunca criar commits automaticamente sem autorização inequívoca do usuário humano.
EOF"
  _check_file ".antigravity/rules.md" "GOST-09-AGENT-RULES" "Regras de governança DD-TDD para agentes de IA" "$_fix_rules"

  # 10. .forgejo/issue_template/ticket.md (Template de Issue DD-TDD)
  _fix_template="mkdir -p \"${GC_ROOT}/.forgejo/issue_template\" && cat > \"${GC_ROOT}/.forgejo/issue_template/ticket.md\" << 'EOF'
---
name: Ticket GOST (DD-TDD)
about: Abertura formal de ticket para o ciclo DD-TDD de 9 fases
title: \"tipo(escopo): descrição concisa\"
labels:
  - gost
---

## Description
<!-- Descreva o problema, a nova funcionalidade ou a necessidade de refatoração -->

## Expected Behavior & Acceptance Criteria
- [ ] Critério 1
- [ ] Critério 2

## Tasks / DD-TDD Checklist (9 Fases GOST)
- [ ] **Fase 1 - Ticket:** Issue formalizada e escopo delimitado
- [ ] **Fase 2 - Branch:** Branch \`<tipo>/<id>-<slug>\` criada a partir de develop/main
- [ ] **Fase 3 - Doc/Spec:** Contrato preliminar e especificação (Zero código de produção)
- [ ] **Fase 4 - Red:** Teste automatizado falho comprovando o requisito
- [ ] **Fase 5 - Green:** Implementação mínima funcional com teste passando
- [ ] **Fase 6 - Refactor:** Código limpo, idiomático e com Zero Warnings
- [ ] **Fase 7 - Mutation:** Mutantes críticos eliminados com asserções robustas
- [ ] **Fase 8 - Quality Gate:** Cobertura >= 90%, linter -D warnings e formatação validados
- [ ] **Fase 9 - Close:** Changelog e documentação atualizados; commit com \`(closes #<id>)\`
EOF"
  _check_file ".forgejo/issue_template/ticket.md" "GOST-10-TICKET-TPL" "Template de tickets DD-TDD no Forgejo" "$_fix_template"

  # 11. Verificação de hooks Git se for repositório git
  if [ -d "${GC_ROOT}/.git" ]; then
    _total_items=$((_total_items + 1))
    if [ -f "${GC_ROOT}/.git/hooks/commit-msg" ]; then
      _passed_items=$((_passed_items + 1))
      if [ "$GC_QUIET" -eq 0 ]; then
        printf "  %b[PASS]%b  %-22s : %s\n" "$GC_C_GREEN" "$GC_C_RESET" "GOST-11-GIT-HOOKS" "Git hooks semânticos configurados"
      fi
    else
      if [ "$GC_MODE" = "fix" ] && command -v cccp >/dev/null 2>&1; then
        (cd "$GC_ROOT" && cccp install >/dev/null 2>&1 || true)
        _fixed_items=$((_fixed_items + 1))
        _passed_items=$((_passed_items + 1))
        if [ "$GC_QUIET" -eq 0 ]; then
          printf "  %b[FIXED]%b %-22s : %s (instalado via cccp install)\n" "$GC_C_CYAN" "$GC_C_RESET" "GOST-09-GIT-HOOKS" "Git hooks semânticos instalados"
        fi
      else
        _failed_items=$((_failed_items + 1))
        if [ "$GC_QUIET" -eq 0 ]; then
          printf "  %b[FAIL]%b  %-22s : %s (execute 'cccp install')\n" "$GC_C_RED" "$GC_C_RESET" "GOST-09-GIT-HOOKS" "Git hooks semânticos não configurados"
        fi
      fi
    fi
  fi

  if [ "$_total_items" -gt 0 ]; then
    _pct=$(( (_passed_items * 100) / _total_items ))
  else
    _pct=100
  fi

  if [ "$GC_QUIET" -eq 0 ]; then
    printf "────────────────────────────────────────────────────────────────────\n"
    printf "Total de Itens: %d | Conformes: %d | Corrigidos: %d | Falhas: %d\n" \
      "$_total_items" "$_passed_items" "$_fixed_items" "$_failed_items"
    printf "Índice de Conformidade GOST: %b%d%%%b\n\n" "$GC_C_BOLD" "$_pct" "$GC_C_RESET"
  fi

  if [ "$_failed_items" -gt 0 ]; then
    if [ "$GC_QUIET" -eq 0 ]; then
      printf "%b⚠ O repositório possui pendências de conformidade. Execute com '--fix' para adequar automaticamente.%b\n\n" "$GC_C_YELLOW" "$GC_C_RESET"
    fi
    return 1
  fi

  if [ "$GC_QUIET" -eq 0 ]; then
    printf "%b✔ Repositório plenamente adequado aos padrões da norma GOST.%b\n\n" "$GC_C_GREEN" "$GC_C_RESET"
  fi

  return 0
}

# Se não for incluído via source por outro script (ex: cccp), executa a função principal:
if [ "${CCCP_SOURCED:-0}" != "1" ]; then
  gost_conform_main "$@"
fi
