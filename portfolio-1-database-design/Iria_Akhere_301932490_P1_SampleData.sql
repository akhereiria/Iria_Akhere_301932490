-- Fictional sample records for Synthetic Fintech Account Ledger.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("id", "email", "display_name", "created_at") VALUES (1001, 'ava.chen@example.test', 'Ava Chen', '2026-10-01T09:00:00Z');
INSERT INTO portfolio."customer" ("id", "email", "display_name", "created_at") VALUES (1002, 'noah.lee@example.test', 'Noah Lee', '2026-10-02T10:30:00Z');
INSERT INTO portfolio."account" ("id", "customer_id", "account_ref", "currency", "status", "available_balance", "opened_on") VALUES (2001, 1001, 'ACCT-SYN-001', 'USD', 'open', 1250.5, '2026-10-03');
INSERT INTO portfolio."account" ("id", "customer_id", "account_ref", "currency", "status", "available_balance", "opened_on") VALUES (2002, 1002, 'ACCT-SYN-002', 'EUR', 'open', 800, '2026-10-04');
INSERT INTO portfolio."ledger_entry" ("id", "account_id", "entry_type", "amount", "posted_at", "external_ref") VALUES (3001, 2001, 'debit', 25.5, '2026-10-05T12:15:00Z', 'EXT-SYN-001');
INSERT INTO portfolio."ledger_entry" ("id", "account_id", "entry_type", "amount", "posted_at", "external_ref") VALUES (3002, 2002, 'credit', 100, '2026-10-06T14:45:00Z', NULL);
COMMIT;
