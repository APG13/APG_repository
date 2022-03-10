drop table if exists DepartamentoEmpresa
go
create table DepartamentoEmpresa
	(   Dept_ID int primary key clustered,
		Dept_Name varchar(90) not null,
		DeptCreado varchar(90) not null,
		NumEmpleados varchar(120),
	SysStartTime datetime2 generated always as row start not null,  
	SysEndTime datetime2 generated always as row end not null,  
	period for System_time (SysStartTime,SysEndTime) ) 
	with (System_Versioning = ON (History_Table = dbo.DepartamentoEmpresa_historico)
	) 
go


insert into DepartamentoEmpresa ([Dept_ID],[Dept_Name],[DeptCreado],[NumEmpleados])
values ( 1, 'Administracion', 'Febrero', '4'),
		( 2, 'Staff', 'Marzo', '6'),
		( 3, 'Cocina', 'Abril', '15'),
		( 4, 'Conductores', 'Mayo', '7')
go

select *
from DepartamentoEmpresa


--CAMBIOS (10 en lugar de 6)
update DepartamentoEmpresa
	set NumEmpleados = '10'
	where Dept_ID = 2
GO

--CONSULTA
select * 
from DepartamentoEmpresa
for system_time all 
go


