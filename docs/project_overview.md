# Project overview

## Objective

Build a SQL Server data warehouse that brings together sales-related CRM and ERP CSV data. The repository contains SQL scripts for loading raw data, transforming it into cleaner layer tables, and exposing customer, product, and sales views for analysis.

## Scope in the repository

- Six source CSV files: three CRM files and three ERP files.
- A SQL Server 2022 container definition in `docker-compose.yml`.
- Bronze and Silver table definitions and load procedures.
- Gold views for customers, products, and sales.
- SQL scripts for selected Silver loads, data-quality exploration, and Gold checks.

## Current boundaries

- The project provides SQL views for analysis; it does not include a dashboard or reporting application.
- The Gold layer is implemented as views, not persisted dimension and fact tables.
- The product dimension view filters to rows with no `prd_end_dt` (the current product rows).
- The repository contains SQL check scripts, but no automated test runner or CI workflow is present in the reviewed tree.
- SQL Server startup is containerized, while database initialization and SQL script execution are performed separately with a SQL Server client.

## Main components

| Component | Location | Purpose |
| --- | --- | --- |
| CRM and ERP source files | `datasets/` | Input records for the warehouse |
| Database and schema initialization | `scripts/init_database.sql` | Creates `DataWarehouse` and its layer schemas |
| Bronze | `scripts/bronze/` | Defines raw tables and bulk-load procedure |
| Silver | `scripts/silver/` | Defines cleaned tables and transformation procedure |
| Gold | `scripts/gold/` | Defines analysis-facing views |
| Checks | `tests/` | Contains exploratory SQL and Gold-layer checks |
