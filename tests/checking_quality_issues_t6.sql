/*
	Checking Data Quality before transformation
*/
SELECT 
	cat
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat)

SELECT 
	subcat
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat)

SELECT 
	maintenance
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance)

SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2
SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2
SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2

SELECT * FROM silver.erp_px_cat_g1v2