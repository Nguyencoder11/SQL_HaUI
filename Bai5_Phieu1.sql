use master
create database TRUONGHOC
on primary(
	name='school_dat',
	filename='F:\MyDataBase\school.mdf',
	size=5MB,
	maxsize=30MB,
	filegrowth=5%
)

log on(
	name='school_log',
	filename='F:\MyDataBase\school.ldf',
	size=2MB,
	maxsize=25MB,
	filegrowth=2%
)

use TRUONGHOC

create table HocSinh(
	MaHS char(5) not null primary key,
	Ten nvarchar(30),
	Nam bit,
	NgaySinh datetime,
	DiaChi varchar(20),
	DiemTB float
)

create table GiaoVien(
	MaGV char(5) not null primary key,
	Ten nvarchar(30),
	Nam bit,
	NgaySinh datetime,
	DiaChi varchar(20),
	Luong money
)

create table LopHoc(
	MaLop char(5) not null primary key,
	TenLop nvarchar(30),
	Soluong int
)

insert into HocSinh
values('HS001', N'Nguyễn Văn A', 1, '2005-01-01', N'Hà Nội', 8.5),
('HS002', N'Trần Thị B', 0, '2006-02-02', N'Hồ Chí Minh', 7.8),
('HS003', N'Lê Văn C', 1, '2005-03-03', N'Đà Nẵng', 9.0)

insert into GiaoVien
values('GV001', N'Nguyễn Thị X', 0, '1980-01-01', N'Hà Nội', 10000000),
('GV002', N'Trần Văn Y', 1, '1985-02-02', N'Hồ Chí Minh', 12000000),
('GV003', N'Lê Thị Z', 0, '1990-03-03', N'Đà Nẵng', 15000000)

insert into LopHoc
values('LH001', N'Lớp Toán', 30),
('LH002', N'Lớp Văn', 35),
('LH003', N'Lớp Anh', 25)

-- Them du lieu vao bang
insert into HocSinh
values('HS004', N'Đặng Thị D', 0, '2006-05-12', N'Nghệ An', 8.0)

insert into GiaoVien
values('GV004', N'Le Van H', 1, '1988-03-25', N'Hà Nội', 10000000)

insert into LopHoc
values('LH004', N'Lớp Hóa', 40)

-- Sua du lieu
update GiaoVien 
set Luong=12000000
where Ten=N'Le Van H'

-- Xóa tất cả dữ liệu trong Table HOCSINH
DELETE dbo.HOCSINH
--Hoặc
TRUNCATE TABLE dbo.HOCSINH
-- Xóa những giáo viên có lương hơn 5000:
DELETE dbo.GIAOVIEN WHERE LUONG >5000

-- Xóa những giáo viên có lương hơn 5000 và mã số giáo viên <15
DELETE dbo.GIAOVIEN WHERE LUONG > 5000 AND MAGV < 15

-- Xóa những học sinh có điểm TB là 1; 8; 9.
DELETE dbo.HOCSINH WHERE DIEMTB IN (1,8,9)

-- Xóa những học sinh có mã học sinh thuộc danh sách FD001, FD002, FD003
SELECT* FROM dbo.HOCSINH WHERE MAHS IN ('FD002','FD001')

-- Xóa những học sinh có điểm trong khoảng 1 đến 8
DELETE dbo.HOCSINH WHERE DIEMTB BETWEEN 1 AND 8

-- Xóa những học sinh có địa chỉ không phải ở Đà Lạt.
DELETE dbo.HOCSINH WHERE DIACHI NOT LIKE 'DALAT'

-- Cập nhập dữ liệu trong Table (Update Record)
-- Cập nhập Lương của tất cả giáo viên thành 10000
UPDATE dbo.GIAOVIEN SET LUONG = 10000

-- Cập nhập lương của tất cả giáo viên thành 10000 và địa chỉ tại DALAT
UPDATE dbo.GIAOVIEN SET LUONG = 10000, DIACHI ='DALAT'

-- Cập nhập lương của những giáo viên nam thành 1
UPDATE dbo.GIAOVIEN SET LUONG = 1
WHERE Nam='1'