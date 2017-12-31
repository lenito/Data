-- ========================================
-- checking get_all and get_net funtions --
-- ========================================

USE AdventureWorks2014
GO

-- function all change - Used for capture all changes in tables with cdc excluding the last value in update modification
DECLARE	@begin_time datetime, 
		@end_time datetime, 
		@from_lsn binary(10), 
		@to_lsn binary(10);

SET @begin_time = GETDATE() -1;
SET @end_time = GETDATE();
SET @from_lsn = sys.fn_cdc_map_time_to_lsn(/*<relational_operator>*/'smallest greater than', @begin_time); 
		-- the parameter <relational_operator> may have two values: SMALLEST GREATER THAN OR EQUAL or SMALLEST GREATER THAN

SET @to_lsn = sys.fn_cdc_map_time_to_lsn(/*<relational_operator>*/'largest less than or equal', @end_time);
		-- the parameter <relational_operator> may have two values: LARGEST LESS THAN OR EQUAL or LARGEST LESS THAN

SELECT * FROM cdc.fn_cdc_get_all_changes_Person_Person(@from_lsn, @to_lsn, /*<row_filter_options>*/'all update old'); 
		-- the parameter <row_filter_options> may have three values: ALL and ALL UPDATE OLD
GO

-- for explanation about option ALL WITH MASK
SELECT TOP 1 * 
FROM Person.Person
ORDER BY BusinessEntityID ASC

UPDATE Person.Person
SET EmailPromotion = 1
WHERE BusinessEntityID = 1

-- function net change - Used for capture the last value of the data, dispensing information of the update and delete statements
DECLARE	@begin_time datetime, 
		@end_time datetime, 
		@from_lsn binary(10), 
		@to_lsn binary(10);

SET @begin_time = GETDATE() -1;
SET @end_time = GETDATE();
SET @from_lsn = sys.fn_cdc_map_time_to_lsn(/*<relational_operator>*/'smallest greater than', @begin_time); 
		-- the parameter <relational_operator> may have two values: SMALLEST GREATER THAN OR EQUAL or SMALLEST GREATER THAN

SET @to_lsn = sys.fn_cdc_map_time_to_lsn(/*<relational_operator>*/'largest less than or equal', @end_time);
		-- the parameter <relational_operator> may have two values: LARGEST LESS THAN OR EQUAL or LARGEST LESS THAN

SELECT * FROM cdc.fn_cdc_get_net_changes_Person_Person(@from_lsn, @to_lsn, /*<row_filter_options>*/'all with mask'); 
		-- the parameter <row_filter_options> may have three values: ALL, ALL WITH MASK (return the final LSN of the row) and ALL WITH MERGE
GO
