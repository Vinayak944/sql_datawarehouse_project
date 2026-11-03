INSERT INTO silver.erp_cust_az12(
      cid,
      bdate,
      gen
)
SELECT 
      CASE  
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
            ELSE cid
      END AS cid,
      CASE
            WHEN bdate > GETDATE() THEN NULL
            ELSE CAST(bdate AS DATE)
      END AS bdate,
      CASE
            WHEN UPPER(TRIM(REPLACE(gen, CHAR(13),''))) IN ('F','FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(REPLACE(gen, CHAR(13),''))) IN ('M','MALE') THEN 'Male'
            ELSE 'n/a'
      END AS gen
FROM bronze.erp_cust_az12;
