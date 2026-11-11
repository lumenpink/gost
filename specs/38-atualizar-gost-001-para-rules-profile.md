# Especificação Técnica: Atualizar GOST-001 para .rules/profile.toml (Ticket #38)

## 1. Contexto e Motivação
A migração da arquitetura de normas do ecossistema substitui o arquivo legado `GOSTVER` na raiz pelo manifesto desacoplado `.rules/profile.toml`.

O primeiro axioma fundamental da metanorma raiz (`GOST-001`), definido em `specs/rules.toml`, ainda verificava a existência estrita do arquivo `GOSTVER`. Com isso, repositórios migrados falhavam na auditoria fundamental.

## 2. Decisões Arquiteturais e Alternativas Descartadas (Para a Natasha)
- **Validação de `.rules/profile.toml`:**
  - *Decisão:* O script Lua de `GOST-001` passa a inspecionar prioritariamente `.rules/profile.toml` (com fallback transitório para `GOSTVER` caso repositórios legados ainda o contenham).
  - *Alternativa descartada:* Exigir que repositórios migrados criem symlink de `.rules/profile.toml` para `GOSTVER`. Descartada por poluir a raiz e quebrar o agnosticismo.
- **Nome e Mensagens da Regra:**
  - *Decisão:* Nome padronizado como `RULES-PROFILE-REQUIRED`. Mensagens de erro canônicas em inglês (`ERR_RULES_PROFILE_MISSING`, `ERR_RULES_PROFILE_EMPTY`).
  - *Tradução:* Atualização correspondente em `specs/locales/pt-br.toml` e na documentação viva `docs/rules/GOST-001.md`.

## 3. Contrato da Regra
```toml
[rules.GOST-001]
name = "RULES-PROFILE-REQUIRED"
severity = "error"
scope = "root"
docs_url = "https://gost.2lp.in/3.0.0/rules/GOST-001"
description = "The repository must contain a non-empty .rules/profile.toml file declaring its normative profile"
script = '''
local has_profile = gost.file_exists(".rules/profile.toml")
local has_gostver = gost.file_exists("GOSTVER")
if not has_profile and not has_gostver then
    return false, "ERR_RULES_PROFILE_MISSING", {}
end
local content = gost.read_file(".rules/profile.toml") or gost.read_file("GOSTVER")
if not content or #content:match("^%s*(.-)%s*$") == 0 then
    return false, "ERR_RULES_PROFILE_EMPTY", {}
end
return true
'''
[rules.GOST-001.messages]
ERR_RULES_PROFILE_MISSING = "Normative profile configuration '.rules/profile.toml' is missing"
ERR_RULES_PROFILE_EMPTY = "Normative profile configuration '.rules/profile.toml' is empty"
```
