-- Synthetic Fintech Account Ledger: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customer" (
  "id" bigint NOT NULL,
  "email" text NOT NULL,
  "display_name" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_customer" PRIMARY KEY ("id"),
  CONSTRAINT "uq_customer_0" UNIQUE ("email")
);
CREATE TABLE portfolio."account" (
  "id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "account_ref" text NOT NULL,
  "currency" text NOT NULL,
  "status" text NOT NULL,
  "available_balance" numeric(18,2) NOT NULL,
  "opened_on" date NOT NULL,
  CONSTRAINT "pk_account" PRIMARY KEY ("id"),
  CONSTRAINT "uq_account_0" UNIQUE ("account_ref")
);
CREATE TABLE portfolio."ledger_entry" (
  "id" bigint NOT NULL,
  "account_id" bigint NOT NULL,
  "entry_type" text NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "posted_at" timestamptz NOT NULL,
  "external_ref" text,
  CONSTRAINT "pk_ledger_entry" PRIMARY KEY ("id")
);
ALTER TABLE portfolio."account" ADD CONSTRAINT "fk_account_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customer" ("id");
ALTER TABLE portfolio."ledger_entry" ADD CONSTRAINT "fk_ledger_entry_0" FOREIGN KEY ("account_id") REFERENCES portfolio."account" ("id");
ALTER TABLE portfolio."account" ADD CONSTRAINT "account_nonnegative_balance" CHECK ("available_balance" >= 0);
ALTER TABLE portfolio."ledger_entry" ADD CONSTRAINT "ledger_positive_amount" CHECK ("amount" > 0);
CREATE UNIQUE INDEX "ledger_external_ref_partial_unique" ON portfolio."ledger_entry" ("external_ref") WHERE ("external_ref" IS NOT NULL);
COMMIT;
