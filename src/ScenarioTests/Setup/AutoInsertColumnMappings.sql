-- select * from reportcolumnmapping
-- delete from reportcolumnmapping

  
INSERT INTO [dbo].[ReportColumnMapping]
           ([DataSourceTypeId]
           ,[UniqueName]
           ,[DisplayName]
           ,[MainCategory]
           ,[KnownTable]
           ,[FieldName]
           ,[IsCalculated]
           ,[FieldAggregationMethod]
           ,[DbType]
		   ,[Selectable]
           ) 
SELECT 
1 as [DataSourceTypeId]
, CONCAT(c.table_name, '_', c.column_name) as [UniqueName]
, CONCAT(c.table_name, ' ', c.column_name) as [DisplayName]
, c.table_name as [MainCategory]
, c.table_name as [KnownTable]
, c.column_name as [FieldName]
, 0 as [IsCalculated]
,CASE 
	WHEN  data_type = 'bit' then 'Bit'  
	WHEN  data_type = 'datetime' then 'Min'  
	WHEN  data_type = 'nvarchar' then 'Min'  
	WHEN  data_type = 'varchar' then 'Min'  
	WHEN  data_type = 'char' then 'Min'  
	ELSE 'Sum'  END
	as [FieldAggregationMethod]
, CASE
WHEN   data_type = 'int' then 'Int32'
WHEN   data_type = 'bigint' then 'Int64'
WHEN   data_type = 'decimal' then 'Decimal'
WHEN   data_type = 'datetime' then 'DateTime'
WHEN   data_type = 'bit' then 'Boolean'  
ELSE 'String' END 
as [DbType]
, 1 as [Selectable]
FROM [MagiQL].[INFORMATION_SCHEMA].[COLUMNS] c
 
 where not exists (select 1 from reportcolumnmapping where knowntable = c.table_name and fieldname = c.column_name)
 and  table_name in ('room','roomsensor')
 order by table_name, ordinal_position
