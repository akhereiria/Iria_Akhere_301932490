# Synthetic Fintech Account Ledger — SQL queries

## 1. Show related customer, account, ledger_entry records (up to 20).

```sql
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
```

| customer_id | customer_email | account_id | account_account_ref | ledger_entry_id | ledger_entry_entry_type |
| --- | --- | --- | --- | --- | --- |
| 1001 | ava.chen@example.test | 2001 | ACCT-SYN-001 | 3001 | debit |
| 1002 | noah.lee@example.test | 2002 | ACCT-SYN-002 | 3002 | credit |

## 2. Find ledger_entry records where posted_at matches "2026-10-05T12:15:00Z" (up to 20).

```sql
SELECT * FROM portfolio."ledger_entry"
WHERE "posted_at" IS NOT DISTINCT FROM '2026-10-05T12:15:00Z'
ORDER BY "id"
LIMIT 20;
```

| id | account_id | entry_type | amount | posted_at | external_ref |
| --- | --- | --- | --- | --- | --- |
| 3001 | 2001 | debit | 25.5 | 2026-10-05T12:15:00+00:00 | EXT-SYN-001 |

## 3. Count ledger_entry records for each account_id (up to 20 groups).

```sql
SELECT "account_id", count(*) AS record_count
FROM portfolio."ledger_entry"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
```

| account_id | record_count |
| --- | --- |
| 2001 | 1 |
| 2002 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.244 | 2.221, 2.266, 2.244 | Sort → Seq Scan | 274 |
| After index | 0.275 | 0.289, 0.275, 0.259 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.244 ms to 0.275 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.196..2.199 rows=50 loops=1)
  Seq Scan on ledger_entry (actual time=0.014..2.163 rows=50 loops=1)
Planning Time: 0.306 ms
Execution Time: 2.221 ms
```

### Before index, run 2

```text
Sort (actual time=2.239..2.241 rows=50 loops=1)
  Seq Scan on ledger_entry (actual time=0.013..2.205 rows=50 loops=1)
Planning Time: 0.284 ms
Execution Time: 2.266 ms
```

### Before index, run 3

```text
Sort (actual time=2.218..2.221 rows=50 loops=1)
  Seq Scan on ledger_entry (actual time=0.013..2.186 rows=50 loops=1)
Planning Time: 0.285 ms
Execution Time: 2.244 ms
```

### After index, run 1

```text
Sort (actual time=0.234..0.236 rows=50 loops=1)
  Bitmap Heap Scan on ledger_entry (actual time=0.032..0.197 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.017 rows=50 loops=1)
Planning Time: 0.502 ms
Execution Time: 0.289 ms
```

### After index, run 2

```text
Sort (actual time=0.22..0.224 rows=50 loops=1)
  Bitmap Heap Scan on ledger_entry (actual time=0.031..0.164 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.474 ms
Execution Time: 0.275 ms
```

### After index, run 3

```text
Sort (actual time=0.205..0.208 rows=50 loops=1)
  Bitmap Heap Scan on ledger_entry (actual time=0.031..0.168 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.492 ms
Execution Time: 0.259 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Iria_Akhere_301932490_P2_Queries.sql, then Iria_Akhere_301932490_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Iria_Akhere_301932490_P2_QueryResults.png) · [Index comparison](screenshots/Iria_Akhere_301932490_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

