use master
create database QLKHO
on primary (
	name='qlkho_dat',
	filename='F:\MyDataBase\dlkho.mdf',
	size=5MB,
	maxsize=30MB,
	filegrowth=5%
)
log on (
	name='qlkho_log',
	filename='F:\MyDataBase\dlkho.ldf',
	size=2MB,
	maxsize=20MB,
	filegrowth=2%
)

use QLKHO
create table Ton(
	MaVT nchar(10) not null primary key,
	TenVT nvarchar(20), 
	SoLuongT int
)

create table Nhap(
	SoHDN nchar(10) not null,
	MaVT nchar(10) not null,
	constraint pk_nhap primary key(SoHDN, MaVT),
	constraint fk_nhap_ton foreign key(MaVT)
		references Ton(MaVT),
	SoLuongN int,
	DonGiaN money,
	NgayN date
)

create table Xuat(
	SoHDX nchar(10) not null,
	MaVT nchar(10) not null,
	constraint pk_xuat primary key(SoHDX, MaVT),
	constraint fk_xuat_ton foreign key(MaVT)
		references Ton(MaVT),
	SoLuongX int,
	DonGiaX money,
	NgayX date
)

insert into Ton
values('VT01', N'Vật tư 1', 10),
('VT02', N'Vật tư 2', 30),
('VT03', N'Vật tư 3', 20),
('VT04', N'Vật tư 4', 10),
('VT05', N'Vật tư 5', 40)

insert into Nhap
values
('N01', 'VT01', 8, 150000, '2022-10-12'),
('N02', 'VT03', 10, 100000, '2021-09-25'),
('N03', 'VT05', 20, 90000, '2021-02-03')

insert into Xuat
values
('X01', 'VT03', 5, 200000, '2023-05-15'),
('X02', 'VT05', 10, 200000, '2022-12-20')

-- Dưa ra tên vật tư số lượng tồn nhiều nhất 
create view max_sl
as
select TenVT from Ton
where SoLuongT = (select max(SoLuongT) from Ton)
select * from max_sl

-- Dưa ra các vật tư có tổng số lượng xuất lớn hơn 100
create view max_slx
as
select Ton.MaVT, TenVT
from Ton inner join Xuat on Ton.MaVT=Xuat.MaVT
group by Ton.MaVT, TenVT
having sum(SoLuongX)>=100
select * from max_slx


-- Tạo view đưa ra tháng xuất, năm xuất, tổng số lượng xuất thống kê theo tháng và năm xuất 
create view lietke1
as
select MONTH(NgayX) as 'Thang xuat', YEAR(NgayX) as 'Nam xuat', SUM(SoLuongX) as 'So luong xuat'
from Xuat
group by MONTH(NgayX), YEAR(NgayX)
select * from lietke1


-- tạo view đưa ra mã vật tư, tên vật tư, số lượng nhập, số lượng xuất, đơn giá N, đơn giá X, ngày nhập, Ngày xuất.
create view lietke2
as
select Ton.MaVT, TenVT, SoLuongN, SoLuongX, DonGiaN, DonGiaX, NgayN, NgayX
from Ton inner join Nhap on Ton.MaVT=Nhap.MaVT
inner join Xuat on Ton.MaVT=Xuat.MaVT
select * from lietke2


-- Tạo view đưa ra mã vật tư, tên vật tư và tổng số lượng còn lại trong kho, biết còn lại = SoluongN-SoLuongX+SoLuongT theo từng loại Vật tư trong năm 2015
create view lietke3
as
select Ton.MaVT, TenVT,sum(soluongN)-sum(soluongX) + sum(soluongT) as 'Tong SL con lai'
from Nhap inner join Ton on Nhap.MaVT=Ton.MaVT
inner join Xuat on Ton.MaVT=Xuat.MaVT
where Year(NgayN)=2015 and Year(NgayX)=2015
group by Ton.MaVT, TenVT
select * from lietke3
