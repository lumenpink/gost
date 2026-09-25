# Guia de Migração: GOST 0.1 ➔ GOST 1.0.0

Este documento resume as novidades normativas e os passos práticos para elevar um repositório existente ao padrão **GOST 1.0.0**.

---

## 1. Novos Requisitos Obrigatórios (*MUST*)

1. **Declaração `GOSTVER` (Seção 3):**
   - Inclusão do arquivo `GOSTVER` na raiz declarando a versão da norma e a URL do perfil adotado:
     ```sh
     GOST_VERSION="1.0.0"
     GOST_PROFILE_URL="https://.../perfil.md"
     ```
2. **Arquitetura de Domínio & SOLID Pragmático (Seção 12):**
   - Desacoplamento estrito entre o Core e subsistemas de I/O via Portas & Adaptadores (DIP).
   - Testes de domínio herméticos com execução em microssegundos utilizando In-Memory Fakes em vez de mocks pesados.
   - Validação e desinfecção na borda (*Parse, Don't Validate*), rejeitando Value Objects anêmicos sem comportamento.
   - Modelagem de estados finitos utilizando Enums nativos da linguagem.
3. **Padrões de Sistema e Operação (Seção 13):**
   - Aderência estrita à especificação XDG Base Directory com fallbacks universais (`~/.config`, `~/.local/share`, `~/.local/state`, `~/.cache`, `/run/user/$UID`).
   - Precedência de configuração padronizada: Flags > Env Vars > `.env` > Config Local > XDG Config > `/etc` > Defaults.
   - Formato plano `CHAVE=VALOR` compatível com POSIX Shell para arquivos de configuração editáveis.
   - Aplicação universal dos princípios Twelve-Factor (12-Factor).
   - Disciplina de streams: `stdout` puro para dados em pipe e `stderr` para logs, avisos e progresso. Suporte a `NO_COLOR` e detecção de TTY.
   - Proibição de SSLv2/v3 e TLS < 1.2. Prioridade QUIC/HTTP3 > HTTP/2 TLS 1.3. Preferência por Unix Domain Sockets para IPC local.
   - Containers OCI/Docker: Multi-stage obrigatório, execução non-root (`USER 1000:1000`), banimento de tags mutáveis (`:latest`), `.dockerignore` e `compose.yaml`.
   - Autenticação single-user via `Authorization: Bearer <key>`, suporte a `_FILE` e comparação estrita *timing-safe*.
4. **Protocolo de Comandos para Agentes de IA (Seção 5.5):**
   - Interações com agentes autônomos padronizadas via comandos diretos: `DCPD`, `DCP`, `PLAN`, `TDD`, `AUDIT`, `FIX` e `RELEASE`.

---

## 2. Novas Recomendações (*SHOULD*)

1. **Subdiretórios de Especificação por Língua (`specs/`):**
   - Organização de especificações em `specs/<lang>/` e regras como dado em `specs/rules.json`.
2. **Cards Sociais com Safe Zone 4:3 (Seção 11):**
   - Imagens Open Graph geradas em 1200x630 com miolo seguro entre 720px e 840px contra recortes em mensageiros móveis.

---

## 3. Checklist Rápido de Migração

- [ ] Criar arquivo `GOSTVER` na raiz apontando para `1.0.0`.
- [ ] Verificar se diretórios de arquivos locais no código respeitam `$XDG_*` com fallbacks.
- [ ] Confirmar se o `Dockerfile` utiliza multi-stage e `USER` não-root.
- [ ] Garantir que `.dockerignore` esteja presente na raiz.
- [ ] Validar cobertura com testes unitários em memória (≥90%).
- [ ] Rodar auditoria com `cccp gost check` (ou verificação de `specs/rules.json`).
