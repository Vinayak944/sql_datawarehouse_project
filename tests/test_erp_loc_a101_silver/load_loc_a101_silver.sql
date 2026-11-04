INSERT INTO silver.erp_loc_a101(
      cid,
      cntry
)
SELECT REPLACE(cid, '-', '') AS cid,
       CASE 
            WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13),'')) = 'DE' THEN 'Germany'
            WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13),'')) IN ('US','USA') THEN 'United States'
            WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13),'')) = '' OR cntry IS NULL THEN 'n/a'
            ELSE REPLACE(TRIM(cntry), CHAR(13),'')
      END AS cntry
FROM bronze.erp_loc_a101;