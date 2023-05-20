use master
go 
create database QLBH 
on primary (
	name='qlbh_dat',
	filename='F:\MyDataBase\QLBH.mdf',
	size=10MB,
	maxsize=50MB,
	filegrowth=10MB
)
log on (
	name='qlbh_log',
	filename='F:\MyDataBase\QLBH.ldf',
	size=1MB,
	maxsize=5MB,
	filegrowth=15%
)

go 
use QLBH 

create table CongTy(
	MaCT nchar(10) not null primary key,
	TenCT nvarchar(20) not null,
	TrangThai nvarchar(10),
	ThanhPho nvarchar(30)
)

create table SanPham(
	MaSP nchar(10) not null primary key, 
	TenSP nvarchar(20) not null,
	MauSac nchar(10) default N'Đỏ',
	Gia money,
	SoluongCo int,
	constraint unique_SP unique(TenSP)
)

create table Cungung(
	MaCT nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongBan int,
	constraint pk_cu primary key(MaCT, MaSP),
	constraint fk_cu_ct foreign key(MaCT)
		references CongTy(MaCT),
	constraint fk_cu_sp foreign key(MaSP)
		references SanPham(MaSP),
	constraint chk_slb check(SoLuongBan>0)
)


insert into CongTy
values('CTY01', 'HP', 'Hoat dong', 'Tp.HCM'),
      ('CTY02', 'Asus', 'Dong cua', 'Ha Noi'),
	  ('CTY04', 'Samsung', 'Hoat dong', 'Ha Noi')

insert into SanPham 
values('S01', 'SmartPhone', 'Bac', 9000000, '20'),
      ('S04', 'Ipad', 'Den', 12000000, '30'),
	  ('S03', 'Laptop', 'Trang', 20000000, '50')

insert into Cungung
values('CTY01', 'S01', '8'),
	  ('CTY02', 'S01', '6'),
	  ('CTY01', 'S03', '3'),
	  ('CTY04', 'S03', '4'),
	  ('CTY02', 'S04', '7'),
	  ('CTY04', 'S04', '4')

select * from CongTy
select * from SanPham
select * from Cungung