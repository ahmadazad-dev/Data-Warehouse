/*
	Checking Data Quality before transformation
*/
--  For crm_cust_info only
-- Check Primary Key
SELECT 
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check unwanted spaces
-- Expectation: No Results
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr 
FROM bronze.crm_cust_info

/*
	Checking Data Quality after transformation
*/

-- Check Primary Key
SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check unwanted spaces
-- Expectation: No Results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr 
FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info