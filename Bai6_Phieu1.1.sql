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


-- Xoa cac vat tu co DonGiaX<DonGiaN
delete from Ton
where MaVT in(
	select MaVT from Xuat
	where DonGiaX < (
		select DonGiaN from Nhap 
		where Nhap.MaVT = Xuat.MaVT
	)
)
delete from Xuat
where MaVT in (
	select MaVT from Ton
	where MaVT not in(
		select MaVT from Nhap
	)
)


-- Cap nhat NgayX=NgayN neu NgayX<NgayN cua cac mat hang co MaVT giong nhau
Update Xuat
set NgayX = Nhap.NgayN
from Xuat
inner join Nhap
on Nhap.MaVT=Xuat.MaVT
where NgayX<NgayN
