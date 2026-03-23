/*
	Checking Data Quality before transformation
*/
--  For crm_sales_detaila only

-- Check unwanted spaces
-- Expectation: No Results
SELECT sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

-- Checking invalid dates
SELECT 
	NULLIF(sls_order_dt,0)
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR
	LEN(sls_order_dt) != 8 OR
	sls_order_dt > 20500101 OR	
	sls_order_dt < 19000101

SELECT 
	NULLIF(sls_ship_dt,0)
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 OR
	LEN(sls_ship_dt) != 8 OR
	sls_ship_dt > 20500101 OR	
	sls_ship_dt < 19000101

SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt

-- There is a rule in this business the sales must be equal to quantity*price
SELECT*
FROM bronze.crm_sales_details
WHERE sls_sales != sls_price*sls_quantity OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
-- either these issues will be solved in their source system which means leave it as it is
-- or improve the quality of data
-- ask the experts the rules of the data
/*
	This business rules are
	1. If the sales are null or 0 or <0 then calculate the sales 
	2. If the price is null, calculate using sales and quantity
	3. If price is in -ve value then convert it to +ve
*/

SELECT *
FROM silver.crm_sales_details

SELECT*
FROM silver.crm_sales_details
WHERE sls_sales != sls_price*sls_quantity OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0