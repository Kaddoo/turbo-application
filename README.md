# Turbo: student ride-hailing

Cashless, wallet-based ride-hailing for Central University students, starting at the Miotso campus (Prampram, Ghana).
Client: **Turbo**. Builder: **Bevin Business Solutions**.

Status: **planning**. API contract is a draft (`0.2.0`). Nothing is built yet.

## Read in this order

| # | File | What it settles |
| --- | --- | --- |
| 0 | [docs/00-scope-and-release-plan.md](docs/00-scope-and-release-plan.md) | What Release 1 is, what waits, and where the invoice and the requirements disagree |
| 1 | [docs/01-open-decisions.md](docs/01-open-decisions.md) | 27 open decisions (D22 to D27 come from the audit), the default we build against, who decides |
| 2 | [docs/02-architecture.md](docs/02-architecture.md) | Components, stack, assignment engine, money safety |
| 3 | [docs/03-domain-and-state-machines.md](docs/03-domain-and-state-machines.md) | Ride, verification and wallet lifecycles, invariants |
| 4 | [docs/04-business-rules.md](docs/04-business-rules.md) | Fares, eligibility, cancellations, refunds, with worked examples |
| 5 | [docs/05-work-plan.md](docs/05-work-plan.md) | Who builds what, in what order, and the hand-off process |
| 6 | [docs/06-risks.md](docs/06-risks.md) | Risk register and launch gates |
| 7 | [docs/07-repos-and-conventions.md](docs/07-repos-and-conventions.md) | Repos, branching, commits, CI, money and id conventions |
| 8 | [docs/08-payaza-integration.md](docs/08-payaza-integration.md) | Payaza facts from their docs, the approval blocker, mapping to our contract |
| 9 | [docs/09-feature-audit.md](docs/09-feature-audit.md) | Completeness audit: 26 gaps ranked S0 to S3, top 10 actions, 6 new decisions |
| 10 | [prompts/](prompts/) | Build prompts per surface: shared rules, landing page, admin portal, student web, student app, driver app |
| | [api/contract/openapi.yaml](api/contract/openapi.yaml) | **The API contract.** Source of truth |
| | [api/README.md](api/README.md) | Mock server, client generation, change process |
| | [LOG.md](LOG.md) | Session log and the entry template |
| | [docs/source/](docs/source/) | The original requirements PDF from Turbo |

## Team

| Person | Owns |
| --- | --- |
| Kevin | Student app (iOS, Android, web build) and driver app, both Flutter |
| Emmanuel | Brand guide, landing page, then a share of the API (see work plan) |
| Bethel | Admin dashboard, and the API core (money, rides, assignment) |

## The one rule

**Contract first.** No endpoint is coded until it exists in `api/contract/openapi.yaml` and all three developers have seen the change.
Everyone builds against the mock server from day one, so nobody waits for the API.

```bash
cd api
npx @stoplight/prism-cli mock contract/openapi.yaml      # mock API on http://localhost:4010
npx @redocly/cli lint contract/openapi.yaml              # must pass before every commit
npx @redocly/cli preview-docs contract/openapi.yaml      # browsable docs
```
