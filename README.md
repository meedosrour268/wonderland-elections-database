# Wonderland Elections Database

A MySQL academic project modeling people, residences, voting centers, operating periods, staff assignments, polls, registrations, and ballots.

## Files

- `createALL.sql`: creates the database, tables, and an index.
- `loadALL.sql`: loads coursework sample records.
- `queryAll.sql`: query examples and the `GetClosestCenter` stored function.
- `transaction.sql`: transaction examples.
- `wonderland_app.ipynb`: Python/MySQL interactive prototype.
- `dropALL.sql`: destructive reset script; use only on your demo database.

## Setup

Use a local MySQL 8 demo instance. In the MySQL client, run in this order:

```sql
SOURCE createALL.sql;
SOURCE loadALL.sql;
SOURCE queryAll.sql;
```

Review the SQL before executing it. Use a fresh local demo database; setup creates `wonderland_elections_db`. The supplied records are coursework examples, not a real voter dataset.

For the notebook:

```bash
python -m pip install -r requirements.txt
```

Set `MYSQL_PASSWORD` in the environment before launching Jupyter. Optional variables: `MYSQL_HOST` and `MYSQL_USER`, defaulting to `localhost` and `root`. Use a dedicated local demo account where possible. Open `wonderland_app.ipynb` and run cells in order.

## Portfolio preparation

Notebook output was cleared and the embedded password placeholder was replaced with an environment variable. SQL and application logic otherwise retain the uploaded coursework implementation. A live MySQL execution has not been verified during this preparation.

## Background

UMBC CMSC 461 coursework. Demonstrates relational modeling, joins, stored functions, and database access from Python.
