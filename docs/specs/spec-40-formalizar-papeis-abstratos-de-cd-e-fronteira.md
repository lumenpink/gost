# Especificação Técnica — Ticket #40: Formalizar Papéis Abstratos de CD e Fronteira

## 1. Contexto & Motivação
A especificação fundamental GOST define os princípios de governança do ecossistema de software aberto. Com o refinamento da arquitetura em 5 pilares coesos, faz-se necessário expandir a tipificação abstrata da Seção 6.1 para incluir formalmente os papéis de *Agente de Entrega e Orquestração Contínua (CD)* e de *Controlador de Fronteira e Quarentena*.

## 2. Decisão Arquitetural
- **Consolidação dos 5 Papéis Abstratos do Ecossistema:**
  1. *Maestro Local:* Ciclo DD-TDD local, branches, commits e higiene.
  2. *Autoridade de Forja e Abastecimento:* Tickets, triagem assistida e catálogo.
  3. *Motor de Avaliação Normativa:* Regras declarativas e laudos.
  4. *Agente de Entrega e Orquestração Contínua (CD):* Despacho para storage externo, purga de staging, deploy de stacks e propagação de versões em cascata.
  5. *Controlador de Fronteira e Quarentena:* Sincronia de espelhos, reconciliação de webhooks e ingestão isolada em `inbox/*`.
- **Neutralidade Perene:** Manutenção estrita de zero nomes concretos de ferramentas ou tecnologias efêmeras no texto estratégico.

## 3. Alternativas Descartadas (Para a Natasha)
- **Alternativa Descartada 1: Fundir CD e Fronteira dentro de Forja/Abastecimento.**
  *Motivo do Descarte:* Fere a coesão de responsabilidades. CD lida com empacotamento, storage e infraestrutura de servidores; Fronteira lida com telemetria, webhooks e quarentena de contribuições públicas.
- **Alternativa Descartada 2: Deixar CD e Fronteira sem menção estratégica.**
  *Motivo do Descarte:* Deixaria lacunas na fundamentação dos contratos das camadas tática e operacional.

## 4. Verificação
- Verificação de ausência de nomes de ferramentas concretas.
- Sincronização entre `SPEC.md` e `specs/pt/SPEC.md`.
