# Data quality checks

The `tests/` directory contains SQL files for exploratory checks and selected Gold-layer validation. These scripts are not wired to a test runner or CI workflow, and they do not consistently return pass/fail results. A query returning rows may identify records for review; an empty result is not, by itself, a complete quality guarantee.

## Coverage present in the repository

| Area | Script location | Checks represented in the SQL |
| --- | --- | --- |
| CRM customers | `tests/test_crm_cust_info_silver/` | Contains commented exploratory queries for customer ID duplicates/nulls, whitespace, and standardized values, plus active date-conversion inspection |
| CRM products | `tests/test_crm_prd_info_silver/` | Product ID duplicates/nulls, whitespace, costs, product lines, and product date ordering/conversion |
| CRM sales | `tests/test_crm_sales_details_silver/` | Whitespace, product/customer matching, date validity, sales/quantity/price relationships |
| ERP customer demographics | `tests/test_erp_cust_az12_silver/` | Customer ID normalization, date bounds, and gender standardization |
| ERP locations | `tests/test_erp_loc_a101_silver/` | Customer ID normalization and country value standardization |
| ERP product categories | `tests/test_erp_px_cat_g1v2_silver/` | Category key matching, whitespace, and category/maintenance values |
| Gold customer view | `tests/test_gold/test_gold_dim_customers.sql` | Output inspection, gender integration, and duplicate customer checks after joins |
| Gold product view | `tests/test_gold/test_gold_dim_products.sql` | Output inspection and duplicate product checks after joins |
| Gold sales view | `tests/test_gold/test_gold_fact_sales.sql` | Sales-to-dimension join review and unmatched product check |

Each Silver test folder also contains a `load_*.sql` script. Review that file and the connection's active database before running it.

## Execution caution

Inspect each script before executing it. The file `tests/test_crm_cust_info_silver/quality_check.sql` ends with `DROP TABLE silver.crm_cust_info;`; executing the whole file will drop that Silver table. Other test files contain exploratory statements, and their effects should be reviewed as well. These checks are intended to be run deliberately in a development database after the relevant layer has been built.
