/*----------------------------------------------------------*/
/*BRONZE DATA CHECK*/
/*----------------------------------------------------------*/

SELECT *
      FROM bronze.crm_sales_details;

/*Checking for extra spaces*/

SELECT sls_ord_num
      FROM bronze.crm_sales_details
      WHERE sls_ord_num != TRIM(sls_ord_num);

/*Checking to see if all the sls_prd_key in sales_details table
are in prd_info table
HINT: Since all the products that are in sales_details table should be in prd_info table
, because prd_info table contains products that did not sell too or all the products*/

SELECT *
      FROM bronze.crm_sales_details
      WHERE sls_prd_key NOT IN (
            SELECT prd_key FROM silver.crm_prd_info
      );

/*Checking to see if all the sls_cust_id in sales_details table
are in cust_info table
HINT: Since all the customers that are in cust_info table should be in sales_details table
, because cust_info table contains customers that did not order anything or all the customers*/

SELECT *
      FROM bronze.crm_sales_details
      WHERE sls_cust_id NOT IN (
            SELECT cst_id FROM silver.crm_cust_info
      );

/*Checking to see if the three date coloumns are in correct date format
IN THIS CASE just the sls_order_dt has problems*/

SELECT sls_order_dt,
      ISDATE(sls_order_dt),
      sls_ship_dt,
      ISDATE(sls_ship_dt),
      sls_due_dt,
      ISDATE(sls_due_dt)
      FROM bronze.crm_sales_details
      WHERE ISDATE(sls_order_dt) =0 OR
      ISDATE(sls_ship_dt) =0 OR
      ISDATE(sls_due_dt) =0;

/*Another check with the dates: checks for Nulls,
 check if they are less than or equal to 0,
 length of the date number, if they are not 8 then they are not date format
 And finally if they are in the correct date range */

SELECT sls_order_dt
      FROM bronze.crm_sales_details
      WHERE sls_order_dt IS NULL 
      OR sls_order_dt <= 0 
      OR LEN(sls_order_dt)!= 8
      OR sls_order_dt > 20500101
      OR sls_order_dt < 19000101;

/*Changing the sls_order_dt values that are 0 or less and less than 8 length to null
 and casting it as date*/

SELECT CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt)!= 8 THEN NULL
            ELSE CAST(sls_order_dt AS DATE)
            END
      FROM bronze.crm_sales_details;

/*checking the last two date coloums to see if they are in the
date format*/

SELECT sls_ship_dt,
      ISDATE(sls_ship_dt),
      sls_due_dt,
      ISDATE(sls_due_dt)
      FROM bronze.crm_sales_details
      WHERE 
      ISDATE(sls_ship_dt) =0 OR
      ISDATE(sls_due_dt) =0;

/*Another check with the dates: checks for Nulls,
 check if they are less than or equal to 0,
 length of the date number, if they are not 8 then they are not date format
 And finally if they are in the correct date range */

SELECT sls_ship_dt
      FROM bronze.crm_sales_details
      WHERE sls_ship_dt IS NULL 
      OR sls_ship_dt <= 0 
      OR LEN(sls_ship_dt)!= 8
      OR sls_ship_dt > 20500101
      OR sls_ship_dt < 19000101;


SELECT sls_due_dt
      FROM bronze.crm_sales_details
      WHERE sls_due_dt IS NULL 
      OR sls_due_dt <= 0 
      OR LEN(sls_due_dt)!= 8
      OR sls_due_dt > 20500101
      OR sls_due_dt < 19000101;

--Checking for invalid date orders

SELECT sls_order_dt,
      sls_ship_dt
      sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
      OR sls_order_dt > sls_due_dt
      OR sls_ship_dt > sls_due_dt;

/*Checking the price,sales and quantity coloumns
RULES: sales = price* quantity,
       all theree not equal to 0 or negative*/

SELECT DISTINCT sls_sales as old_sales,
      sls_quantity,
      sls_price AS old_price,
      CASE 
            WHEN sls_sales != sls_quantity * ABS(sls_price) OR sls_sales IS NULL OR sls_sales <=0
                  THEN sls_quantity * ABS(sls_price) 
            ELSE sls_sales
      END sls_sales,
      CASE 
            WHEN sls_price <=0 OR sls_price IS NULL
                  THEN sls_sales/NULLIF(sls_quantity,0)
            ELSE sls_price
      END sls_price
      FROM bronze.crm_sales_details
      WHERE sls_sales != sls_quantity * sls_price 
            OR  sls_sales <= 0
            OR sls_quantity <= 0
            OR sls_price <= 0 
            OR sls_sales IS NULL
            OR sls_quantity IS NULL
            OR sls_price IS NULL
      ORDER BY sls_sales,sls_quantity,sls_price;


/*----------------------------------------------------------*/
/*SILVER DATA CHECK*/
/*----------------------------------------------------------*/

SELECT *
      FROM silver.crm_sales_details;

/*Checking for extra spaces*/

SELECT sls_ord_num
      FROM silver.crm_sales_details
      WHERE sls_ord_num != TRIM(sls_ord_num);

/*Checking to see if all the sls_prd_key in sales_details table
are in prd_info table
HINT: Since all the products that are in sales_details table should be in prd_info table
, because prd_info table contains products that did not sell too or all the products*/

SELECT *
      FROM silver.crm_sales_details
      WHERE sls_prd_key NOT IN (
            SELECT prd_key FROM silver.crm_prd_info
      );

/*Checking to see if all the sls_cust_id in sales_details table
are in cust_info table
HINT: Since all the customers that are in cust_info table should be in sales_details table
, because cust_info table contains customers that did not order anything or all the customers*/

SELECT *
      FROM silver.crm_sales_details
      WHERE sls_cust_id NOT IN (
            SELECT cst_id FROM silver.crm_cust_info
      );

/*Checking to see if the three date coloumns are in correct date format
IN THIS CASE just the sls_order_dt has problems*/

SELECT sls_order_dt,
      ISDATE(sls_order_dt),
      sls_ship_dt,
      ISDATE(sls_ship_dt),
      sls_due_dt,
      ISDATE(sls_due_dt)
      FROM silver.crm_sales_details
      WHERE ISDATE(sls_order_dt) =0 OR
      ISDATE(sls_ship_dt) =0 OR
      ISDATE(sls_due_dt) =0;

/*Another check with the dates: checks for Nulls,
 check if they are less than or equal to 0,
 length of the date number, if they are not 8 then they are not date format
 And finally if they are in the correct date range */

SELECT sls_order_dt
      FROM silver.crm_sales_details
      WHERE sls_order_dt IS NULL 
      OR sls_order_dt <= 0 
      OR LEN(sls_order_dt)!= 8
      OR sls_order_dt > '2050-01-01'
      OR sls_order_dt < '1900-01-01';

/*Changing the sls_order_dt values that are 0 or less and less than 8 length to null
 and casting it as date*/

SELECT CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt)!= 8 THEN NULL
            ELSE CAST(sls_order_dt AS DATE)
            END
      FROM silver.crm_sales_details;

/*checking the last two date coloums to see if they are in the
date format*/

SELECT sls_ship_dt,
      ISDATE(sls_ship_dt),
      sls_due_dt,
      ISDATE(sls_due_dt)
      FROM silver.crm_sales_details
      WHERE 
      ISDATE(sls_ship_dt) =0 OR
      ISDATE(sls_due_dt) =0;

/*Another check with the dates: checks for Nulls,
 check if they are less than or equal to 0,
 length of the date number, if they are not 8 then they are not date format
 And finally if they are in the correct date range */

SELECT sls_ship_dt
      FROM silver.crm_sales_details
      WHERE sls_ship_dt IS NULL 
      OR sls_ship_dt <= 0 
      OR LEN(sls_ship_dt)!= 8
      OR sls_ship_dt > 20500101
      OR sls_ship_dt < 19000101;


SELECT sls_due_dt
      FROM silver.crm_sales_details
      WHERE sls_due_dt IS NULL 
      OR sls_due_dt <= 0 
      OR LEN(sls_due_dt)!= 8
      OR sls_due_dt > 20500101
      OR sls_due_dt < 19000101;

--Checking for invalid date orders

SELECT sls_order_dt,
      sls_ship_dt
      sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
      OR sls_order_dt > sls_due_dt
      OR sls_ship_dt > sls_due_dt;

/*Checking the price,sales and quantity coloumns
RULES: sales = price* quantity,
       all theree not equal to 0 or negative*/

SELECT DISTINCT sls_sales as old_sales,
      sls_quantity,
      sls_price AS old_price,
      CASE 
            WHEN sls_sales != sls_quantity * ABS(sls_price) OR sls_sales IS NULL OR sls_sales <=0
                  THEN sls_quantity * ABS(sls_price) 
            ELSE sls_sales
      END sls_sales,
      CASE 
            WHEN sls_price <=0 OR sls_price IS NULL
                  THEN sls_sales/NULLIF(sls_quantity,0)
            ELSE sls_price
      END sls_price
      FROM silver.crm_sales_details
      WHERE sls_sales != sls_quantity * sls_price 
            OR  sls_sales <= 0
            OR sls_quantity <= 0
            OR sls_price <= 0 
            OR sls_sales IS NULL
            OR sls_quantity IS NULL
            OR sls_price IS NULL
      ORDER BY sls_sales,sls_quantity,sls_price;

