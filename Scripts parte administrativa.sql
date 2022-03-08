--FILESTREAM_FOTO
USE TripAdvisor 
GO

alter database TripAdvisor
	add filegroup [FileStream_APG] contains filestream 
go 
--Commands completed successfully.


--Modificacion de la base de datos
alter database TripAdvisor 
	add file ( 
		name='TripAdvisor_Filestream', 
		filename='c:\Data\TripAdvisor_Filestream') 
	to filegroup FileStream_APG 
go


--Consulta
drop table if exists Restaurante_foto

select * into Restaurante_foto
from Restaurante




Alter table Restaurante_foto 
Add ID_Foto UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL, 
Foto_local VARBINARY(MAX) FILESTREAM NULL UNIQUE NONCLUSTERED (ID_Foto ASC)



insert into Restaurante_foto
values (1,'PlayaClub','620202020','playaclub@hotmail.com','Restaurante a pie de playa','www.playaclub.com','24h','-',NEWID(),NULL)

insert into Restaurante_foto
values (2,'Abore da Veira','600500415','areboredaveira@hotmail.com','Restaurante con vistas a la ciudad','www.arboredaveira.com','6h','-',NEWID(),NULL)




UPDATE Restaurante_foto 
SET Foto_local = ( 
SELECT * FROM 
OPENROWSET (BULK 'c:\img\mesa.jpg', SINGLE_BLOB) AS Imagen)
WHERE Id_Restaurante = 1; 
GO

UPDATE Restaurante_foto 
SET Foto_local = ( 
SELECT * FROM 
OPENROWSET (BULK 'c:\img\arobredaveira.png', SINGLE_BLOB) AS Imagen)
WHERE Id_Restaurante = 2; 
GO


select *
from Restaurante_foto



-----------------------------------------------------------------
CREATE DATABASE PruebaAPG
ON PRIMARY
(
    NAME = PruebaAPG_data,
    FILENAME = 'C:\FileTable\PruebaAPG.mdf'
),
FILEGROUP FileStreamFG CONTAINS FILESTREAM
(
    NAME = PruebaAPG,
    FILENAME = 'C:\FileTable\PruebaAPG_Container' 
)
LOG ON
(
    NAME = PruebaAPG_Log,
    FILENAME = 'C:\FileTable\PruebaAPG_Log.ldf'
)
WITH FILESTREAM
(NON_TRANSACTED_ACCESS = FULL,
 DIRECTORY_NAME = 'FileTableTripAdvisor'
);
GO

use PruebaAPG

CREATE TABLE PruebaAPG_TripAdvisor
AS FILETABLE
WITH 
(
    FileTable_Directory = 'FileTableTripAdvisor',
    FileTable_Collate_Filename = database_default
);
GO


SELECT *
FROM PruebaAPG_TripAdvisor
GO



------------------------------------------------------
------------------------------------------------------
--POWERBI
drop table if exists Fotos_hotel


CREATE Table Fotos_hotel
(
    Fotos_hotelId int,
    Fotos_hotelName varchar(255),
	Fotos_hotelImage varbinary(max)
)
go



INSERT INTO dbo.Fotos_hotel( Fotos_hotelId,Fotos_hotelName,Fotos_hotelImage)  
SELECT  1,'Blue Hotel',  
      * FROM OPENROWSET  
      ( BULK 'C:\img\blue.jpg',SINGLE_BLOB)  as Imagen
GO

INSERT INTO dbo.Fotos_hotel
( 
  Fotos_hotelId,
  Fotos_hotelName,
  Fotos_hotelImage
)  
SELECT  2,'Hotel Finisterre',  
      * FROM OPENROWSET  
      ( BULK 'C:\img\finisterre.jpg',SINGLE_BLOB)  as Imagen
GO

INSERT INTO dbo.Fotos_hotel
( 
  Fotos_hotelId,
  Fotos_hotelName,
  Fotos_hotelImage
)  
SELECT  3,'Trip Maria Pita',  
      * FROM OPENROWSET  
      ( BULK 'C:\img\trip.jpg',SINGLE_BLOB)  as Imagen
go

SELECT * FROM dbo.Fotos_hotel
GO











------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
--BASE DE DATOS CONTENIDA

--Primero hay que activar la siguiente opcion
EXEC SP_CONFIGURE 'contained database authentication', 1
GO
-- Actualizar
RECONFIGURE
GO

--Creacion de la base de datos, y el siguiente usuario.
DROP DATABASE IF EXISTS TripAdvisorContenida_APG
GO
CREATE DATABASE TripAdvisorContenida_APG
CONTAINMENT=PARTIAL
GO

--Una vez creada la activamos
USE TripAdvisorContenida_APG
GO

DROP USER IF EXISTS AdrianPG
GO
CREATE USER AdrianPG
	WITH PASSWORD='abcd1234.',
	DEFAULT_SCHEMA=[dbo]
go
-- Añadimos el usuario AdrianPG el rol dbo_owner, y darle permisos de conexión
ALTER ROLE db_owner
ADD MEMBER AdrianPG
GO

GRANT CONNECT TO AdrianPG
GO








-------------------------------------------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
--PARTICIONES

--CREACION DE BASE DE DATOS
DROP DATABASE IF EXISTS TripAdvisor_FeedbackFecha  
GO
CREATE DATABASE TripAdvisor_FeedbackFecha
	ON PRIMARY ( NAME = 'TripAdvisor_FeedbackFecha ', 
		FILENAME = 'C:\Data\TripAdvisor_FeedbackFecha _Fijo.mdf' , 
		SIZE = 15360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 0) 
	LOG ON ( NAME = 'TripAdvisor_FeedbackFecha _log', 
		FILENAME = 'C:\Data\TripAdvisor_FeedbackFecha _log.ldf' , 
		SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%) 
GO


USE TripAdvisor_FeedbackFecha
GO

-- CREATE FILEGROUPS CON LAS VALORACIONES POR FECHAS
ALTER DATABASE [TripAdvisor_FeedbackFecha ] ADD FILEGROUP [APG_Archivo] 
GO  
ALTER DATABASE [TripAdvisor_FeedbackFecha ] ADD FILEGROUP [APG_2020] 
GO 
ALTER DATABASE [TripAdvisor_FeedbackFecha ] ADD FILEGROUP [APG_2021]
GO
ALTER DATABASE [TripAdvisor_FeedbackFecha ] ADD FILEGROUP [APG_2022]
GO

select * from sys.filegroups
GO

--CREACION DE ARCHIVOS

ALTER DATABASE [TripAdvisor_FeedbackFecha] 
ADD FILE ( NAME = 'Fechas_Archivo', FILENAME = 'c:\DATA\Fechas_Archivo.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) 
TO FILEGROUP [APG_Archivo] 
GO
ALTER DATABASE [TripAdvisor_FeedbackFecha] 
ADD FILE ( NAME = 'Fechas_2020', FILENAME = 'c:\DATA\Fechas_2020.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) 
TO FILEGROUP [APG_2020] 
GO
ALTER DATABASE [TripAdvisor_FeedbackFecha] 
ADD FILE ( NAME = 'Fechas_2021', FILENAME = 'c:\DATA\Fechas_2021.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) 
TO FILEGROUP [APG_2021] 
GO
ALTER DATABASE [TripAdvisor_FeedbackFecha] 
ADD FILE ( NAME = 'Fechas_2022', FILENAME = 'c:\DATA\Fechas_2022.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) 
TO FILEGROUP [APG_2022] 
GO


select * from sys.filegroups
GO

select * from sys.database_files
GO


------------------------------------------------------
-- PARTITION FUNCTION
-- BOUNDARIES (LIMITES)

--Creacion de la función donde se establecen los limites de fechas.
--1. Datos de 2020
--2. Datos de 2020
--3. Datos posteriores a 01/01/2021

CREATE PARTITION FUNCTION FN_fecha_feedback (datetime) 
AS RANGE RIGHT 
	FOR VALUES ('2020-01-01','2021-01-01')
GO


--AHORA SE ASIGNAN LOS RANGOS
--partition scheme
create partition scheme feedback_fecha
as partition FN_fecha_feedback
	to (APG_Archivo, APG_2020, APG_2021, APG_2022)
go


--TABLA DE EJEMPLO:
drop table if exists dbo.FeedbackAPG
go

create table dbo.FeedbackAPG(
	id_FeedBack int not null,
	dni_cliente varchar(9),
	fecha datetime
	)
	on feedback_fecha --scheme
		(fecha)--columna a aplicar el schema
go



--Datos del 2019:
insert into dbo.FeedbackAPG
values (1, '53155430R', '2019-01-11 10:00:00'),
		(2, '52754615T', '2019-01-14 10:30:00'),
		(3, '53166530Y', '2019-01-19 10:45:00')
go


--Datos del 2020:
insert into dbo.FeedbackAPG
values (4, '32429452G', '2020-01-2 09:30:00'),
		(5, '53166533G', '2020-01-20 09:30:00'),
		(6, '53166530Y', '2020-01-23 09:45:00')
go


--Datos del 2021:
insert into dbo.FeedbackAPG
values (7, '47367813A', '2021-01-15 09:30:00' ),
		(8, '41565300A', '2021-01-25 09:30:00' ),
		(9, '53166530Y', '2021-01-8 09:45:00')
go


--Datos del 2022:
insert into dbo.FeedbackAPG
values (10, '53166530y','2022-01-28 09:30:00'),
		(11, '47367813A', '2022-02-03 09:35:00'),
		(12, '63353362D','2022-02-03 09:40:00')
go




--CONSULTA

select * from dbo.FeedbackAPG
go


--SELECT PARA VER LAS PARTICIONES
select name, create_date, value from sys.partition_functions f 
inner join sys.partition_range_values rv 
on f.function_id=rv.function_id 
where f.name = 'FN_fecha_feedback'
go

--SELECT PARA VER LOS REGISTROS DE CADA PARTICION
select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'FeedbackAPG' 
GO


--PARTICIONES, FILEGROUPS Y LIMTES:
DECLARE @TableName NVARCHAR(200) = N'FeedbackAPG' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] ,
p.partition_number AS [p#] ,
fg.name AS [filegroup] 
, p.rows ,
au.total_pages AS pages ,
CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison ,
rv.value ,
CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) +
SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS
first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id 
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id 
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number 
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id 
AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO


---------------------------------------------------
--SPLIT

ALTER PARTITION FUNCTION FN_fecha_feedback() 
	SPLIT RANGE ('2022-01-01'); 
GO

select *,$Partition.FN_fecha_feedback(fecha) AS partition
from dbo.FeedbackAPG
go


------------------
DECLARE @TableName NVARCHAR(200) = N'FeedbackAPG' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] ,
p.partition_number AS [p#] ,
fg.name AS [filegroup] 
, p.rows ,
au.total_pages AS pages ,
CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison ,
rv.value ,
CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) +
SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS
first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id 
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id 
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number 
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id 
AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO



-------------------------------

--MERGE
alter partition function FN_fecha_feedback ()
merge range ('2020-01-01')
go



----------------------------------------
--SWITCH
--Creacion de una tabla de pruebas. De Feedback a Opiniones
drop database if exists Archivo_OpinionesAPG

create table dbo.OpinionesAPG(
	id_FeedBack int not null,
	dni_cliente varchar(9),
	fecha datetime
	)
	on APG_Archivo
go


alter table dbo.FeedbackAPG
	switch partition 1 to OpinionesAPG
go

--Consulta de las dos tablas
select * from FeedbackAPG
go

select * from OpinionesAPG
go

--Con el select completo de particiones, filegroup, registros y limites:



------------------------------------------------------
--TRUNCATE (borrar registros)
TRUNCATE TABLE FeedbackAPG 
	WITH (PARTITIONS (3));
go


select * from FeedbackAPG
GO






------------------------------------------------------
------------------------------------------------------
------------------------------------------------------


--TABLAS TEMPORALES DEL SISTEMA
--bd
DROP DATABASE IF EXISTS TripAdv_TableTemp 
GO
CREATE DATABASE TripAdv_TableTemp
	ON PRIMARY ( NAME = 'TripAdv_TableTemp', 
		FILENAME = 'C:\Data\TripAdv_TableTemp_Fijo.mdf' , 
		SIZE = 15360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 0) 
	LOG ON ( NAME = 'TripAdv_TableTemp_log', 
		FILENAME = 'C:\Data\TripAdv_TableTemp_log.ldf' , 
		SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%) 
GO


use TripAdv_TableTemp
go

drop table if exists reservaAPG
go
create table reservaAPG
	(   id_reserva int primary key clustered,
		name_hotel varchar(90) not null,
		cliente varchar(90) not null,
		informacion varchar(120),
	SysStartTime datetime2 generated always as row start not null,  
	SysEndTime datetime2 generated always as row end not null,  
	period for System_time (SysStartTime,SysEndTime) ) 
	with (System_Versioning = ON (History_Table = dbo.reservaAPG_historico)
	) 
go


--Insertamos valores a la tabla. Hay que marcar que columnas queremos realizar inserciones ya que si no daria fallo.
insert into reservaAPG ([id_reserva],[name_hotel],[cliente],[informacion])
values ( 1, 'Maria Pita', 'David', 'Preferencia cama individual'),
		( 2, 'Blue Hotel', 'Adrian', 'Preferencia dos camas individuales'),
		( 3, 'Hotel Plaza', 'Pardiñas', 'Cama doble si puede ser'),
		( 4, 'Finisterre', 'Ana', 'Habitacion con jacuzzi'),
		( 5, 'Avenida', 'Pedro', 'Habitacion con terraza'),
		( 6, 'Royale', 'Juan', 'Habitacion fumadores')
go

--Consulta
select * from reservaAPG
go

select * from dbo.reservaAPG_historico



--Realizamos un update
update reservaAPG
	set informacion = 'Cama doble'
	where id_reserva = 2
GO

--Realizamos un borrado
delete from reservaAPG
where id_reserva=1
go

--Nuevo insert
insert into reservaAPG ([id_reserva],[name_hotel],[cliente],[informacion])
values ( 7, 'Attica', 'Tomás', 'Suite Premium')
go

--CONSULTA GENERAL
select * 
from reservaAPG
for system_time all 
go

--CONSULTA HISTORICA EN UN PERIODO CONCRETO
select * 
from reservaAPG
for system_time from '2022-03-07 13:42:08.7814794' to '2022-03-07 13:56:10.7972677' 
go


--Registros modificados en un periodo de tiempo concreto.
select * 
from reservaAPG
for system_time contained in ('2022-03-07 13:37:27.9533807','2022-03-07 13:42:08.7814794')
GO



------------------------------------------------------
------------------------------------------------------
-------------------------------------------------------------
--TABLAS EN MEMORIA
drop database if exists TripAdvAPG_TBinmemory
go
create database TripAdvAPG_TBinmemory
go

use TripAdvAPG_TBinmemory
go

--Es necesario activar el "memory_optimized_elevate_to_snapshot"
alter database current
	set memory_optimized_elevate_to_snapshot = on
go


--create an optimized filegroup
alter database TripAdvAPG_TBinmemory
	add filegroup TripAdvAPG_mod
	contains memory_optimized_data
go

--se ha de agregar uno o mas contenedores al MEMORY_OPTIMIZED_DATA filegroup
alter database TripAdvAPG_TBinmemory
	add file	(name='TripAdvAPG_mod1',
				filename='c:\data\TripAdvAPG_mod1')
	to filegroup TripAdvAPG_mod
go



--Creacion de tabla de ejemplo
drop table if exists reservaAPG_inmemory
go
create table reservaAPG_inmemory
(
	id_reserva int primary key nonclustered, --Es necesario que la PK sea clustered
	name_hotel varchar(90) not null,
	cliente varchar(90) not null,
	informacion varchar(120)
)
with
	(memory_optimized = on,
	durability = schema_and_data)
go
