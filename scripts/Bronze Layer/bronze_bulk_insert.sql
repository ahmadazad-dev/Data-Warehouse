-- Since need fresh data daily and we will be doing insert regularly so we made stored procedure
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

	DECLARE @start_time DATETIME2, @end_time DATETIME2 -- to calculate the overall timetaken to run this to optimize performance
	DECLARE @overall_start_time DATETIME2, @overall_end_time DATETIME2 -- to calculate the overall timetaken to run this to optimize performance

	BEGIN TRY
		PRINT '<========================================>';
		PRINT 'Loading the Bronze Layer';
		PRINT '<========================================>';
		PRINT CHAR(13) + CHAR(10);
		PRINT '<--------------------------------------->';
		PRINT 'Loading data from crm';
		PRINT '<--------------------------------------->';

		SET @start_time = GETDATE(); 
		SET @overall_start_time = GETDATE(); 

		-- Bulk Inserting Data from source into the Database
		-- Implementing full load by Truncating the table and bulk inserting
		PRINT '>>Truncating bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info
		PRINT '>>Bulk Inserting bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH ( -- Here we tell the SQL how to deal with the file or data which is to be loaded
			FIRSTROW = 2,				-- it tells SQL that start loading data from the 2nd row 
			FIELDTERMINATOR	= ',',		-- it tells SQL that the data in different columns are seperated by comma
			TABLOCK						-- it tells SQL that lock the whole table during the load. It improves the performance
		);

		-- After loading check if the data is in correct column, exceptions are very common where data in wrong column
		/* SELECT * FROM bronze.crm_cust_info */
		-- Check if all the rows are added
		/*SELECT COUNT(*) FROM bronze.crm_cust_info */
		-- If we rerun the load query it will add duplicates in the table to avoid it we use TRUNCATE & LOAD 

		-- Loading data into other tables
		-- <====================================================>
		PRINT '>>Truncating bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT '>>Bulk Inserting bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH ( 
			FIRSTROW = 2,	
			FIELDTERMINATOR	= ',',
			TABLOCK	
		);

		SET @end_time = GETDATE(); 

		PRINT '>> Load Duration of crm_prd_info: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time)AS NVARCHAR) + ' milliseconds';

		-- <====================================================>
		SET @start_time = GETDATE(); 

		PRINT '>>Truncating bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT '>>Bulk Inserting bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH ( 
			FIRSTROW = 2,	
			FIELDTERMINATOR	= ',',
			TABLOCK	
		);

		SET @end_time = GETDATE(); 

		PRINT '>> Load Duration of crm_sales_details: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time)AS NVARCHAR) + ' milliseconds';
		PRINT CHAR(13) + CHAR(10);
		PRINT '<--------------------------------------->';
		PRINT 'Loading data from erp';
		PRINT '<--------------------------------------->';

		-- <====================================================>
		SET @start_time = GETDATE(); 

		PRINT '>>Truncating bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12
		PRINT '>>Bulk Inserting bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH ( 
			FIRSTROW = 2,	
			FIELDTERMINATOR	= ',',
			TABLOCK	
		);

		SET @end_time = GETDATE(); 

		PRINT '>> Load Duration of erp_cust_az12: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time)AS NVARCHAR) + ' milliseconds';

		-- <====================================================>
		SET @start_time = GETDATE(); 

		PRINT '>>Truncating bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101
		PRINT '>>Bulk Inserting bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH ( 
			FIRSTROW = 2,	
			FIELDTERMINATOR	= ',',
			TABLOCK	
		);
		
		SET @end_time = GETDATE(); 

		PRINT '>> Load Duration of erp_loc_a101: ' + CAST(DATEDIFF(MILLISECOND, @start_time, @end_time)AS NVARCHAR) + ' milliseconds';

		-- <====================================================>
		SET @start_time = GETDATE(); 

		PRINT '>>Truncating bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2	
		PRINT '>>Bulk Inserting bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH ( 
			FIRSTROW = 2,	
			FIELDTERMINATOR	= ',',
			TABLOCK	
		);

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