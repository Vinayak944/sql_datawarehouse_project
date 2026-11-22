# Data catalog

This catalog describes the inputs and outputs visible in the repository. The six CSV files are mounted read-only into the SQL Server container under `/datasets` for the Bronze bulk-load procedure.

## Source inventory

| Source | File | Bronze table | Silver table |
| --- | --- | --- | --- |
| CRM | `cust_info.csv` | `bronze.crm_cust_info` | `silver.crm_cust_info` |
| CRM | `prd_info.csv` | `bronze.crm_prd_info` | `silver.crm_prd_info` |
| CRM | `sales_details.csv` | `bronze.crm_sales_details` | `silver.crm_sales_details` |
| ERP | `CUST_AZ12.csv` | `bronze.erp_cust_az12` | `silver.erp_cust_az12` |
| ERP | `LOC_A101.csv` | `bronze.erp_loc_a101` | `silver.erp_loc_a101` |
| ERP | `PX_CAT_G1V2.csv` | `bronze.erp_px_cat_g1v2` | `silver.erp_px_cat_g1v2` |

## Gold view catalog

### `gold.dim_customers`

Combines CRM customer records with ERP customer demographic and location attributes.

| Column | Meaning based on the view definition |
| --- | --- |
| `customer_key` | Row number generated from customer ID ordering |
| `customer_id` | CRM customer ID |
| `customer_number` | CRM customer business key |
| `first_name`, `last_name` | Customer names |
| `country` | Country from the ERP location table |
| `marital_status`, `gender` | Standardized customer attributes; gender falls back to ERP when CRM is `N/A` |
| `birth_date` | ERP customer birth date |
| `create_date` | CRM customer creation date |

### `gold.dim_products`

Combines current CRM products with ERP product category details. The view includes rows where `prd_end_dt IS NULL`.

| Column | Meaning based on the view definition |
| --- | --- |
| `product_key` | Row number generated from product start date and product key ordering |
| `product_id` | CRM product ID |
| `product_number` | Product business key |
| `product_name` | Product name |
| `category_id`, `category`, `subcategory` | Product category identifiers and labels |
| `maintenance` | ERP maintenance attribute |
| `cost` | CRM product cost |
| `product_line` | CRM product line |
| `start_date` | Product start date |

### `gold.facts_sales`

Sales detail rows enriched with generated product and customer keys.

| Column | Meaning based on the view definition |
| --- | --- |
| `order_number` | CRM sales order number |
| `product_key`, `customer_key` | Matching Gold dimension view keys; may be `NULL` when a left join has no match |
| `order_date`, `shipping_date`, `due_date` | Sales order lifecycle dates |
| `sales_amount` | Sales amount from the cleaned Silver row |
| `quantity` | Units from the cleaned Silver row |
| `price` | Unit price from the cleaned Silver row |

Column types are inherited from the underlying SQL expressions. `customer_key` and `product_key` are produced by `ROW_NUMBER()` in views rather than stored in keyed tables.
