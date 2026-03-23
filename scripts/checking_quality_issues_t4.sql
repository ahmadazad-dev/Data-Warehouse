/*
	Checking Data Quality before transformation
*/
--  For erp_cust_az12 only
-- PK
SELECT cid
FROM bronze.erp_cust_az12

-- Bday
-- either replace these dates with null or leave it as it is
SELECT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- gender
SELECT DISTINCt gen
FROM bronze.erp_cust_az12

SELECT * FROM silver.erp_cust_az12