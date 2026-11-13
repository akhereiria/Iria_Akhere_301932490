# Synthetic Fintech Account Ledger — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| account_id | ledger_entry records (list) |
| --- | --- |
| 2001 | [3001] |
| 2002 | [3002] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| ledger_entry.id | ledger_entry.account_id | ledger_entry.entry_type | account.id | account.customer_id | account.account_ref | customer.id | customer.email |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 2001 | debit | 2001 | 1001 | ACCT-SYN-001 | 1001 | ava.chen@example.test |
| 3002 | 2002 | credit | 2002 | 1002 | ACCT-SYN-002 | 1002 | noah.lee@example.test |

Key: id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## ledger_entry_example

| ledger_entry.id | ledger_entry.account_id | ledger_entry.entry_type | account.id | account.customer_id | account.account_ref | customer.id | customer.email |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 3001 | 2001 | debit | 2001 | 1001 | ACCT-SYN-001 | 1001 | ava.chen@example.test |
| 3002 | 2002 | credit | 2002 | 1002 | ACCT-SYN-002 | 1002 | noah.lee@example.test |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| id | email | display_name | created_at |
| --- | --- | --- | --- |
| 1001 | ava.chen@example.test | Ava Chen | 2026-10-01T09:00:00+00:00 |
| 1002 | noah.lee@example.test | Noah Lee | 2026-10-02T10:30:00+00:00 |

## account

| id | customer_id | account_ref | currency | status | available_balance | opened_on |
| --- | --- | --- | --- | --- | --- | --- |
| 2001 | 1001 | ACCT-SYN-001 | USD | open | 1250.5 | 2026-10-03 |
| 2002 | 1002 | ACCT-SYN-002 | EUR | open | 800 | 2026-10-04 |

## ledger_entry

| id | account_id | entry_type | amount | posted_at | external_ref |
| --- | --- | --- | --- | --- | --- |
| 3001 | 2001 | debit | 25.5 | 2026-10-05T12:15:00+00:00 | EXT-SYN-001 |
| 3002 | 2002 | credit | 100 | 2026-10-06T14:45:00+00:00 | NULL |

## Dependencies

- customer: (id) → email, display_name, created_at
- account: (id) → customer_id, account_ref, currency, status, available_balance, opened_on
- ledger_entry: (id) → account_id, entry_type, amount, posted_at, external_ref

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
