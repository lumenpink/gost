#!/bin/sh
# =============================================================================
# gost-init.sh — Inicializador Canônico de Repositórios GOST
# =============================================================================
# Este script inicializa novos repositórios ou diretórios existentes em estrita
# conformidade com a norma GOST. Pode ser executado de forma autônoma ou
# incorporado diretamente pelo CLI cccp (ex: 'cccp gost init').
# =============================================================================
set -eu

_gost_init_colors() {
  if [ -z "${NO_COLOR:-}" ] && [ -t 1 ]; then
    GI_C_RESET='\033[0m'
    GI_C_BOLD='\033[1m'
    GI_C_GREEN='\033[0;32m'
    GI_C_YELLOW='\033[0;33m'
    GI_C_CYAN='\033[0;36m'
    GI_C_RED='\033[0;31m'
  else
    GI_C_RESET=''
    GI_C_BOLD=''
    GI_C_GREEN=''
    GI_C_YELLOW=''
    GI_C_CYAN=''
    GI_C_RED=''
  fi
}

gost_init_usage() {
  cat << 'EOF'
Uso: gost-init.sh [opções]

Inicializa um diretório com todos os artefatos da anatomia raiz exigidos
pelo padrão GOST (GOSTVER, VERSION, CHANGELOG, LICENSE, README, site/_headers, etc).

Opções:
  --root <dir>        Diretório alvo para inicialização (padrão: '.')
  --name <nome>       Nome do projeto (padrão: nome do diretório alvo)
  --desc <texto>      Descrição sucinta do projeto
  --lang <langs>      Linguagens ativas separadas por vírgula (ex: shell,rust,php)
  --profile <url>     URL canônica do Perfil de Implementação (opcional)
  --license <spdx>    Licença padrão (padrão: CC0-1.0; opções: MIT, GPL-3.0, CC-BY-SA-4.0, Apache-2.0)
  --git               Inicializa repositório Git local caso não exista (branch main)
  --hooks             Executa 'cccp install' se a CLI cccp estiver disponível
  -q, --quiet         Modo silencioso, omite mensagens informativas
  -h, --help          Exibe esta ajuda e sai

Exemplos:
  ./gost-init.sh --root meu-app --lang rust,shell --license MIT --git
  ./gost-init.sh --lang php,javascript --desc "Portal de documentação pública"
EOF
}

_gost_write_file_if_missing() {
  _target="$1"
  _content="$2"
  _label="$3"

  if [ -f "$_target" ]; then
    if [ "$GI_QUIET" -eq 0 ]; then
      printf "  %b[EXISTE]%b %s (preservado)\n" "$GI_C_YELLOW" "$GI_C_RESET" "$_label"
    fi
  else
    _dir=$(dirname "$_target")
    [ -d "$_dir" ] || mkdir -p "$_dir"
    printf "%s\n" "$_content" > "$_target"
    if [ "$GI_QUIET" -eq 0 ]; then
      printf "  %b[CRIADO]%b %s\n" "$GI_C_GREEN" "$GI_C_RESET" "$_label"
    fi
  fi
}

_gost_license_text() {
  _spdx="$1"
  _year=$(date +%Y 2>/dev/null || echo "2026")
  _owner="${GI_NAME:-Projeto}"

  case "$_spdx" in
    CC0-1.0|CC0)
      cat << 'EOF'
CC0 1.0 Universal (CC0 1.0) Public Domain Dedication

The person who associated a work with this deed has dedicated the work to the
public domain by waiving all of his or her rights to the work worldwide under
copyright law, including all related and neighboring rights, to the extent
allowed by law.

You can copy, modify, distribute and perform the work, even for commercial
purposes, all without asking permission.
EOF
      ;;
    MIT)
      cat << EOF
MIT License

Copyright (c) $_year $_owner

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
      ;;
    CC-BY-SA-4.0|CC-BY-SA)
      cat << EOF
Creative Commons Attribution-ShareAlike 4.0 International (CC-BY-SA 4.0)

You are free to:
- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material for any purpose, even commercially.

Under the following terms:
- Attribution — You must give appropriate credit, provide a link to the license,
  and indicate if changes were made.
- ShareAlike — If you remix, transform, or build upon the material, you must
  distribute your contributions under the same license as the original.
EOF
      ;;
    GPL-3.0|GPLv3)
      cat << EOF
GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007

Copyright (C) $_year $_owner

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
EOF
      ;;
    *)
      cat << EOF
Software License: $_spdx
Copyright (c) $_year $_owner
EOF
      ;;
  esac
}

gost_init_main() {
  _gost_init_colors

  GI_ROOT="."
  GI_NAME=""
  GI_DESC=""
  GI_LANG="shell"
  GI_PROFILE=""
  GI_LICENSE="CC0-1.0"
  GI_DO_GIT=0
  GI_DO_HOOKS=0
  GI_QUIET=0

  while [ $# -gt 0 ]; do
    case "$1" in
      --root)
        [ $# -gt 1 ] || { printf "%bErro: --root requer um caminho de diretório.%b\n" "$GI_C_RED" "$GI_C_RESET" >&2; return 2; }
        GI_ROOT="$2"
        shift 2
        ;;
      --name)
        [ $# -gt 1 ] || { printf "%bErro: --name requer um valor.%b\n" "$GI_C_RED" "$GI_C_RESET" >&2; return 2; }
        GI_NAME="$2"
        shift 2
        ;;
      --desc)
        [ $# -gt 1 ] || { printf "%bErro: --desc requer um texto.%b\n" "$GI_C_RED" "$GI_C_RESET" >&2; return 2; }
        GI_DESC="$2"
        shift 2
        ;;
      --lang)
        [ $# -gt 1 ] || { printf "%bErro: --lang requer uma lista de linguagens.%b\n" "$GI_C_RED" "$GI_C_RESET" >&2; return 2; }
        GI_LANG="$2"
        shift 2
        ;;
      --profile)
        [ $# -gt 1 ] || { printf "%bErro: --profile requer uma URL.%b\n" "$GI_C_RED" "$GI_C_RESET" >&2; return 2; }
        GI_PROFILE="$2"
        shift 2
        ;;
      --license)
        [ $# -gt 1 ] || { printf "%bErro: --license requer um identificador SPDX.%b\n" "$GI_C_RED" "$GI_C_RESET" >&2; return 2; }
        GI_LICENSE="$2"
        shift 2
        ;;
      --git)
        GI_DO_GIT=1
        shift
        ;;
      --hooks)
        GI_DO_HOOKS=1
        shift
        ;;
      -q|--quiet)
        GI_QUIET=1
        shift
        ;;
      -h|--help)
        gost_init_usage
        return 0
        ;;
      *)
        printf "%bErro: Opção não reconhecida '%s'. Use --help para instruções.%b\n" "$GI_C_RED" "$1" "$GI_C_RESET" >&2
        return 2
        ;;
    esac
  done

  [ -d "$GI_ROOT" ] || mkdir -p "$GI_ROOT"

  if [ -z "$GI_NAME" ]; then
    _abs_path=$(cd "$GI_ROOT" && pwd)
    GI_NAME=$(basename "$_abs_path")
  fi

  if [ -z "$GI_DESC" ]; then
    GI_DESC="Repositório em conformidade com o padrão GOST"
  fi

  if [ "$GI_QUIET" -eq 0 ]; then
    printf "%b☭ GOST Init — Inicializando repositório em '%s'%b\n" "$GI_C_BOLD" "$GI_ROOT" "$GI_C_RESET"
    printf "  Projeto: %s | Linguagens: %s | Licença: %s\n" "$GI_NAME" "$GI_LANG" "$GI_LICENSE"
    printf "────────────────────────────────────────────────────────────────────\n"
  fi

  # 1. Git Init se solicitado
  if [ "$GI_DO_GIT" -eq 1 ] && [ ! -d "${GI_ROOT}/.git" ]; then
    (cd "$GI_ROOT" && git init -b main >/dev/null 2>&1 || git init >/dev/null 2>&1)
    if [ "$GI_QUIET" -eq 0 ]; then
      printf "  %b[GIT]%b Repositório Git inicializado na branch main\n" "$GI_C_GREEN" "$GI_C_RESET"
    fi
  fi

  # 2. GOSTVER
  _gostver_content=$(cat << EOF
# GOSTVER — Declaração de Conformidade com o Padrão GOST
GOST_VERSION="1.1.0"
GOST_PROFILE_URL="$GI_PROFILE"
GOST_LANGUAGES="$GI_LANG"
EOF
)
  _gost_write_file_if_missing "${GI_ROOT}/GOSTVER" "$_gostver_content" "GOSTVER"

  # 3. .gitignore
  _gitignore_content=$(cat << 'EOF'
# Dependências e compilação
/target/
/vendor/
/node_modules/
/dist/
/build/

# Caches e arquivos temporários
.cache/
*.tmp
*.log
.DS_Store

# Metadados de agentes locais
.antigravity/
EOF
)
  _gost_write_file_if_missing "${GI_ROOT}/.gitignore" "$_gitignore_content" ".gitignore"

  # 4. VERSION
  _gost_write_file_if_missing "${GI_ROOT}/VERSION" "0.1.0-dev.1" "VERSION"

  # 5. CHANGELOG.md
  _changelog_content=$(cat << 'EOF'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Inicialização do repositório em conformidade com o padrão GOST.
EOF
)
  _gost_write_file_if_missing "${GI_ROOT}/CHANGELOG.md" "$_changelog_content" "CHANGELOG.md"

  # 6. LICENSE
  _license_content=$(_gost_license_text "$GI_LICENSE")
  _gost_write_file_if_missing "${GI_ROOT}/LICENSE" "$_license_content" "LICENSE ($GI_LICENSE)"

  # 7. README.md
  _readme_content=$(cat << EOF
# $GI_NAME

$GI_DESC

## 📋 Conformidade GOST

Este projeto adota a norma **[GOST](https://codeberg.org/lumenpink/gost)** (Gosplan Standard for Technical Software).
- **Versão GOST:** \`1.1.0\`
- **Linguagens declaradas:** \`$GI_LANG\`
- **Licença:** \`$GI_LICENSE\`

## 🚀 Como Iniciar

\`\`\`bash
# Clonar o repositório
git clone <url-do-repositorio>
cd $GI_NAME

# Verificar conformidade
cccp check
\`\`\`

## 📄 Licença

Distribuído sob a licença [$GI_LICENSE](./LICENSE).
EOF
)
  _gost_write_file_if_missing "${GI_ROOT}/README.md" "$_readme_content" "README.md"

  # 8. site/_headers e site/index.html
  _headers_content=$(cat << 'EOF'
/*
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  Referrer-Policy: strict-origin-when-cross-origin
EOF
)
  _gost_write_file_if_missing "${GI_ROOT}/site/_headers" "$_headers_content" "site/_headers"

  _site_index_content=$(cat << EOF
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$GI_NAME — Documentação</title>
  <style>
    body { font-family: monospace, sans-serif; max-width: 800px; margin: 40px auto; padding: 0 20px; line-height: 1.6; }
    h1 { border-bottom: 2px solid #333; padding-bottom: 8px; }
    .badge { display: inline-block; padding: 2px 8px; background: #eee; border: 1px solid #ccc; font-size: 0.9em; }
  </style>
</head>
<body>
  <h1>$GI_NAME</h1>
  <p>$GI_DESC</p>
  <p><span class="badge">GOST v1.1.0</span> <span class="badge">$GI_LICENSE</span></p>
</body>
</html>
EOF
)
  _gost_write_file_if_missing "${GI_ROOT}/site/index.html" "$_site_index_content" "site/index.html"

  # 9. Ativação de hooks do cccp
  if [ "$GI_DO_HOOKS" -eq 1 ] || [ -d "${GI_ROOT}/.git" ]; then
    if command -v cccp >/dev/null 2>&1; then
      (cd "$GI_ROOT" && cccp install >/dev/null 2>&1 || true)
      if [ "$GI_QUIET" -eq 0 ]; then
        printf "  %b[HOOKS]%b Hooks semânticos ativados via 'cccp install'\n" "$GI_C_GREEN" "$GI_C_RESET"
      fi
    fi
  fi

  if [ "$GI_QUIET" -eq 0 ]; then
    printf "────────────────────────────────────────────────────────────────────\n"
    printf "%b✔ Inicialização GOST concluída com sucesso em '%s'.%b\n" "$GI_C_GREEN" "$GI_ROOT" "$GI_C_RESET"
  fi

  return 0
}

# Se não for incluído via source por outro script (ex: cccp), executa a função principal:
if [ "${CCCP_SOURCED:-0}" != "1" ]; then
  gost_init_main "$@"
fi
