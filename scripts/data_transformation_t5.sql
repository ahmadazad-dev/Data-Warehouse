/*
	Transforming Data
*/
INSERT INTO silver.erp_loc_a101(
	cid,
	cntry
)
SELECT 
	REPLACE(cid,'-','') cid,
	CASE 
		WHEN TRIM(cntry) = 'USA' OR TRIM(cntry) = 'US' THEN 'United States'
		WHEN TRIM(cntry) = 'DE' THEN 'Germnay'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE cntry
	END
	cntry
FROM bronze.erp_loc_a101
