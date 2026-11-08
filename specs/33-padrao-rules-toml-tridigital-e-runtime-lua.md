# Especificação Técnica: Padrão rules.toml Tridigital e Runtime Lua com Interface gost

- **Ticket:** [#33](https://gambi.2lp.in/lumen/gost/issues/33)
- **Status:** Proposto / Em Desenvolvimento
- **Tier:** Fundamental
- **Norma:** GOST v3.0.0

---

## 1. Contexto e Motivação
Na Metanorma Fundamental GOST v3.0.0, todo requisito normativo auditável deve ser expresso como uma regra declarativa verificável de forma determinística.
Para assegurar perenidade, independência de plataforma, alta performance e separação estrita entre lógica de código e localização (i18n), o padrão adota:
1. **Identificadores Tridigitais Fixos:** Formato `PREF-001` a `PREF-999` (ex.: `GOST-001`, `GOSPLAN-001`, `KOLLONTAI-001`, `LILYA-001`, `CUSTOM-001`).
2. **Formato Declarativo `rules.toml`:** Suporte a blocos literais multilinhas para código Lua sem necessidade de escapes de aspas ou quebras de linha.
3. **Scripts de Validação em Lua com Namespace Canônico `gost.*`:** Biblioteca padrão segura injetada pelo interpretador de governança para consulta de arquivos, diretórios, linhas e metadados git.
4. **Desacoplamento de Localização (i18n):**
   - O script Lua retorna estritamente: `true` (em caso de conformidade) ou `false, "ERR_KEY", { param1 = val1, ... }` (em caso de inconformidade).
   - O arquivo `rules.toml` define o fallback canônico de mensagens em inglês (`[rules.<ID>.messages]`).
   - Os catálogos de tradução residem em `locales/<locale>.toml` (ex.: `locales/pt-br.toml`), realizando a interpolação de variáveis `{param}` sem duplicar scripts executáveis.
5. **Autonomia Local e Desativação em Lote:**
   - Suporte à diretiva `DISABLED_RULES` em `.gost/config` contendo lista separada por vírgula de IDs de regras a serem ignoradas.
   - Válvula de força maior `--force` para transposição emergencial com registro formal de justificativa.

---

## 2. Estrutura do Manifesto `rules.toml`

```toml
[rules.GOST-020]
name = "README-MAX-LINES"
description = "The README.md file must not exceed {max} lines"
severity = "error" # "error" | "warning"
scope = "root"     # "root" | "doc" | "src" | "ci" | "git"
docs_url = "https://gost.2lp.in/3.0.0/rules/GOST-020"
script = '''
local max_lines = 50
local lines = gost.count_lines("README.md")
if lines > max_lines then
    return false, "ERR_README_EXCEEDED", { count = lines, max = max_lines }
end
return true
'''

[rules.GOST-020.messages]
ERR_README_EXCEEDED = "README exceeds the standard ceiling of {max} lines (contains {count} lines)"
```

---

## 3. Catálogo de Mensagens Localizadas (`locales/pt-br.toml`)

```toml
[rules.GOST-020]
description = "O arquivo README.md não deve ultrapassar {max} linhas"
messages.ERR_README_EXCEEDED = "README excede o teto normativo de {max} linhas (possui {count} linhas)"
```

---

## 4. Biblioteca Padrão Lua (`gost.*`)
O ambiente de execução Lua expõe deterministicamente as seguintes primitivas:
- `gost.file_exists(path: string) -> boolean`
- `gost.is_dir(path: string) -> boolean`
- `gost.read_file(path: string) -> string | nil`
- `gost.count_lines(path: string) -> integer`
- `gost.list_files(dir: string, recursive: boolean) -> table`
- `gost.git_branch() -> string`
- `gost.git_commits(limit: integer) -> table`
- `gost.parse_toml(str: string) -> table`
- `gost.parse_json(str: string) -> table`
