/*
	Checking Data Quality before transformation
*/
SELECT 
	cid,
	cntry
FROM bronze.erp_loc_a101

SELECT DISTINCT cntry
FROM bronze.erp_loc_a101

SELECT * FROM silver.crm_cust_info