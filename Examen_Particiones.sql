--PARTICIONES
--Creacion de base de datos
drop database if exists DB_APG_10_Marzo
create database DB_APG_10_Marzo

use DB_APG_10_Marzo
go

select *
into Tabla_Particion_APG
from AdventureWorks2017.Sales.SalesOrderHeader

select *
from Tabla_Particion_APG


--Creacion de Filegroups
ALTER DATABASE [DB_APG_10_Marzo] ADD FILEGROUP [APG_2011]
ALTER DATABASE [DB_APG_10_Marzo] ADD FILEGROUP [APG_2012]
ALTER DATABASE [DB_APG_10_Marzo] ADD FILEGROUP [APG_2013]
ALTER DATABASE [DB_APG_10_Marzo] ADD FILEGROUP [APG_2014]
--ALTER DATABASE [DB_APG_10_Marzo] ADD FILEGROUP [APG_Archivo]



--Creacion de archivos a filegroups
ALTER DATABASE [DB_APG_10_Marzo] 
ADD FILE ( NAME = 'APG_2011', FILENAME = 'c:\Examen\APG_2011.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) 
TO FILEGROUP [APG_2011] 
GO
ALTER DATABASE [DB_APG_10_Marzo] 
ADD FILE ( NAME = 'APG_2012', FILENAME = 'c:\Examen\APG_2012.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) 
TO FILEGROUP [APG_2012] 
GO
ALTER DATABASE [DB_APG_10_Marzo] 
ADD FILE ( NAME = 'APG_2013', FILENAME = 'c:\Examen\APG_2013.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) 
TO FILEGROUP [APG_2013] 
GO
ALTER DATABASE [DB_APG_10_Marzo] 
ADD FILE ( NAME = 'APG_2014', FILENAME = 'c:\Examen\APG_2014.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) 
TO FILEGROUP [APG_2014] 
GO


--Consulta
select * from sys.filegroups
GO

select * from sys.database_files
GO



--CREACIÓN DE PARTICION, va a ser particiones por año.
CREATE PARTITION FUNCTION Function_APG_Anual(DateTime)
AS RANGE RIGHT
FOR VALUES ('2012-01-01','2013-01-01','2014-01-01')
go

--Asignación de rangos
create partition scheme scheme_APG_Anual
as partition Function_APG_Anual
	to (APG_2011,APG_2012,APG_2013,APG_2014)
go



---------------------------------------------------------------
--Consultas
select *
from Tabla_Particion_APG

SELECT groupname
FROM sys.sysfilegroups
go

----------------------------------------------------------------

--Consulta 1
select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'Tabla_Particion_APG' 
GO


--Consulta 2
DECLARE @TableName NVARCHAR(200) = N'Tabla_Particion_APG' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--No muestra resultado, solo las cabeceras de las columnas. 
--Para corregirlo, hay que crear el CLUSTERED INDEX

CREATE CLUSTERED INDEX APG_Index
		ON Tabla_Particion_APG
		(	
			OrderDate asc 
		)
		ON scheme_APG_Anual(OrderDate) --Schema (Columna)


--Consulta 2 de nuevo 
DECLARE @TableName NVARCHAR(200) = N'Tabla_Particion_APG' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] , p.partition_number AS [p#] , fg.name AS [filegroup] , p.rows , au.total_pages AS pages , CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison , rv.value , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) + SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20), CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO




-----------------------------------------------------
-----------------------------------------------------
--SPLIT
--Para realizarlo, es necesario crear un nuevo filegroup para añadir la nueva particion
ALTER DATABASE [DB_APG_10_Marzo] ADD FILEGROUP [APG_Archivo]

ALTER DATABASE [DB_APG_10_Marzo] 
ADD FILE ( NAME = 'Archivo', FILENAME = 'c:\Examen\Archivo.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) 
TO FILEGROUP [APG_Archivo] 
GO

ALTER PARTITION SCHEME scheme_APG_Anual
NEXT USED APG_Archivo


---------------------------
--Creacion del split
ALTER PARTITION FUNCTION Function_APG_Anual() 
	SPLIT RANGE ('2015-01-01'); 
GO

--Insertamos para hacer la comprobacion del año 2015
INSERT INTO [dbo].[Tabla_Particion_APG]
           ([RevisionNumber],[OrderDate],[DueDate],[ShipDate],[Status],[OnlineOrderFlag],[SalesOrderNumber],[PurchaseOrderNumber],[AccountNumber],[CustomerID],[SalesPersonID],[TerritoryID],[BillToAddressID],[ShipToAddressID],[ShipMethodID],[CreditCardID],[CreditCardApprovalCode],[CurrencyRateID],[SubTotal],[TaxAmt],[Freight],[TotalDue],[rowguid],[ModifiedDate])
VALUES ('8','2015-02-03','2015-05-05','2015-07-07','5','1','SO75123',NULL,'10-4030-018759','18759',NULL,'6','14024','14024','1','10084','230370Vi51970',NULL,'120','12','5','5','D54752FF-2B54-4BE5-95EA-3B72289C059F',getdate());
GO

--Consulta de que en la nueva particion hay un nuevo registro
select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'Tabla_Particion_APG' 
GO


-------------------------
--TRUNCATE
TRUNCATE TABLE Tabla_Particion_APG
	WITH (PARTITIONS (5));
go

select * from Tabla_Particion_APG
GO