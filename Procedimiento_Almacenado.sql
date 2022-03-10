--PROCEDIMIENTO ALMACENADO


--Creacion de base de datos. Se puede emplear la del otro ejercicio sin modificarla o borrarla.
--drop database if exists DB_APG_10_Marzo
--create database DB_APG_10_Marzo

use DB_APG_10_Marzo
go

--Creacion de las nuevas tablas a raiz de las originales de AdventureWorks2017
drop table if exists Tabla_ProcAlmace_APG

SELECT [SalesOrderID]
	INTO Tabla_ProcAlmace_APG
	FROM AdventureWorks2017.Sales.SalesOrderHeader
GO

--Modificacion de la tabla para añadir los campos name y password
ALTER TABLE Tabla_ProcAlmace_APG
ADD		UserName VARCHAR(70),
		password VARCHAR(20) 
GO
--Comprobamos que haya las columnas, sin relleno
SELECT * FROM Tabla_ProcAlmace_APG
GO



--Relleno de campos (45001-45004)
UPDATE Tabla_ProcAlmace_APG
SET UserName = 'Pedro',password='Pedro'
WHERE [SalesOrderID]=45001
GO
UPDATE Tabla_ProcAlmace_APG
SET UserName = 'Adrian',password='Adrian'
WHERE [SalesOrderID]=45002
GO
UPDATE Tabla_ProcAlmace_APG
SET UserName = 'Manuel',password='Manuel'
WHERE [SalesOrderID]=45003
GO
UPDATE Tabla_ProcAlmace_APG
SET UserName = 'Ana',password='Ana'
WHERE [SalesOrderID]=45004
GO

--Consulta una vez hechos los ingresos
SELECT * 
FROM Tabla_ProcAlmace_APG
WHERE SalesOrderID between 45000 and 45005
GO



----------------------------------------
--CREACION DE LA VIEW
drop view if exists View_APG_10_MARZO

CREATE OR ALTER VIEW View_APG_10_MARZO
AS 
	SELECT * FROM Tabla_ProcAlmace_APG
GO

--CONSULTA DE DICHA VIEW
SELECT * 
FROM View_APG_10_MARZO
WHERE SalesOrderID between 45000 and 45005
GO


----------------------------------------------
--CREACION DEL PROCEDIMIENTO ALMACENADO
DROP PROC if exists sp_APG_10_MARZO

CREATE OR ALTER PROC sp_APG_10_MARZO
	@UserName VARCHAR(50), @password VARCHAR(10)
AS
IF EXISTS(SELECT *  
		FROM View_APG_10_MARZO
		WHERE UserName=@UserName AND password=@password)
				BEGIN
					UPDATE View_APG_10_MARZO
					SET [password]='Abc123..'
					WHERE [UserName]=@UserName;
					SELECT * FROM View_APG_10_MARZO
				END
	ELSE
	BEGIN
		PRINT 'ACCESO DENEGADO'
	END
GO



-----------------
--Pruebas de ejecucion del SP
--Con Adrian (existente ya)
EXECUTE sp_APG_10_MARZO 'Adrian', 'Adrian'
GO
EXECUTE sp_APG_10_MARZO 'Ana', 'Ana'
GO

--Consulta de las modificaciones
SELECT * 
FROM Tabla_ProcAlmace_APG
WHERE SalesOrderID between 45000 and 45005
GO

--Usuario que existe pero mete mal la contraseña
EXECUTE sp_APG_10_MARZO 'Pedro', 'Peter'
GO

--Usuario no existente, le devuelve mensaje de acceso denegado
EXECUTE sp_APG_10_MARZO 'Ruben','Ruben'
GO
