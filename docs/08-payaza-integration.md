# 08. Payaza integration notes

Turbo's shareholders chose **Payaza** for wallet top-ups. Everything here comes from Payaza's public docs, read on 30 October 2026
([getting started](https://docs.payaza.africa/guides/getting-started), [mobile money collections](https://docs.payaza.africa/guides/momo-collections),
[webhooks](https://docs.payaza.africa/guides/webhooks)). Anything the docs do not say is listed as a question for Payaza at the bottom.

## What Payaza is for here

Payaza **collects** money. The wallet is **our ledger** (`03-domain-and-state-machines.md`); Payaza has no wallet product in the docs we read.
Top-up flow: student asks for a top-up, our server asks Payaza to collect, Payaza prompts the student's phone, a signed webhook tells us the result, we credit the ledger.

## Blocker: approval

- Ghana mobile money collections are **"available on request only"**. Turbo Mobility must email `support@payaza.africa` and be approved.
- Production needs **KYB** (business verification) in **Turbo Mobility's** name. So the Payaza account cannot be a Bevin account.
- Test requests work while KYB is in progress. Whether Ghana collections work in test mode before approval is not stated: ask.

Start the request now. It is the longest lead time in the whole payment path (decision D2, launch gate in `06-risks.md`).

## How it works (from the docs)

| Item | Detail |
| --- | --- |
| Networks | MTN, Vodafone, AirtelTigo (mobile money, currency GHS) |
| Collect | `POST https://api.payaza.africa/live/subsidiary/collections/v1/process-collection` |
| Status check | `GET https://api.payaza.africa/live/subsidiary/collections/v1/check-status?transaction_reference=...&country_code=GH` |
| Auth | `Authorization: Payaza <public key, base64>` (note: `Payaza`, not `Bearer`), plus `X-TenantID: test` or `live` |
| Sandbox | No separate URL. Same `/live/` path; `X-TenantID: test` switches mode, with test keys from the dashboard |
| Customer phone | 12 digits, country code first, **no `+`**: `233201234567` |
| Bank code | `customer_bank_code` varies by network; the docs link an external spreadsheet |
| Statuses | `00` success, `06` or `96` failed, `09` pending. **`09` is the normal first answer**, not a success |
| Prompt | Network sends a USSD prompt; student approves with MoMo PIN. No redirect |

## Webhooks

- Configure URLs in the Payaza dashboard (Settings, Developers), one per mode (test and live).
- Events: "Successful Collection" and "Failed Collection". Collection `transaction_status` is `Funds Received` or `Transaction Failed`.
- **Verify before anything else.** Header `x-payaza-signature` is the **base64 of HMAC-SHA512 of the raw request body**, keyed with your secret key (not base64-decoded).
  In Express, mount `express.raw({ type: 'application/json' })` on the webhook route **before** any JSON parser. Re-serialised JSON will not match.
- De-duplicate on `transaction_reference` (our `(provider, reference)` unique key does this).
- `amount_validation` is `EXACT`, `UNDERPAYMENT` or `OVERPAYMENT`. Credit the amount actually received, and flag any non-`EXACT` result for the finance role.
- A sample payload shows `channel: GH_MOBILEMONEY`, `amount_received`, `transaction_fee`, `merchant_reference`, `currency_code`.

## How it maps to our contract

| Our contract | Payaza |
| --- | --- |
| `POST /wallet/topups` (`channel: mobile_money`) | process-collection. Our `topups.reference` is the transaction reference we send |
| `Topup.checkout.type = prompt` | USSD prompt to the phone. App tells the student to approve on their phone |
| `Topup.status = pending` | Payaza status `09` |
| `POST /webhooks/payaza` | Collection webhook. Signature verified first |
| `Topup.status = succeeded` or `failed` | Webhook `Funds Received` or `Transaction Failed`; reconcile with check-status |
| Phone `+233XXXXXXXXX` | Strip the `+` at the adapter boundary only |
| Money in integer pesewas | Payaza uses decimal cedis (the docs show `140`). **Convert only inside the adapter, with integer maths**, never floats |

`channel: card` stays in the contract but is **not committed for v1**: the docs describe card collections generally and do not say Ghana cards are supported. Confirm before building.

## Questions to put to Payaza (none are answered in the docs)

1. Fee schedule for Ghana mobile money collections, and who bears the fee (decision D21).
2. Per-transaction and daily limits; minimum amount.
3. Settlement timing and into which account.
4. Webhook retry schedule and source IP addresses to allow.
5. Do Ghana collections work in test mode before KYB approval? Which test numbers behave how?
6. Are Ghana cards supported for collections?
7. Can a collection be reversed or refunded (for a top-up credited in error)?
8. Are payouts to Ghanaian mobile money wallets supported? (Only matters if withdrawals, decision D3, are ever added.)
9. Does Payaza hold or can it evidence the licences relevant to collecting from Ghanaian students (feeds decision D18)?

## Build order

1. Adapter interface (`createCollection`, `checkStatus`, `verifyWebhook`) with a **fake provider** for tests and the mock.
2. Payaza adapter against test mode once keys exist.
3. Webhook endpoint with raw-body signature check, de-duplication and ledger credit in one transaction.
4. Reconciliation job: list pending top-ups older than 10 minutes and call check-status.
