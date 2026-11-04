--EXEC silver.load_silver;

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
 
      DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
 
      BEGIN TRY

            SET @batch_start_time = GETDATE();
      
            PRINT '================================================';
            PRINT 'LOADING SILVER LAYER';
            PRINT '================================================';

            PRINT '------------------------------------------------';
            PRINT 'LOADING CRM TABLES';
            PRINT '------------------------------------------------';

            SET @start_time = GETDATE();

            PRINT('TRUNCATING TABLE: silver.crm_cust_info');
            TRUNCATE TABLE silver.crm_cust_info;
 
            PRINT('INSERTING DATA INTO TABLE: silver.crm_cust_info');
            INSERT INTO silver.crm_cust_info(
            cst_id
            ,cst_key
            ,cst_firstname
            ,cst_lastname
            ,cst_marital_status
            ,cst_gndr
            ,cst_create_date
            )
            SELECT  cst_id
                  ,cst_key
                  ,TRIM(cst_firstname) AS cst_firstname
                  ,TRIM(cst_lastname) AS cst_lastname
                  ,CASE
                        WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
                        WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
                        ELSE 'N/A'
                  END cst_marital_status
                  ,CASE
                        WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
                        WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
                        ELSE 'N/A'
                  END cst_gndr
                  ,CAST(REPLACE(cst_create_date, CHAR(13),'') AS DATE) cst_create_date
            FROM (SELECT *
                        ,ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
                  FROM bronze.crm_cust_info
                  WHERE cst_id IS NOT NULL)t
            WHERE flag_last =1;

            SET @end_time = GETDATE();
            PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
            PRINT '---------------'

            -----------------------------------------------------------
            SET @start_time = GETDATE();

            PRINT('TRUNCATING TABLE: silver.crm_prd_info');
            TRUNCATE TABLE silver.crm_prd_info;
            PRINT('INSERTING DATA INTO TABLE: silver.crm_prd_info');
            INSERT INTO silver.crm_prd_info(
            prd_id
            ,cat_id
            ,prd_key
            ,prd_nm
            ,prd_cost
            ,prd_line
            ,prd_start_dt
            ,prd_end_dt
            )
            SELECT prd_id
                  ,REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id
                  ,SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key
                  ,prd_nm
                  ,ISNULL(prd_cost,0) AS prd_cost
                  ,CASE UPPER(TRIM(prd_line))
                        WHEN 'M' THEN 'Mountain'
                        WHEN 'R' THEN 'Road'
                        WHEN 'T' THEN 'Touring'
                        WHEN 'S' THEN 'Other Sales'
                        ELSE 'N/A'
                  END AS prd_line
                  ,prd_start_dt
                  ,LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) AS prd_end_dt
            FROM DataWarehouse.bronze.crm_prd_info;

            SET @end_time = GETDATE();
            PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
            PRINT '---------------'
            -------------------------------------------------------------------------------------------------

            SET @start_time = GETDATE();

            PRINT('TRUNCATING TABLE: silver.crm_sales_details');
            TRUNCATE TABLE silver.crm_sales_details;
            PRINT('INSERTING DATA INTO TABLE: silver.crm_sales_details');
            INSERT INTO silver.crm_sales_details(
            sls_ord_num
            ,sls_prd_key
            ,sls_cust_id
            ,sls_order_dt
            ,sls_ship_dt
            ,sls_due_dt
            ,sls_sales
            ,sls_quantity
            ,sls_price 
            )
            SELECT sls_ord_num
                  ,sls_prd_key
                  ,sls_cust_id
                  ,CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt)!= 8 THEN NULL
                        ELSE CAST(sls_order_dt AS DATE)
                        END sls_order_dt
                  ,CASE WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt)!= 8 THEN NULL
                        ELSE CAST(sls_ship_dt AS DATE)
                        END sls_ship_dt
                  ,CASE WHEN sls_due_dt <= 0 OR LEN(sls_due_dt)!= 8 THEN NULL
                        ELSE CAST(sls_due_dt AS DATE)
                        END sls_due_dt
                  ,CASE 
                        WHEN sls_sales != sls_quantity * ABS(sls_price) OR sls_sales IS NULL OR sls_sales <=0
                              THEN sls_quantity * ABS(sls_price) 
                        ELSE sls_sales
                  END sls_sales
                  ,sls_quantity
                  ,CASE
                        WHEN sls_price <=0 OR sls_price IS NULL
                              THEN sls_sales/NULLIF(sls_quantity,0)
                        ELSE sls_price 
                  END sls_price
            FROM DataWarehouse.bronze.crm_sales_details;

            SET @end_time = GETDATE();
            PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
            PRINT '---------------'
            ----------------------------------------------------------------------------------------------------

            PRINT '------------------------------------------------';
            PRINT 'LOADING ERP TABLES';
            PRINT '------------------------------------------------';

            SET @start_time = GETDATE();

            PRINT('TRUNCATING TABLE: silver.erp_cust_az12');
            TRUNCATE TABLE silver.erp_cust_az12;
            PRINT('INSERTING DATA INTO TABLE: silver.erp_cust_az12');
            INSERT INTO silver.erp_cust_az12(
                  cid
                  ,bdate
                  ,gen
            )
            SELECT 
                  CASE  
                        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
                        ELSE cid
                  END AS cid
                  ,CASE
                        WHEN bdate > GETDATE() THEN NULL
                        ELSE CAST(bdate AS DATE)
                  END AS bdate
                  ,CASE
                        WHEN UPPER(TRIM(REPLACE(gen, CHAR(13),''))) IN ('F','FEMALE') THEN 'Female'
                        WHEN UPPER(TRIM(REPLACE(gen, CHAR(13),''))) IN ('M','MALE') THEN 'Male'
                        ELSE 'n/a'
                  END AS gen
            FROM DataWarehouse.bronze.erp_cust_az12;

            SET @end_time = GETDATE();
            PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
            PRINT '---------------'
            --------------------------------------------------------------------------------------------------

            SET @start_time = GETDATE();

            PRINT('TRUNCATING TABLE: silver.erp_loc_a101');
            TRUNCATE TABLE silver.erp_loc_a101;
            PRINT('INSERTING DATA INTO TABLE: silver.erp_loc_a101');
            INSERT INTO silver.erp_loc_a101(
                  cid
                  ,cntry
            )
            SELECT  REPLACE(cid, '-', '') AS cid
                  ,CASE 
                        WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13),'')) = 'DE' THEN 'Germany'
                        WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13),'')) IN ('US','USA') THEN 'United States'
                        WHEN UPPER(REPLACE(TRIM(cntry), CHAR(13),'')) = '' OR cntry IS NULL THEN 'n/a'
                        ELSE REPLACE(TRIM(cntry), CHAR(13),'')
                  END AS cntry
            FROM DataWarehouse.bronze.erp_loc_a101;

            SET @end_time = GETDATE();
            PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
            PRINT '---------------'
            --------------------------------------------------------------------------------------

            SET @start_time = GETDATE();

            PRINT('TRUNCATING TABLE: silver.erp_px_cat_g1v2');
            TRUNCATE TABLE silver.erp_px_cat_g1v2;
            PRINT('INSERTING DATA INTO TABLE: silver.erp_px_cat_g1v2');
            INSERT INTO silver.erp_px_cat_g1v2(
                  id,
                  cat,
                  subcat,
                  maintenance
            )
            SELECT id,
                  cat,
                  subcat,
                  REPLACE(maintenance, CHAR(13), '')
            FROM DataWarehouse.bronze.erp_px_cat_g1v2;

            SET @end_time = GETDATE();
            PRINT 'LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

            PRINT '========================================='
            SET @batch_end_time = GETDATE();
            PRINT 'TOTAL SILVER LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
            PRINT '========================================='
    
    END TRY
    
    BEGIN CATCH
    
            PRINT '========================================';
            PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER';
            PRINT 'ERROR MESSAGE:' + ERROR_MESSAGE();
            PRINT 'ERROR STATE:' + CAST(ERROR_STATE() AS NVARCHAR);
            PRINT '========================================';
    
    END CATCH
END