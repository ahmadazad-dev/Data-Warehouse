CREATE VIEW gold.fact_sales AS
SELECT 
	sd.sls_ord_num AS order_number,
	pr.product_key,
	ct.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customer ct
ON sd.sls_cust_id= ct.customer_id

/*
	This is a Fact as we see transactions, events, multiple ids. It has dates, keys and numbers
	We have to present in this fact the surrogate keys which comes from the source systems. We have to replace the sourse system id information with
	the SURROGATE KEYS which we have created. This process is called Date Lookup. So we are joining the table in order to get one information only

	Order the table
*/