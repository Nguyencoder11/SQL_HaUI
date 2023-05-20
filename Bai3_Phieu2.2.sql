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
values('AV0807005', N'Mai Trung Hiếu', '1989-10-11', 'trunghieu@yahoo.com', '0904115116', 'AV1'),
('AV0807006', N'Nguyễn Quý Hùng', '1988-12-02', 'quyhung@yahoo.com', '0955667787', 'AV2'),
('AV0807007', N'Đỗ Khắc Huỳnh', '1990-01-02', 'dachuynh@yahoo.com', '0988574747', 'AV2'),
('AV0807009', N'An Đăng Khuê', '1986-03-06', 'dangkhue@yahoo.com', '0986757463', 'AV1'),
('AV0807010', N'Nguyễn T.Tuyết Lan', '1989-07-12', 'tuyetlan@gmail.com', '0983310342', 'AV2'),
('AV0807011', N'Đinh Phụng Long', '1990-12-02', 'phunglong@yahoo.com', null, 'AV1'),
('AV0807012', N'Nguyễn Tuấn Nam', '1990-03-02', 'tuannam@yahoo.com', null, 'AV1')


insert into Subjects
values('S001', 'SQL'),
('S002', 'Java Simplefield'),
('S003', 'Active Server Page')

insert into Mark(StudentID, SubjectID, Date, Theory, Practical)
values('AV0807009', 'S002', '2008-06-06', 11, 20),
('AV0807010', 'S001', '2008-06-06', 7, 6)


-- hien thi thong tin bang Students
select * from Students

-- hien thi noi dung danh sach sinh vien lop AV1
select Class, StudentID, StudentName, DateofBirth, Email, Phone
from Students
where Class = 'AV1'


-- update chuyen sinh vien ma AV0807012 sang lop AV2
update Students
set Class='AV2'
where StudentID='AV0807012'



-- tinh so sinh vien tung lop
select Class, COUNT(*) as StudentsOfClass
from Students
group by Class

-- hien thi ds sinh vien lop AV2 sap xep theo StudentName tang dan
select Class, StudentID, StudentName, DateofBirth, Email, Phone
from Students
where Class='AV2'
order by StudentName asc; 

-- hien thi danh sach sinh vien khong dat ly thuyet mon S001(theory<10) thi ngay 6/5/2008
SELECT Mark.StudentID, Students.StudentName, Mark.SubjectID, Mark.Theory, Mark.Date
FROM Mark INNER JOIN Students ON Mark.StudentID = Students.StudentID
WHERE Mark.Theory < 10 AND Mark.Date = '2008-05-06' AND Mark.SubjectID = 'S001';

-- hien thi tong so sinh vien khong dat ly thuyet mon S001(theory<10)
select distinct count(*)
from Mark
where Theory<10 and SubjectID='S001';


-- hien thi danh sach sinh vien lop AV1 va sinh sau ngay 1/1/1980
select StudentID, StudentName, DateofBirth, Email, Phone
from Students
where Class='AV1' and DateofBirth > '1980-01-01';


-- xoa sinh vien co ma AV0807011
-- xoa theo rang buoc
delete from Mark
where StudentID='AV0807011';
delete from Students
where StudentID='AV0807011';


-- Hien thi danh sach sinh vien du thi mon S001 ngay 6/5/2008
select S.StudentID, S.StudentName, SJ.SubjectName, M.Theory, M.Practical, M.Date
from Students S inner join Mark M on S.StudentID=M.StudentID 
inner join Subjects SJ on M.SubjectID = SJ.SubjectID
where SJ.SubjectID='S001' and M.Date='2008-05-06'