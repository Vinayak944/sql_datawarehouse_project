# Naming patterns

This page records patterns observed in the current SQL files; it does not introduce new rules.

## Schemas and tables

- Layer schemas are lowercase: `bronze`, `silver`, and `gold`.
- Bronze and Silver table names retain a source prefix and entity name, such as `crm_cust_info` and `erp_loc_a101`.
- Gold views use business-facing names with role prefixes: `dim_customers`, `dim_products`, and `facts_sales`.

## Columns

- Source and layer columns use lowercase names with underscores where words are separated, for example `cst_create_date` and `sls_order_dt`.
- Gold views alias fields to descriptive names such as `customer_number`, `shipping_date`, and `sales_amount`.
- Dimension view keys use the `_key` suffix (`customer_key`, `product_key`). They are generated with `ROW_NUMBER()` in the view definitions.

## Procedures and files

- Layer load procedures follow the pattern `load_<layer>` and are created in the corresponding schema: `bronze.load_bronze` and `silver.load_silver`.
- SQL files are grouped by layer under `scripts/`; DDL and load procedure files are named by their purpose.
