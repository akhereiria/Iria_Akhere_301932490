# Synthetic Fintech Account Ledger — database design

My case study records customer, account, ledger_entry.

## Users

- Fintech operations analysts
- Database students

## Main operations

- Open an account for a customer.
- Post a positive debit or credit entry to an account.
- Review account activity and balances.
- Compare ledger date-filter plans with and without a B-tree index.

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A synthetic fintech customer who may own accounts. |
| account | A customer-owned account with a currency and current available balance. |
| ledger_entry | A posted debit or credit that records activity for one account. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| display_name | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## account

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| account_ref | TEXT | Unique | Yes |
| currency | TEXT |  | Yes |
| status | TEXT |  | Yes |
| available_balance | NUMERIC(18,2) |  | Yes |
| opened_on | DATE |  | Yes |
- customer_id → customer.id
- Unique key: (account_ref).

## ledger_entry

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| account_id | BIGINT | FK | Yes |
| entry_type | TEXT |  | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| posted_at | TIMESTAMPTZ |  | Yes |
| external_ref | TEXT |  | No |
- account_id → account.id

## Relationships and business rules

- Every customer must have a non-null email that is unique among customers.
- Every account must reference an existing customer through customer_id.
- Account available_balance must be greater than or equal to zero.
- Every ledger entry must reference an existing account through account_id.
- Every ledger entry amount must be greater than zero.
- When external_ref is non-null, it must be unique among ledger entries; multiple entries may have no external reference.

## Assumptions

- All records and values are synthetic. Database-generated entity IDs are globally unique across these entity tables.
- Each account belongs to exactly one customer, and each ledger entry belongs to exactly one account.
- Each account uses one currency; multi-currency conversion is outside scope.
- An account's available balance cannot be negative.
- Ledger entry amounts are positive; entry_type identifies debit or credit.
- A debit is posted only if the account has sufficient available balance.
- Timestamps use UTC, and posted ledger entries are not edited in this exercise.
- For the worked normalization example, start with ledger_entry and its account_id foreign key: keep account attributes in account and store only account_id on ledger_entry, avoiding repeated ancestor-role references.

