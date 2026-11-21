--Quality checking
SELECT * FROM gold.facts_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
on s.product_key = p.product_key
WHERE p.product_key IS NULL


SELECT sd.sls_ord_num AS order_number,
       dp.product_key,
       dc.customer_key,
       sd.sls_order_dt AS order_date,
       sd.sls_ship_dt AS shipping_date,
       sd.sls_due_dt AS due_date,
       sd.sls_sales AS sales_amount,
       sd.sls_quantity AS quantity,
       sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products dp
ON sd.sls_prd_key = dp.product_number 
LEFT JOIN gold.dim_customers dc
ON sd.sls_cust_id = dc.customer_id
