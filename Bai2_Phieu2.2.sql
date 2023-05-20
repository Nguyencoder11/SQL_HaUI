use master
go 
create database DeptEmp
on primary(
	name='DeptEmp_dat',
	filename='F:\MyDataBase\DeptEmp.mdf',
	size=10MB,
	maxsize=50MB,
	filegrowth=10MB
)
log on(
	name='DeptEmp_log',
	filename='F:\MyDataBase\DeptEmp.ldf',
	size=5MB,
	maxsize=20MB,
	filegrowth=5%
)

go 
use DeptEmp

create table Department(
	DepartmentNo int primary key,
	DepartmentName char(25) not null,
	Location char(25) not null
)

create table Employee(
	EmpNo int primary key,
	Fname varchar(15) not null,
	Lname varchar(15) not null, 
	Job varchar(25) not null,
	HireDate datetime not null, 
	Salary numeric not null,
	Commision numeric,
	DepartmentNo int,
	constraint fk_em_de foreign key(DepartmentNo)
		references Department(DepartmentNo)
)
go 
insert into Department
values(10, 'Accounting', 'Melbourne'),
(20, 'Research', 'Adealide'),
(30, 'Sales', 'Sydney'),
(40, 'Operations', 'Perth')

insert into Employee
values(1, 'John', 'Smith', 'Clerk', '17-Dec-1980', 800, null, 20),
(2, 'Peter', 'Allen', 'Salesman', '20-Feb-1981', 1600, 300, 30),
(3, 'Kate', 'Ward', 'Salesman', ' 22-Feb-1981', 1250, 500, 30),
(4, 'Jack', 'Jones', 'Manager', '02-Apr-1981', 2975, null, 20),
(5, 'Joe', 'Martin', 'Salesman', '28-Sep-1981', 1250, 1400, 30)

select * from Department
select * from Employee