# Synthetic Fintech Account Ledger — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint id PK
        text email UK
        text display_name
        timestamptz created_at
    }
    account {
        bigint id PK
        bigint customer_id FK
        text account_ref UK
        text currency
        text status
        numeric available_balance
        date opened_on
    }
    ledger_entry {
        bigint id PK
        bigint account_id FK
        text entry_type
        numeric amount
        timestamptz posted_at
        text external_ref "Optional"
    }
    customer ||--o{ account : "customer_id"
    account ||--o{ ledger_entry : "account_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Iria_Akhere_301932490_ERDiagram.png)
