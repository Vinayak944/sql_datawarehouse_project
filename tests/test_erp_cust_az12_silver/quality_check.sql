/*----------------------------------------------------------*/
/*BRONZE DATA CHECK*/
/*----------------------------------------------------------*/

SELECT *
      FROM bronze.erp_cust_az12

-- Comparing the two tables to find the difference in cid and cst_key

SELECT *
      FROM bronze.erp_cust_az12;
      
SELECT cst_key FROM silver.crm_cust_info;

--Double checking to see if the value in cust table is available here

SELECT *
      FROM bronze.erp_cust_az12
      WHERE cid LIKE '%AW00011011%';

--Checking to see if all the values in the cid is there in the other table 
--cid starting with NAS is not in the cust table. 

SELECT *
      FROM bronze.erp_cust_az12
      WHERE cid  NOT IN (
SELECT cst_key FROM silver.crm_cust_info);

--Trying to change the NAS prefix from the cid table
--SUCCESS

SELECT cid,
      CASE  
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
            ELSE cid
      END AS cid,
      bdate,
      gen
      FROM bronze.erp_cust_az12;

--Checking to see if the new cid is available in the cust table

SELECT *
      FROM bronze.erp_cust_az12
      WHERE CASE  
            WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
            ELSE cid
            END  
      NOT IN(SELECT cst_key FROM silver.crm_cust_info);

--Checking the bdate

--Casting the bdate as date

SELECT CAST(bdate AS DATE)
      FROM bronze.erp_cust_az12

--Checking really old date AND bdate greater than today

SELECT DISTINCT bdate
      FROM bronze.erp_cust_az12
      WHERE bdate < '1926-12-31' OR bdate > GETDATE();

--Trying to correct the bdate greater than today to null

SELECT DISTINCT bdate,
                  CASE 
                        WHEN bdate > GETDATE() THEN NULL
                        ELSE CAST(bdate AS DATE)
                  END AS bdate
      FROM bronze.erp_cust_az12
      WHERE bdate < '1926-12-31' OR bdate > GETDATE();

--Checking gen

SELECT DISTINCT gen
      FROM bronze.erp_cust_az12;

--Trying to normalise the values to 'Male','Female','n/a'

SELECT DISTINCT gen,
                  CASE
                        WHEN UPPER(TRIM(REPLACE(gen, CHAR(13),''))) IN ('F','FEMALE') THEN 'Female'
                        WHEN UPPER(TRIM(REPLACE(gen, CHAR(13),''))) IN ('M','MALE') THEN 'Male'
                        ELSE 'n/a'
                  END AS gen
      FROM bronze.erp_cust_az12;


/*----------------------------------------------------------*/
/*SILVER DATA CHECK*/
/*----------------------------------------------------------*/


SELECT *
      FROM silver.erp_cust_az12

--Checking the bdate

SELECT DISTINCT bdate
      FROM silver.erp_cust_az12
      WHERE bdate < '1926-12-31' OR bdate > GETDATE();


--Checking gen

SELECT DISTINCT gen
      FROM silver.erp_cust_az12;
