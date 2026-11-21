--quality check
SELECT * FROM gold.dim_products


SELECT 
       ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt,pi.prd_key) AS product_key,
       pi.prd_id AS product_id,
       pi.prd_key AS product_number,
       pi.prd_nm AS product_name,
       pi.cat_id AS category_id,
       pt.cat AS category,
       pt.subcat AS subcategory,
       pt.maintenance,
       pi.prd_cost AS cost,
       pi.prd_line AS product_line,
       pi.prd_start_dt AS start_date
FROM silver.crm_prd_info pi
LEFT JOIN silver.erp_px_cat_g1v2 pt
ON pi.cat_id = pt.id
WHERE prd_end_dt IS NULL --FILTER OUT THE HISTORICAL DATA OR SHOWS ONLY THE CURRENT PRODUCT;

-- checking for duplicates after the join

SELECT prd_key, COUNT(*)
FROM(SELECT pi.prd_id,
       pi.cat_id,
       pi.prd_key,
       pi.prd_nm,
       pi.prd_cost,
       pi.prd_line,
       pi.prd_start_dt,
       pt.cat,
       pt.subcat,
       pt.maintenance
FROM silver.crm_prd_info pi
LEFT JOIN silver.erp_px_cat_g1v2 pt
ON pi.cat_id = pt.id
WHERE prd_end_dt IS NULL)t
GROUP BY prd_key
HAVING COUNT(*) >1;