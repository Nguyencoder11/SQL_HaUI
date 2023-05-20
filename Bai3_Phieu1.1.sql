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

/* Thuc hien cac truy van */
-- hien thi noi dung bang Department
select * from Department

-- hien thi noi dung bang Emloyee
select * from Employee

-- hien thi employee number, employee firstname, employee lastname 
-- tu bang Employee khi employee co firstname la 'Kate'
select EmpNo, Fname, Lname
from Employee
where Fname = 'Kate'

-- hien thi ghep 2 truong Fname va Lname thanh FullName, Salary, 10%Salary
select concat(Fname, ' ', Lname) as fullName, Salary, Salary*1.1 as IncreasedSalary
from Employee

-- hien thi Fname, Lname, HireDate cho tat ca cac Employ co HireDate la nam 1981 
-- va xep theo tang dan cua Lname
select Fname, Lname, HireDate
from Employee
where YEAR(HireDate) = 1981
order by Lname asc


-- hien thi trung binh(average), lon nhat(max), nho nhat(min) cua salary cho tung phong ban
select DepartmentNo, avg(Salary) as AvgSalary, MAX(Salary) as MaxSalary, MIN(Salary) as MinSalary
from Employee
group by DepartmentNo

-- hien thi DepartmentNo, so nguoi trong tung ban
select DepartmentNo, COUNT(*) as NumOfEmployees
from Employee
group by DepartmentNo

-- hien thi DepartmentNo, DepartmentName, FullName, Job, Salary trong 2 bang
select d.DepartmentNo, d.DepartmentName, CONCAT(e.Fname, ' ',e.Lname) as FullName, e.Job, e.Salary
from Department d
inner join Employee e on d.DepartmentNo = e.DepartmentNo

-- hien thi DepartmentNo, DepartmentName, Location va so nguoi co trong tung phong ban cua 2 bang
select d.DepartmentNo, d.DepartmentName, d.Location,  count(*) as NumOfEmployees
from Department d
inner join Employee e on d.DepartmentNo = e.DepartmentNo
group by d.DepartmentNo, d.DepartmentName, d.Location


-- hien thi tat ca DepartmentNo, DepartmentName, Location va so nguoi co trong tung phong ban cua 2 bang
select d.DepartmentNo, d.DepartmentName, d.Location, count(e.EmpNo) as NumOfEmployees
from Department d
left join Employee e on d.DepartmentNo = e.DepartmentNo
group by d.DepartmentNo, d.DepartmentName, d.Location
