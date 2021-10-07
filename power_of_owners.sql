create database TestDB
go

use TestDB

--CREACION DE SCHEMA
create schema HR

drop table if exists HR.Employee


--CREACION DE TABLA
create table HR.Employee
	(EmployeeID char(2),
	GivenName varchar (50),
	Surname varchar (50),
	ssn char (9));
go

select * from HR.Employee


--CREACION DE VIEW
drop view if exists HR.LookupEmployee
go

create view HR.LookupEmployee
as
select 
	EmployeeID, GivenName, Surname
from Hr.Employee;
go


--CREACION DE ROL (grupo de usuarios)
drop role if exists HumanResourcesAnalyst
go
create role HumanResourcesAnalyst
go

grant select on HR.LookupEmployee TO HumanResourcesAnalyst;
go

--CREACION DE USUARIO
drop user if exists JaneDoe
go
create user JaneDoe without login;
go

--AÑADIR EL USUARIO AL ROL
alter role HumanResourcesAnalyst
add member JaneDoe
go


--This will work
--JaneDow has SELECT against the view
--She does not have SELECT against the table
--Ownership chaining makes this hapen

-------------------------------------------------------------------------
execute as user = 'JaneDoe';
go

select * from HR.LookupEmployee;
go

print user
