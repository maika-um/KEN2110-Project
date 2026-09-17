[README.md](https://github.com/user-attachments/files/32326376/README.md)
# KEN2110-Project# Online Fraud Victimization Database

Group project — Databases course. Builds on the ERD from week 2
(who is most likely to become a victim of online fraud, and how
does reporting behaviour differ?) by turning it into a working
relational database with real CRUD code and mock data.

## Repository structure

```
.
├── README.md
├── sql/
│   ├── schema.sql      -- DDL: tables, PKs, FKs, constraints
│   └── queries.sql      -- 5 advanced queries (joins, aggregates,
│                            subquery, HAVING, window function)
└── scripts/
    ├── db_connection.py    -- opens the DB connection, builds schema
    ├── crud_operations.py  -- Create / Read / Update / Delete demo
    ├── populate_data.py    -- fills the DB with realistic mock data
    └── advanced_queries.py -- runs sql/queries.sql and prints results
```

## Requirements

Just Python 3 (3.9+). No `pip install` needed — everything uses
the standard library (`sqlite3`, `random`, `datetime`). The
database itself is a single SQLite file, `fraud_database.db`,
created in the project root the first time you run the schema
script. SQLite is a real, standalone DBMS (no server needed),
so it satisfies "has a DBMS available" — see the note below if
your reviewer specifically expects MySQL.

## How to run it

From the project root:

```bash
# 1. Create the database and tables
python scripts/db_connection.py

# 2. Fill it with mock data (60 persons, ~65 fraud incidents,
#    matching reports and consequences)
python scripts/populate_data.py

# 3. See basic CRUD operations in action
python scripts/crud_operations.py

# 4. Run the advanced queries
python scripts/advanced_queries.py
```

Re-running step 1 drops and recreates all tables, so you can
reset to a clean state at any point (you'll need to re-run step
2 afterwards).

## The schema (from ERD to relational schema)

Converted directly from our week-2 ERD, already normalized to
3NF:

- **Person** — the individuals in our mock dataset
- **Fraud_Type** — lookup table (phishing, identity theft, …)
- **Communication_Channel** — lookup table (email, phone, …)
- **Organisation** — entities fraud can be reported to
- **Fraud_Incident** — central fact table linking Person, Fraud_Type
  and Communication_Channel
- **Report** — links a Fraud_Incident to an Organisation
- **Consequences** — emotional/financial impact of a Fraud_Incident

All foreign keys and `CHECK` constraints are defined in
`sql/schema.sql`, with a comment above each table explaining the
cardinality it enforces.

**One thing worth double-checking with the group:** our week-2
document has a small inconsistency — the "how the data interacts"
text says an incident can have *multiple* consequences, but the
"relationships" list further down calls it one-to-one. The schema
currently enforces **one-to-one** (a `UNIQUE` constraint on
`Consequences.Fraud_Incident_ID`), matching the relationship list.
If the group actually intends one-to-many, just delete that
`UNIQUE` constraint in `schema.sql`.

## Porting to MySQL

If your reviewer specifically needs MySQL rather than SQLite:

1. `pip install mysql-connector-python` and add it to a
   `requirements.txt`.
2. In `scripts/db_connection.py`, swap the `sqlite3.connect(...)`
   call for `mysql.connector.connect(host=..., user=..., password=..., database=...)`.
3. In `sql/schema.sql`, change `INTEGER PRIMARY KEY AUTOINCREMENT`
   to `INT AUTO_INCREMENT PRIMARY KEY`, and `NUMERIC(10,2)` to
   `DECIMAL(10,2)`.

Everything else (the queries, the CRUD logic) is standard SQL and
needs no changes.

## Working as a group on GitHub

1. Clone the repo, then work on a feature branch per task/person
   (e.g. `git checkout -b schema-constraints`) instead of pushing
   straight to `main`.
2. Open a Pull Request when a branch is ready; at least one other
   group member reviews and approves before merging, so everyone
   has seen and can vouch for the final code.
3. Keep commits small and describe *why*, not just *what*
   (e.g. "add CHECK constraint so Age can't be negative").
4. Make sure every group member is added as a collaborator (or the
   repo is under a shared GitHub organisation/team) so everyone can
   push branches and open PRs.
