/*----------------------------------------------------------*/
/*BRONZE DATA CHECK*/
/*----------------------------------------------------------*/

--Comparing the cid values with the other table

SELECT cid,
      cntry
FROM bronze.erp_loc_a101;

SELECT cst_key FROM silver.crm_cust_info;

-- Replacing the '-' character from the cid to normalise

SELECT cid,
      REPLACE(cid, '-', ''),
      cntry
FROM bronze.erp_loc_a101;

--Checking to see if the new cid is all available in the other table

SELECT cid,
      REPLACE(cid, '-', ''),
      cntry
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN
(SELECT cst_key FROM silver.crm_cust_info);

-- Checking the cntry 

SELECT DISTINCT cntry
FROM bronze.erp_loc_a101

--Found many values with dulicate meanings

SELECT DISTINCT cntry,
      CASE 
            WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13),'')) = 'DE' THEN 'Germany'
            WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13),'')) IN ('US','USA') THEN 'United States'
            WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13),'')) = '' OR cntry IS NULL THEN 'n/a'
            ELSE REPLACE(TRIM(cntry), CHAR(13),'')
      END AS necntry
FROM bronze.erp_loc_a101

/*----------------------------------------------------------*/
/*SILVER DATA CHECK*/
/*----------------------------------------------------------*/

--Comparing the cid values with the other table

SELECT cid,
      cntry
FROM silver.erp_loc_a101;

SELECT cst_key FROM silver.crm_cust_info;

-- Checking the cntry 

SELECT DISTINCT cntry
FROM silver.erp_loc_a101;