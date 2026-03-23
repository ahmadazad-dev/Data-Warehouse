/*
	Data Transformation and Cleaning
*/
--  For erp_cust_az12 only
INSERT INTO silver.erp_cust_az12 (
	cid,
	bdate,
	gen
)
SELECT
	CASE 
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
	END cid,
	CASE 
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END bdate,
	CASE 
		WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
		WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(gen)) = '' THEN 'n/a'
		ELSE gen
	END gen
FROM bronze.erp_cust_az12
