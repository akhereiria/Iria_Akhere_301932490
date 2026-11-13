-- Show related customer, account, ledger_entry records (up to 20).
SELECT t0."id" AS "customer_id",
       t0."email" AS "customer_email",
       t1."id" AS "account_id",
       t1."account_ref" AS "account_account_ref",
       t2."id" AS "ledger_entry_id",
       t2."entry_type" AS "ledger_entry_entry_type"
FROM portfolio."customer" t0
JOIN portfolio."account" t1 ON t1."customer_id" = t0."id"
JOIN portfolio."ledger_entry" t2 ON t2."account_id" = t1."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."id" AS "customer_id",
       t0."email" AS "customer_email",
       t1."id" AS "account_id",
       t1."account_ref" AS "account_account_ref",
       t2."id" AS "ledger_entry_id",
       t2."entry_type" AS "ledger_entry_entry_type"
FROM portfolio."customer" t0
JOIN portfolio."account" t1 ON t1."customer_id" = t0."id"
JOIN portfolio."ledger_entry" t2 ON t2."account_id" = t1."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

-- Find ledger_entry records where posted_at matches "2026-10-05T12:15:00Z" (up to 20).
SELECT * FROM portfolio."ledger_entry"
WHERE "posted_at" IS NOT DISTINCT FROM '2026-10-05T12:15:00Z'
ORDER BY "id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."ledger_entry"
WHERE "posted_at" IS NOT DISTINCT FROM '2026-10-05T12:15:00Z'
ORDER BY "id"
LIMIT 20;

-- Count ledger_entry records for each account_id (up to 20 groups).
SELECT "account_id", count(*) AS record_count
FROM portfolio."ledger_entry"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "account_id", count(*) AS record_count
FROM portfolio."ledger_entry"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
