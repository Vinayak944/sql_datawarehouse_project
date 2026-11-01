/*
SELECT cst_id,
       COUNT(*) AS flag_id
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) >1 OR cst_id IS NULL;

SELECT *
FROM bronze.crm_cust_info
WHERE cst_id = 29473;

SELECT *
FROM (SELECT *,
        ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
      FROM bronze.crm_cust_info)t
WHERE flag_last =1;


SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_in

SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_inf

SELECT cst_key
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key);

SELECT cst_key
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_key
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);



SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);
        
SELECT cst_id,
       COUNT(*) AS flag_id
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) >1 OR cst_id IS NULL;

SELECT cst_id,
       COUNT(*) AS flag_id
FROM silver.crm_cust_info
GROUP BY cst_id;

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);
*/
SELECT cst_create_date,
      ISDATE(cst_create_date),
      CAST(REPLACE(cst_create_date, CHAR(13),'') AS DATE),
      ISDATE(REPLACE(cst_create_date, CHAR(13),''))
FROM bronze.crm_cust_info

SELECT * 
FROM silver.crm_cust_info;

DROP TABLE silver.crm_cust_info;