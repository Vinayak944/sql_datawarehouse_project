--quality check
SELECT * FROM gold.dim_customers;

SELECT DISTINCT gender FROM gold.dim_customers;


--integrating the two gender info from different tables
SELECT DISTINCT cu.cst_gndr,
        ce.gen,
        CASE
            WHEN UPPER(cu.cst_gndr) != 'N/A' THEN cu.cst_gndr --cst_gndr is taken as the primary one
            ELSE COALESCE(ce.gen, 'n/a')
        END new_gndr
FROM silver.crm_cust_info cu
LEFT JOIN silver.erp_cust_az12 ce
ON cu.cst_key = ce.cid
LEFT JOIN silver.erp_loc_a101 cl
ON cu.cst_key = cl.cid;

--checking for duplicates after join

SELECT customer_id,
        COUNT(*)
FROM
    (SELECT  cu.cst_id AS customer_id,
            cu.cst_key AS customer_number,
            cu.cst_firstname AS first_name,
            cu.cst_lastname AS last_name,
            cu.cst_marital_status AS marital_status,
            cl.cntry as country,
            ce.bdate AS birth_date,
            CASE
                WHEN UPPER(cu.cst_gndr) != 'N/A' THEN cu.cst_gndr
                ELSE COALESCE(ce.gen, 'n/a')
            END gender,
            cu.cst_create_date as create_date
    FROM silver.crm_cust_info cu
    LEFT JOIN silver.erp_cust_az12 ce
    ON cu.cst_key = ce.cid
    LEFT JOIN silver.erp_loc_a101 cl
    ON cu.cst_key = cl.cid)t
GROUP BY customer_id
HAVING COUNT(*) >1;