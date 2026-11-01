SELECT *
      FROM bronze.crm_prd_info;

SELECT prd_id,
        COUNT(*)
  FROM bronze.crm_prd_info
  GROUP BY prd_id
  HAVING COUNT(*)>1 OR prd_id IS NULL;

SELECT prd_nm
      FROM bronze.crm_prd_info
      WHERE prd_nm != TRIM(prd_nm);

SELECT prd_cost
      FROM bronze.crm_prd_info
      WHERE prd_cost <0 OR prd_cost IS NULL;

SELECT DISTINCT prd_line
      FROM bronze.crm_prd_info;

SELECT *
      FROM bronze.crm_prd_info
      WHERE prd_end_dt< prd_start_dt;

SELECT prd_start_dt,
      ISDATE(prd_start_dt)
      FROM bronze.crm_prd_info
      WHERE ISDATE(prd_start_dt) =0;

SELECT prd_end_dt,
      ISDATE(prd_end_dt)
      FROM bronze.crm_prd_info
      WHERE ISDATE(prd_end_dt) =0;

SELECT prd_id,
      prd_key,
      prd_start_dt,
      REPLACE(prd_end_dt, CHAR(13),'')AS prd_end_dt,
      LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)
      FROM bronze.crm_prd_info;

SELECT *
FROM silver.crm_prd_info
/*-------------------------*/

SELECT *
      FROM silver.crm_prd_info;

SELECT prd_id,
        COUNT(*)
  FROM silver.crm_prd_info
  GROUP BY prd_id
  HAVING COUNT(*)>1 OR prd_id IS NULL;

SELECT prd_nm
      FROM silver.crm_prd_info
      WHERE prd_nm != TRIM(prd_nm);

SELECT prd_cost
      FROM silver.crm_prd_info
      WHERE prd_cost <0 OR prd_cost IS NULL;

SELECT DISTINCT prd_line
      FROM silver.crm_prd_info;

SELECT *
      FROM silver.crm_prd_info
      WHERE prd_end_dt< prd_start_dt;

SELECT prd_start_dt,
      ISDATE(prd_start_dt)
      FROM silver.crm_prd_info
      WHERE ISDATE(prd_start_dt) =0;

SELECT prd_end_dt,
      ISDATE(prd_end_dt)
      FROM silver.crm_prd_info
      WHERE ISDATE(prd_end_dt) =0;

SELECT prd_id,
      prd_key,
      prd_start_dt,
      REPLACE(prd_end_dt, CHAR(13),'')AS prd_end_dt,
      LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)
      FROM silver.crm_prd_info;

SELECT *
FROM silver.crm_prd_info