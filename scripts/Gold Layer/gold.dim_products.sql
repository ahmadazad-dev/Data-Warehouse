CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, prd_id) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS sub_category,
	pc.maintenance,
	pn.prd_cost AS product_cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id 
WHERE pn.prd_end_dt IS NULL -- filter out all the historical data


/*
	READ FOR BETTER UNDERSTANDING
		This object contains historical and current information of the products. It depend on the requirement which data you want to target. 
		Here we will target only current data.
		Check for unique product keys. They should be unique
		
		We dont have anything to integerate

		Here we have a lot of information about the product so this is also a Dimensison Table so it also need a PK or SK
*/