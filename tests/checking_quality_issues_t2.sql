/*
	Checking Data Quality before transformation
*/
--  For crm_cust_info only
-- Check Primary Key
SELECT 
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check unwanted spaces
-- Expectation: No Results
SELECT prd_line
FROM bronze.crm_prd_info
WHERE prd_line != TRIM(prd_line)

-- Checking for null or negative numbers
SELECT 
	prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- Checking invalid date order
/*For this data 
	1. either swap start with end but the outputs might be worse. there may be overlappings
	2. Take only the start dates of the product and make the end date from the start dates which the start date of next record - 1
*/
SELECT 
	*	
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt


/*
	Checking Data Quality after transformation
*/

SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check unwanted spaces
-- Expectation: No Results
SELECT prd_line
FROM silver.crm_prd_info
WHERE prd_line != TRIM(prd_line)

-- Checking for null or negative numbers
SELECT 
	prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Checking invalid date order
/*For this data 
	1. either swap start with end but the outputs might be worse. there may be overlappings
	2. Take only the start dates of the product and make the end date from the start dates which the start date of next record - 1
*/
SELECT 
	*	
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT * FROM silver.crm_prd_info