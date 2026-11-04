/*----------------------------------------------------------*/
/*BRONZE DATA CHECK*/
/*----------------------------------------------------------*/

--Comparing the id between two tables

SELECT * FROM bronze.erp_px_cat_g1v2;

SELECT * FROM silver.crm_prd_info;

-- Checking to see if all id from current table is present in the other table

SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN
(SELECT cat_id FROM silver.crm_prd_info);

--Checking other coloumns for unwated spaces
--maintenance coloumn has 'enter' character at the end

SELECT * 
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

--Checking for any unwanted entries in the three coloumns

SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2;

--Fixing the 'enter' character in maintenance

SELECT DISTINCT 
                  REPLACE(maintenance, CHAR(13), '')
FROM bronze.erp_px_cat_g1v2;


/*----------------------------------------------------------*/
/*SILVER DATA CHECK*/
/*----------------------------------------------------------*/

--Checking other coloumns for unwated spaces
--maintenance coloumn has 'enter' character at the end

SELECT * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

--Checking for any unwanted entries in the three coloumns

SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2;


