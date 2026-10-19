# GOST — Technical Standard for Open Repositories
**Standard Version:** `1.0.0-draft`  
**Status:** Official / Normative Proposal  
**Reference:** ГОСТ (Государственный Стандарт / General Open Source Standard)

---

## 1. Scope and Purpose

This specification defines structural, methodological, governance, and documentation requirements for the creation, maintenance, and lifecycle of open-source software repositories.

The objective of GOST is to eliminate friction when creating new projects, guarantee complete historical traceability, ensure maximal software freedom, and impose engineering rigor driven by documentation and testing.

The key words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** in this document are to be interpreted as described in [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

---

## 2. Philosophy and Licensing

Every GOST-compliant repository **MUST** explicitly declare its license in the root directory via a `LICENSE` file. The detailed modular technical specification is in [specs/legal/licenses.md](../legal/licenses.md).

### 2.1 Least Permissive Root License Principle
* **Root Rule:** The root `LICENSE` file **MUST** be the default, general license for the entire repository.
* In repositories with mixed artifacts (monorepos or hybrid applications), the root `LICENSE` **MUST** declare the least permissive (most restrictive) license applicable (e.g., `GPL-3.0`).
* More permissive licenses (e.g., `Apache-2.0` for sub-crates or `CC-BY-SA-4.0` for media) operate as explicit modular exceptions.

### 2.2 Repository Profile Typology
1. **Full Applications / Hybrid Monorepos (e.g., Mayak, Navalha):** Adopt `GPL-3.0` (or `AGPL-3.0` for web services) in the root `LICENSE`.
2. **Microapps & Comrades (e.g., comrades/cli):** Adopt `Apache-2.0` in the root `LICENSE` directly, without superfluous satellite files.
3. **Libraries, Protocols & SDKs:** Adopt `Apache-2.0` in the root `LICENSE` for maximum interoperability.
4. **Specifications and Norms (e.g., GOST):** Adopt `CC-BY-SA-4.0` for normative texts in the root `LICENSE`, with schemas and templates in `CC0-1.0` and logos protected via satellites.

### 2.3 Standardized Satellite Files
When artifacts require distinct legal frameworks, the following canonical files **MUST** be used in root:
* `LICENSE-MEDIA`: Creative Commons Attribution-ShareAlike 4.0 International (`CC-BY-SA-4.0`) for media, audio, video, fonts, and illustrations.
* `LICENSE-LOGO`: Creative Commons Attribution-NoDerivatives 4.0 International (`CC-BY-ND-4.0`) for trademarks, insignia, official icons, and brand logos.
* `LICENSE-APACHE`: Apache License 2.0 (`Apache-2.0`) for internal modules, sub-crates, or decoupled libraries exposed to the ecosystem.

### 2.4 Mandatory Mapping in `README.md`
Repositories with multiple artifact types or satellite licenses **MUST** include a mapping matrix in their `README.md` under `## License`, explicitly stating which paths and files fall under each license.

### 2.5 Anti-Boilerplate Principle
Each repository implements solely the licenses suited to its actual profile. Blindly copying universal boilerplate tables and empty satellite files into simple micro-utilities is strictly forbidden.

---

## 3. Minimal Root Anatomy

Every GOST repository **MUST** maintain the following minimal baseline in its root directory regardless of stack or language:

```text
.
├── GOSTVER                     # Standard version and profile declaration
├── LICENSE                     # Default legal licensing declaration (Section 2)
├── LICENSE-MEDIA               # (Optional) CC-BY-SA license for media and assets
├── LICENSE-LOGO                # (Optional) CC-BY-ND license for brand and logos
├── LICENSE-APACHE              # (Optional) Apache-2.0 license for internal libraries
├── VERSION                     # Semantic version in plain text (SemVer 2.0.0)
├── CHANGELOG.md                # Chronological change record (Keep a Changelog)
├── README.md                   # Executive summary and quickstart guide
├── .gitignore                  # Repository hygiene and ignored files
├── .editorconfig               # Canonical formatting for editors
├── site/                       # Static public documentation portal
│   ├── index.html              # Documentation entry point
│   └── _headers                # Mandatory HTTP security headers
└── .forgejo/ / .github/        # Declarative CI/CD automation
    └── workflows/ci.yml
```

---

## 4. Versioning and Changelog

### 4.1 `VERSION` File
* The repository **MUST** maintain a `VERSION` file in the root containing strictly the current project version in UTF-8 plain text with a trailing newline.
* The version format **MUST** adhere strictly to [Semantic Versioning 2.0.0](https://semver.org/) (`MAJOR.MINOR.PATCH[-PRERELEASE]`).

### 4.2 `CHANGELOG.md` File
* The repository **MUST** maintain a human-readable changelog following [Keep a Changelog](https://keepachangelog.com/).
* Categories: `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`.

---

## 5. Development Cycle (DD-TDD)

The workflow in GOST repositories **MUST** follow a strict **Documentation-Driven & Test-Driven Development (DD-TDD)** cycle divided into 9 sequential, indivisible phases, governed by strict ticket traceability and branch isolation.

### 5.1 Stone Clauses of the Cycle
1. **Inviolability of the 9 Phases:** All 9 stages **MUST** be executed in strict sequence for any modification (features, bugfixes, refactorings, or chore/maintenance). Skipping, reordering, or batching stages is strictly forbidden.
2. **Zero Code Without Ticket and Prior Spec/Contract:** **NO PRODUCTION CODE MAY BE MODIFIED WITHOUT AN OPEN TICKET AND PRIOR WRITTEN SPECIFICATION/CONTRACT DOCUMENTATION**.
3. **Strict Isolation of the Documentation Phase:** During the documentation/spec phase (Phase 3), touching production code is **STRICTLY PROHIBITED**. Only contracts, interface signatures, type definitions, schemas, and architectural docs are permitted.
4. **Strict Commit Traceability and Canonical Closing Tag:**
   - Every task **MUST** originate from a formal issue in the tracker before any code changes.
   - Intermediate commits **MUST** include ticket reference as `(ref #<id>)`.
   - The final closing commit in Phase 9 **MUST** strictly contain the canonical tag `(closes #<id>)` (lowercase, parenthesized with hash and issue number) to formally settle the ticket. Synonyms and unparenthesized tags are strictly rejected.
   - **Mandatory Merge Gatekeeper in CCCP:** The `cccp` orchestrator or merge mechanism **MUST NOT** permit merging a branch into the base branch (`main`/`develop`) if the branch lacks the closing commit bearing the canonical `(closes #<id>)` tag matching the branch ticket ID.
   - Commit hooks (`commit-msg`) and CI/CD **MUST** reject commits lacking explicit ticket references.
5. **No Direct Commits to Base Branch:** Direct commits to `main` or `develop` are strictly **FORBIDDEN**. All work resides on dedicated ticket branches until approved.
6. **CCCP Ticket Management Sovereignty:** All issue lifecycle operations (creation, consultation, Divan triage, and closure) **MUST** be performed exclusively via the sovereign `cccp` CLI (`cccp ticket`, `cccp divan`). Manipulating issues directly via ad-hoc third-party tooling (`tea`, `gh`, `glab`) or manual web UI actions is strictly **PROHIBITED**.

#### 5.2 Branch Strategy and Local-First Governance
* Work branches: `feat/<id>-<slug>`, `fix/<id>-<slug>`, `docs/<id>-<slug>`, `refactor/<id>-<slug>`, `test/<id>-<slug>`, `chore/<id>-<slug>`.
* **Local-First Branch Governance:** Dedicated ticket branches reside and are developed strictly in the **local** environment. Pushing work branches (`feat/*`, `fix/*`, etc.) to the remote forge is strictly **PROHIBITED**.
* **Taxative Exception for Multidev Collaboration:** Pushing a work branch to the remote forge is permitted **only and exclusively upon express, taxative instruction**, justified by the necessity of concurrent multi-developer collaboration on the same branch. Outside of this explicit request, pushing work branches is considered an anti-pattern.
* The entire 9-phase DD-TDD cycle and branch integration (`cccp merge <branch>`) occur locally. Only the integrated and verified main branch (`main`) is pushed to the remote forge (along with semantic tags and ephemeral deploy branch `pages`).

### 5.3 The 9 Canonical Stages of DD-TDD and Commit Matrix
```text
[1. Ticket] 
    └──> [2. New Branch] 
            └──> [3. Doc / Spec Contract] 
                    └──> [4. Red: Failing Test] 
                            └──> [5. Green: Implement] 
                                    └──> [6. Refactor to Excellence] 
                                            └──> [7. Mutation Test & Fortify] 
                                                    └──> [8. Quality Gate & Local Audit] 
                                                            └──> [9. Finish Docs & Close]
```

#### Canonical Commit Matrix per Phase

| Phase | Phase Name | Commit Generation | Canonical Format & Convention |
|:---:|---|:---:|---|
| **1** | **Ticket / Issue** | ❌ **PROHIBITED** | *Zero repository commits (tracker operation).* |
| **2** | **New Branch** | ❌ **NO** | *Zero commits (local branch creation only).* |
| **3** | **Doc / Spec Contract** | ✅ **MANDATORY** | `docs: specify <behavior> (ref #<id>)` *(zero production code).* |
| **4** | **Red: Failing Test** | ✅ **MANDATORY** | `test: add failing test for <requirement> (ref #<id>)` *(verified failure).* |
| **5** | **Green: Implement** | ✅ **MANDATORY** | `feat: implement <feature> (ref #<id>)` or `fix: resolve <bug> (ref #<id>)`. |
| **6** | **Refactor to Excellence** | 🟡 **CONDITIONAL / MANDATORY** | `refactor: polish and optimize <scope> (ref #<id>)` *(if refactored).* |
| **7** | **Mutation Test & Fortify** | 🟡 **CONDITIONAL / ATOMIC DUAL** | `test: eliminate surviving mutants in <scope> (ref #<id>)` *(tests first)*;<br>`refactor: eliminate dead code and redundant logic in <scope> (ref #<id>)` *(code second)*. |
| **8** | **Quality Gate & Local Audit** | ⚠️ **CONDITIONAL / RARE** | `fix: lint and formatting hygiene (ref #<id>)` *(if adjustments required).* |
| **9** | **Finish Docs & Close** | ✅ **MANDATORY** | `docs: finalize changelog and docs (closes #<id>)` *(or final commit with closes).* |

1. **Phase 1: Ticket / Issue (Planning & Scope):** Open formal issue specifying context, expected behavior, and acceptance criteria. No code changes.
2. **Phase 2: New Branch (Strict Isolation):** Create dedicated branch `<type>/<id>-<slug>` from base branch.
3. **Phase 3: Doc / Spec Contract (Design Prior to Code):** Write specs, API contracts, schemas, and markdown docs on branch. **Zero production code edits allowed.** Commit: `docs: specify <behavior> (ref #<id>)`.
4. **Phase 4: Red - Failing Test (Proof of Defect/Requirement):** Write automated unit/functional test exercising contract. Test **MUST fail**. Commit: `test: add failing test for <requirement> (ref #<id>)`.
5. **Phase 5: Green - Implement / Fix (Minimal Solution):** Implement minimal production code required to make tests pass. Commit: `feat: implement <feature> (ref #<id>)` or `fix: resolve <bug> (ref #<id>)`.
6. **Phase 6: Refactor to Excellence (Code Hygiene):** Polish production code and tests for readability, idiomatic style, and zero warnings. Tests remain 100% green. Commit: `refactor: polish and optimize <scope> (ref #<id>)`.
7. **Phase 7: Mutation Test & Fortify (Dual Atomic Commits and Order):** Run mutation testing.
   - **Case A (Weak Assertions / Missing Edge Cases):** Update **tests only** with stricter assertions: `test: eliminate surviving mutants in <scope> (ref #<id>)`.
   - **Case B (Dead Code / Redundant Logic Revealed):** Simplify **production code**: `refactor: eliminate dead code and redundant logic in <scope> (ref #<id>)`.
   - **Mandatory Order:** When both apply, **tests must be strengthened and committed first**, followed immediately by production code refactoring.
8. **Phase 8: Quality Gate & Local Audit (Local Verification):** Execute linters at `-D warnings` (Zero Warnings), deterministic formatting (`fmt`), type-checking, and verify coverage floor ≥ 90% (target 100%).
9. **Phase 9: Finish Docs & Close Ticket (Consolidation):** Update user docs (`./site`, `README.md`), finalize `CHANGELOG.md`, and create final closing commit with canonical tag: `docs: finalize changelog and docs (closes #<id>)`.

### 5.4 Handling Specific Task Types
* **Bugfixes (`fix`):** Phase 3 specifies broken contract vs expected behavior; Phase 4 is the regression test reproducing bug.
* **Refactoring (`refactor`):** Phase 3 specifies invariants; Phase 4 adds tests covering previously untested edge cases to safeguard invariants.
* **Pure Documentation (`docs`):** Code phases (4–7) are marked `N/A`, but branch isolation, intermediate `(ref #<id>)`, and final `(closes #<id>)` remain mandatory.

### 5.5 Definition of Done (DoD)
A ticket is closed via `(closes #<id>)` only when:
- [ ] Ticket opened prior to coding (Phase 1).
- [ ] Dedicated branch created (Phase 2).
- [ ] Contract/spec documented before code (Phase 3).
- [ ] Failing test committed prior to implementation (Phase 4).
- [ ] Functional code implemented and all tests passing (Phase 5).
- [ ] Refactored for clean code and zero warnings (Phase 6).
- [ ] No surviving critical mutants from mutation testing (Phase 7).
- [ ] Local quality gates passed: coverage ≥ 90%, zero warnings, deterministic format (Phase 8).
- [ ] User documentation, `README.md`, and `CHANGELOG.md` updated (Phase 9).
- [ ] CI/CD pipeline 100% green.

### 5.6 AI Agent Operational Dispatch Protocol
When collaborating with AI agents, interactions **MUST** use deterministic operational commands:
* **`DCPD` (Do, Commit, Push, Deploy):** Full end-to-end authorization: implements, tests, commits with `(closes #N)`, merges locally via `cccp merge`, closes ticket, and pushes `main` to trigger deploy.
* **`DCP` (Do, Commit, Push):** Implements, tests, commits, and pushes **strictly upon taxative instruction for multidev collaboration**, keeping branch and PR open on forge.
* **`PLAN` (Plan & Propose):** Diagnostic research and formal proposal without modifying files or committing.
* **`TDD` (Ticket, Branch, Doc, Red, Green, Refactor, Mutate, Gate, Close):** Strict sequential execution of the **9 canonical DD-TDD stages**: branch creation, pre-code spec (**zero code changes in doc phase**), failing test, implementation, refactoring, mutation tests, quality gate audit, and closing commit.
* **`AUDIT` (Audit & Check):** Passive repository audit (linters, coverage, mutation, dependency security, dead links) without code changes.
* **`FIX` (Fix & Clean):** Targeted cleanup of linter warnings, mutants, and formatting without altering domain logic.
* **`RELEASE` (Release & Tag):** Changelog consolidation, SemVer bump via `cccp release`, and tag publication.

---

## 6. Testing Strategy and Quality

1. **Mandatory Test Taxonomy:** Unit Tests (in-memory, instant), Functional Tests, Integration Tests, End-to-End Tests (headless via Playwright).
2. **Coverage Floor:** Minimum **90%** global coverage; CI blocks regressions. Target **100%** on core domain.
3. **Mutation Testing:** Verification of assertion quality via synthetic fault injection.
4. **Hermeticity:** Complete network isolation for unit/integration suites; zero dependencies on external services.

---

## 7. Static Analysis & Zero Warnings

1. **Zero Warnings Policy:** Linters and compilers treated with fatal severity (`-D warnings`). Warnings break CI.
2. **Anti-Bloat:** Minimal third-party dependencies. Continuous dependency vulnerability audits.
3. **Deterministic Formatting:** Enforced formatting tools (`rustfmt`, `pint`, `shfmt`, `biome/prettier`).
4. **Universal Editor Hygiene:** `.editorconfig` enforcing UTF-8, LF, and trailing whitespace trimming.

---

## 8. Public Showcase and Web Documentation (`site/`)

1. Public documentation deployed from `./site` with HTTP security headers (`_headers`).
2. Segregation: `./site` contains static documentation only; dynamic backends are accessed privately via WireGuard/Tailscale or authenticated tunnels.
3. Resilient mobile pattern: Idempotent requests (`client_id`), decoupled queues, and indestructible short polling.
4. **Canonical Two-Line Footer:** All public documentation sites (`./site`) and interfaces **MUST** display the canonical two-line footer:
   - **Line 1 (Identity & Sovereign Assertion):** `Proudly produced by a [Latin American travesti](https://travesti.2lp.in/<lang>/) 🏳️‍⚧️ :)` (the term *travesti* remains untranslated in all languages).
   - **Line 2 (Metadata & Licensing):** `{App} v{Version} • by [Lumen Pink](https://lumen.pink) • {Country} 🇧🇷 • [{License}](LICENSE)`

---

## 9. CI/CD Pipeline

1. **Strict Job Separation & Pipeline-Only Builds:** Jobs for `test` (lint, unit tests, coverage, static analysis) are separated from `deploy-*` jobs. All final distribution binaries, release packages, and production artifacts **MUST** be compiled exclusively within hermetic CI/CD pipeline runners. Heavy local release builds (`cargo build --release`, cross-compilation) are **STRICTLY PROHIBITED** on the developer workstation.
2. **Lightweight Pre-Push Gate & Pre-Tag Act Gate:** The git `pre-push` hook **MUST NOT** run heavy containerized runners (`act`). Pre-push operates as an instantaneous semantic verification gate (validating `VERSION` file synchronization, tag consistency, and commit ticket references). Containerized validation via `act` is executed exclusively as a **Pre-Tag Gate** during release tagging (`cccp tag`).
3. **Banca Canonical Sovereign Distribution & R2 Storage:** The **Banca** (`https://banca.2lp.in/downloads/`) is the canonical sovereign distribution authority. Compiled binaries, packages, and installer bundles **MUST NOT** bloat git forge storage or releases. Artifacts are published to Cloudflare R2 with a strict retention cap of **5 stable releases** (`stable-latest`) and **10 nightly builds** (`nightly-latest`), coordinated via an atomic `index.json` manifest.
4. **Deploy Branch Hygiene (Stateless Single-Commit Force Push):** Dedicated git deployment branches (such as `pages`) **MUST** purge previous build history via orphan worktrees (`--orphan`), pushing a single clean commit with `git push --force origin <branch>`.

---

## 10. Internationalization (Intl Matrix)

1. Canonical 10 languages: `en`, `pt`, `es`, `fr`, `de`, `it`, `ru`, `zh`, `ja`, `ar`.
2. Full parity across app interfaces and public documentation.
3. Bidirectional (RTL) support mandatory for Arabic (`ar`).
4. Primary language declared in `.cccprc` serves as runtime fallback.

---

## 11. Social Cards & 4:3 Safe Zone (KokoroSim Standard)

1. Banner dimensions: exactly 1200x630 px.
2. Central 4:3 safe zone (720px - 840px width) immune to 1:1 mobile crops.
3. Strict character limits for `og:title` (50-65) and `og:description` (120-155).

---

## 12. Pragmatic Domain Architecture & SOLID (DIP)

1. **Ports & Adapters (DIP):** Core domain never depends on I/O, databases, or web frameworks. Dependencies point inward.
2. **In-Memory Fakes:** Unit tests run in microseconds using lightweight in-memory fake adapters instead of brittle mocking frameworks.
3. **Parse, Don't Validate:** Strict boundary validation. Core operates on reliable primitives, rejecting empty anemic Value Objects.
4. **Native Enums for State:** Finite state machines represented via native enums with exhaustive matching.
5. **Gradation Principle:** Simplicity for single-purpose CLI utilities vs full hexagonal separation for complex services.

---

## 13. System Standards, 12-Factor & OCI Containers

1. **XDG Base Directory:** Enforced `$XDG_CONFIG_HOME`, `$XDG_DATA_HOME`, `$XDG_STATE_HOME`, `$XDG_CACHE_HOME`, and `$XDG_RUNTIME_DIR` with strict fallbacks. No dotfiles loose in `$HOME`.
2. **Configuration Precedence:** Flags > Environment Variables > Local `.env` > Repo Config > User XDG > `/etc` > Defaults. Flat `KEY="value"` POSIX-compatible format.
3. **Universal 12-Factor:** Applied to services, daemons, and CLIs alike.
4. **Unix Streams & NO_COLOR:** Pure `stdout` for pipeable data, `stderr` for logs/warnings. Automatic TTY detection and `NO_COLOR` compliance.
5. **Modern Networking:** Deprecation of SSLv2/v3 and TLS < 1.2. Priority: QUIC/HTTP3 > HTTP/2 TLS 1.3 > HTTP/1.1. UNIX Domain Sockets for local IPC.
6. **OCI/Docker Standards:** Multi-stage builds, non-root execution (`USER 1000:1000`), no `:latest` tags, mandatory `.dockerignore`, and standard `compose.yaml`.
7. **Single-User Auth:** `Authorization: Bearer <key>`, secret loading via env or `_FILE`, and constant-time comparison against timing attacks.

---

## 14. Implementation Profiles

Infrastructure and provider choices are decoupled into external profile documents (referenced via `GOST_PROFILE_URL` in `GOSTVER`).

### 14.1 Cascading Profile Inheritance (`extends`)
Derived profiles support cascading inheritance to reuse organizational defaults while specifying author- or project-level specializations:
1. **Parent Declaration:** Declared via `extends: <URL>` in profile metadata frontmatter (e.g., `extends: "https://kollontai.2lp.in/profile.md"`).
2. **Deep Override Precedence:** All directives from the parent are inherited; any section or field defined in the child has sovereign precedence (*deep override*).
3. **Leaf Resolution:** Projects declare only the leaf profile URL in `GOSTVER`; tooling recursively resolves parent profiles.
