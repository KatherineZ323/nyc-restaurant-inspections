# NYC Restaurant Inspection Analysis

Does NYC's restaurant grading system accurately reflect food safety risk, and how could inspection resources be allocated more effectively?

**Status:** In progress (loading data into PostgreSQL)

## Data
[DOHMH New York City Restaurant Inspection Results](https://data.cityofnewyork.us/d/43nn-pn8j), NYC Open Data. Data files are not included in this repo; run `notebooks/01_explore.ipynb` to download the raw data, then `notebooks/02_clean.ipynb` to produce the cleaned tables.

## Project Structure
- `notebooks/01_explore.ipynb`: data profiling and business rule validation
- `notebooks/02_clean.ipynb`: cleaning functions and table construction
- `sql/01_create_tables.sql`: database schema (tables, primary/foreign keys, constraints)
- `data_issues_log.md`: all data issues found and how each was handled

## Data Model
| Table | Grain | Rows | Primary key |
|---|---|---|---|
| `restaurants` | one row per restaurant | 31,369 | `camis` |
| `inspections` | one row per inspection | 92,713 | `inspection_id` |
| `violations` | one row per violation | 287,206 | `violation_id` |

`inspections.camis` references `restaurants`; `violations.inspection_id` references `inspections`.

## Local Database Setup
This project uses a local PostgreSQL server (via [Postgres.app](https://postgresapp.com)) running on a non-default port to keep it separate from other projects.

| Setting | Value |
|---|---|
| Host | `localhost` |
| Port | `5433` |
| User | your local Postgres.app user (defaults to your macOS username) |
| Password | none (local trust authentication) |
| Database | `nyc_restaurants` |

Create the database and tables: