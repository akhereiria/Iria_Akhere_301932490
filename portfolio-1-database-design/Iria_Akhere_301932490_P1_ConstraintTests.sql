-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk reject. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("id", "email", "display_name", "created_at")
VALUES (1001, 'pk-test@example.test', 'PK Test', '2026-10-07T08:00:00Z');

-- 2. customer unique reject. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("id", "email", "display_name", "created_at")
VALUES (9001, 'ava.chen@example.test', 'Unique Test', '2026-10-07T08:01:00Z');

-- 3. customer not null reject. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("id", "email", "display_name", "created_at")
VALUES (9002, 'not-null@example.test', NULL, '2026-10-07T08:02:00Z');

-- 4. account pk reject. Expected: pk_account, SQLSTATE 23505.
INSERT INTO portfolio."account" ("id", "customer_id", "account_ref", "currency", "status", "available_balance", "opened_on")
VALUES (2001, 1002, 'ACCT-PK-TEST', 'USD', 'open', 10, '2026-10-07');

-- 5. account unique reject. Expected: uq_account_0, SQLSTATE 23505.
INSERT INTO portfolio."account" ("id", "customer_id", "account_ref", "currency", "status", "available_balance", "opened_on")
VALUES (9003, 1001, 'ACCT-SYN-001', 'USD', 'open', 10, '2026-10-07');

-- 6. account fk reject. Expected: fk_account_0, SQLSTATE 23503.
INSERT INTO portfolio."account" ("id", "customer_id", "account_ref", "currency", "status", "available_balance", "opened_on")
VALUES (9004, 9901, 'ACCT-FK-TEST', 'USD', 'open', 10, '2026-10-07');

-- 7. ledger pk reject. Expected: pk_ledger_entry, SQLSTATE 23505.
INSERT INTO portfolio."ledger_entry" ("id", "account_id", "entry_type", "amount", "posted_at", "external_ref")
VALUES (3001, 2002, 'credit', 10, '2026-10-07T08:03:00Z', 'EXT-PK-TEST');

-- 8. ledger fk reject. Expected: fk_ledger_entry_0, SQLSTATE 23503.
INSERT INTO portfolio."ledger_entry" ("id", "account_id", "entry_type", "amount", "posted_at", "external_ref")
VALUES (9005, 9902, 'credit', 10, '2026-10-07T08:04:00Z', 'EXT-FK-TEST');

-- 9. account check reject. Expected: account_nonnegative_balance, SQLSTATE 23514.
INSERT INTO portfolio."account" ("id", "customer_id", "account_ref", "currency", "status", "available_balance", "opened_on")
VALUES (9006, 1001, 'ACCT-CHECK-TEST', 'USD', 'open', -1, '2026-10-07');

-- 10. ledger check reject. Expected: ledger_positive_amount, SQLSTATE 23514.
INSERT INTO portfolio."ledger_entry" ("id", "account_id", "entry_type", "amount", "posted_at", "external_ref")
VALUES (9007, 2001, 'debit', 0, '2026-10-07T08:05:00Z', 'EXT-CHECK-TEST');

-- 11. ledger partial unique reject. Expected: ledger_external_ref_partial_unique, SQLSTATE 23505.
INSERT INTO portfolio."ledger_entry" ("id", "account_id", "entry_type", "amount", "posted_at", "external_ref")
VALUES (9008, 2001, 'credit', 10, '2026-10-07T08:06:00Z', 'EXT-SYN-001');
