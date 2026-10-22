# Perfil de Implementação GOST: Governança de Fronteira e Espelhos (`gost-profile-border`)

> **Especificação Normativa de Fronteira — GOST v1.6.0**  
> Este perfil normatiza a topologia de distribuição, espelhamento passivo e ingestão de contribuições externas em ecossistemas conformes ao padrão GOST.

---

**Identificador do Perfil:** `border` (`gost-profile-border`)  
**Mantenedor / Organização:** Lumen  
**Norma GOST Alvo:** `1.6.0`  
**URL Canônica deste Perfil:** `https://gostlumen.2lp.in/profiles/border.md`  
**Licença do Documento:** `CC0-1.0`

---

## 1. Visão Geral e Topologia

O Perfil de Fronteira estabelece que a forja primária local em Baquara (Forgejo) é a única Fonte Única da Verdade (SSOT). Forjas externas como GitHub e Codeberg são tratadas como terminais remotos subordinados de leitura e espelhamento.

Repositórios que adotam este profile declaram sua topologia através de tópicos na forja ou na tabela de metadados:

* `gost-mirror-gh`: Habilita o espelhamento passivo de saída e a ingestão ativa de tickets e Pull Requests a partir do GitHub.
* `gost-mirror-cb`: Habilita o espelhamento passivo de saída e a ingestão ativa de tickets e Pull Requests a partir do Codeberg.
* `gost-public-inbox`: Habilita a recepção de tickets anônimos (via formulário web na Banca ou via e-mail) e a materialização de Pull Requests externos sob quarentena.

---

## 2. Quarentena Estrita de Branches (`inbox/*`) — Regra GOST-25

O profile reserva o namespace `refs/heads/inbox/*` exclusivamente para o controlador de fronteira (`kontur`).

1. **Operação Exclusiva do Daemon:** Nenhuma operação manual deve ocorrer em branches `inbox/gh-pr-<ID>` ou `inbox/cb-pr-<ID>`.
2. **Isolamento de CI:** O Gosplan CI trata branches com prefixo `inbox/*` como zona não-confiável:
   * Execução estrita a compilação, linting e testes determinísticos offline;
   * Bloqueio total a segredos de produção, chaves de assinatura e publicação na Banca.
3. **Fusão e Fechamento Soberano:** Quando um Pull Request em `inbox/*` é integrado na branch `main` via `cccp merge`, o espelhamento empurra o commit para fora, e o daemon comanda o encerramento do PR original na forja externa.

---

## 3. Soberania de Provisionamento (Zero-Touch)

Sob este perfil, toda configuração das forjas externas é realizada de forma automatizada pelo provisionador soberano:
* Desativação de recursos parasitas (Wikis, Projects externos, GitHub Actions concorrentes);
* Sincronização de tópicos, descrições e URLs canônicas da Banca;
* Rotação e provisionamento determinístico de segredos HMAC para webhooks.

---

## 4. Declaração no `Cargo.toml` ou Metadados do Projeto

```toml
[package.metadata.gost.profile]
name = "gost-profile-border"
mirror_gh = true
mirror_cb = true
public_inbox = true
```
