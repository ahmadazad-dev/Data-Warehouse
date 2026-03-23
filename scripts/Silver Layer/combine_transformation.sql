CREATE OR ALTER PROCEDURE silver.load_silver AS 
BEGIN

	DECLARE @start_time DATETIME2, @end_time DATETIME2 -- to calculate the overall timetaken to run this to optimize performance
	DECLARE @overall_start_time DATETIME2, @overall_end_time DATETIME2 -- to calculate the overall timetaken to run this to optimize performance

	BEGIN TRY

		PRINT '<========================================>';
		PRINT 'Loading the Silver Layer';
		PRINT '<========================================>';
		PRINT CHAR(13) + CHAR(10);
		PRINT '<--------------------------------------->';
		PRINT 'Loading CRM Tables';
		PRINT '<--------------------------------------->';
		
		SET @start_time = GETDATE(); 
		SET @overall_start_time = GETDATE(); 

		PRINT 'Truncating Into silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info
		PRINT 'Inserting Into silver.crm_cust_info'
		INSERT INTO silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				ELSE 'n/a'
			END cst_marital_status,
			CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				ELSE 'n/a'
			END cst_gndr,
			cst_create_date
		FROM (
			SELECT 
			*,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) flag_last
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)t WHERE flag_last = 1

		SET @end_time = GETDATE(); 
		PRINT '>> Load Duration of crm_cust_info: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time)AS NVARCHAR) + ' milliseconds';

		-- <====================================================>
		SET @start_time = GETDATE(); 

		PRINT 'Truncating Into silver.crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info
		PRINT 'Inserting Into silver.crm_prd_info'
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT 
			prd_id,
			REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
			SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
			prd_nm,
			COALESCE(prd_cost,0) AS prd_cost,
			CASE prd_line
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'n/a'
			END prd_line,
			CAST(prd_start_dt AS DATE) prd_start_dt,
			CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt_test
		FROM bronze.crm_prd_info

		SET @end_time = GETDATE(); 
		PRINT '>> Load Duration of crm_prd_info: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time)AS NVARCHAR) + ' milliseconds';
		
		-- <====================================================>
		SET @start_time = GETDATE(); 


		PRINT 'Truncating Into silver.crm_sales_details'
		TRUNCATE TABLE silver.crm_sales_details
		PRINT 'Inserting Into silver.crm_sales_details'
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) !=8 THEN NULL 
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END sls_order_dt,
			CASE 
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) !=8 THEN NULL 
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END sls_ship_dt,
			CASE 
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) !=8 THEN NULL 
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END sls_due_dt,
			CASE 
				WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != ABS(sls_price)*sls_quantity THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END sls_sales,
			sls_quantity,
			CASE 
				WHEN sls_price IS NULL OR sls_price <=0  THEN sls_sales / NULLIF(sls_quantity,0)
				ELSE sls_price
			END sls_price
		FROM bronze.crm_sales_details

		SET @end_time = GETDATE(); 
		PRINT '>> Load Duration of crm_sales_details: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time)AS NVARCHAR) + ' milliseconds';
		
		-- <====================================================>
		SET @start_time = GETDATE(); 

		PRINT 'Truncating Into silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12
		PRINT 'Inserting Into silver.erp_cust_az12'
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
			CASE gen
				WHEN UPPER(TRIM(gen)) THEN 'Male'
				WHEN UPPER(TRIM(gen)) THEN 'Female'
				ELSE 'n/a'
			END gen
		FROM bronze.erp_cust_az12

		SET @end_time = GETDATE(); 
		PRINT '>> Load Duration of erp_cust_az12: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time)AS NVARCHAR) + ' milliseconds';
		
		-- <====================================================>
		SET @start_time = GETDATE(); 

		PRINT 'Truncating Into silver.erp_loc_a101'
		TRUNCATE TABLE silver.erp_loc_a101
		PRINT 'Inserting Into silver.erp_loc_a101'
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

		SET @end_time = GETDATE(); 
		PRINT '>> Load Duration of erp_loc_a101: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time)AS NVARCHAR) + ' milliseconds';
		
		-- <====================================================>
		SET @start_time = GETDATE(); 

		PRINT 'Truncating Into silver.erp_px_cat_g1v2'
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		PRINT 'Inserting Into silver.erp_px_cat_g1v2'
		INSERT INTO silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT 
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2

		SET @end_time = GETDATE(); 
		SET @overall_end_time = GETDATE(); 

		PRINT '>> Load Duration of erp_px_cat_g1v2: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time)AS NVARCHAR) + ' milliseconds';
		PRINT CHAR(13) + CHAR(10);
		PRINT '////////////////////\\\\\\\\\\\\\\\\\\\\'
		PRINT '>> Overall Load Duration: ' + CAST(DATEDIFF(MILLISECOND, @overall_start_time, @overall_end_time)AS NVARCHAR) + ' milliseconds';
		PRINT '\\\\\\\\\\\\\\\\\\\\////////////////////'

	END TRY

	BEGIN CATCH
		PRINT '<########################################>';
		PRINT 'Error occured!';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Number' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '<########################################>';
	END CATCH
END

EXEC silver.load_silver