use master
go
create database MarkManagement
on primary(
	name='MarkManage_dat',
	filename='F:\MyDataBase\MarkManage.mdf',
	size=10MB,
	maxsize=50MB,
	filegrowth=10MB
)
log on(
	name='MarkManage_log',
	filename='F:\MyDataBase\MarkManage.ldf',
	size=2MB,
	maxsize=10MB,
	filegrowth=10%
)

go
use MarkManagement
create table Students(
	StudentID nvarchar(12) not null primary key,
	StudentName nvarchar(25) not null,
	DateofBirth datetime not null,
	Email nvarchar(40),
	Phone nvarchar(12),
	Class nvarchar(10)
)

create table Subjects(
	SubjectID nvarchar(10) not null primary key,
	SubjectName nvarchar(25) not null
)

create table Mark(
	StudentID nvarchar(12) not null,
	SubjectID nvarchar(10) not null,
	Date datetime,
	Theory tinyint,
	Practical tinyint,
	constraint pk_mark primary key(StudentID, SubjectID),
	constraint fk_m_st foreign key(StudentID)
		references Students(StudentID),
	constraint fk_m_sub foreign key(SubjectID)
		references Subjects(SubjectID)
)

go

insert into Students
values('AV0807005', N'Mai Trung Hiếu', '11-10-1989', 'trunghieu@yahoo.com', '0904115116', 'AV1'),
	  ('AV0807006', N'Nguyễn Quý Hùng', '02-12-1988', 'quyhung@yahoo.com', '0955667787', 'AV2'),
	  ('AV0807007', N'Đỗ Khắc Huỳnh', '02-01-1990', 'dachuynh@yahoo.com', '0988574747', 'AV2'),
	  ('AV0807009', N'An Đăng Khuê', '06-03-1986', 'dangkhue@yahoo.com', '0986757463', 'AV1'),
	  ('AV0807010', N'Nguyễn T.Tuyết Lan', '12-07-1989', 'tuyetlan@gmail.com', '0983310342', 'AV2'),
	  ('AV0807011', N'Đinh Phụng Long', '02-12-1990', 'phunglong@yahoo.com', null, 'AV1'),
	  ('AV0807012', N'Nguyễn Tuấn Nam', '02-03-1990', 'tuannam@yahoo.com', null, 'AV1')


insert into Subjects
values('S001', 'SQL'),
	  ('S002', 'Java Simplefield'),
	  ('S003', 'Active Server Page')

insert into Mark(StudentID, SubjectID, Theory, Practical, Date)
values('AV0807005', 'S001', 8, 25, '05-06-2008'),
	  ('AV0807006', 'S002', 16, 30, '05-06-2008'),
	  ('AV0807007', 'S001', 10, 25, '05-06-2008'),
	  ('AV0807009', 'S003', 7, 13, '05-06-2008'),
	  ('AV0807010', 'S003', 9, 16, '05-06-2008'),
	  ('AV0807011', 'S002', 8, 30, '05-06-2008'),
	  ('AV0807012', 'S001', 7, 31, '05-06-2008'),
	  ('AV0807005', 'S002', 12, 11, '06-06-2008'),
	  ('AV0807010', 'S001', 7, 6, '06-06-2008')

select * from Students
select * from Subjects
select * from Mark	