﻿use master
go
create database QLBanHang
on primary (
	name = 'QLBanHang_dat',
	filename = 'F:\MyDataBase\QLBanHang.mdf',
	size=10MB,
	maxsize=50MB,
	filegrowth=10MB
)

log on(
	name = 'QLBanHang_log',
	filename = 'F:\MyDataBase\QLBanHang.ldf',
	size=1MB,
	maxsize=5MB,
	filegrowth=20%
)
go 
use QLBanHang
create table HangSX(
	MaHangSX nchar(10) not null primary key,
	TenHang nvarchar(20),
	DiaChi nvarchar(30),
	SoDT nvarchar(20), 
	Email nvarchar(30) not null
)

create table NhanVien(
	MaNV nchar(10) not null primary key,
	TenNV nvarchar(20),
	GioiTinh nchar(10) not null,
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30) not null,
	TenPhong nvarchar(30)
)

create table SanPham(
	MaSP nchar(10) not null primary key,
	MaHangSX nchar(10) not null,
	TenSP nvarchar(20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa ntext,
	constraint fk_Sp_HSX foreign key(MaHangSX)
		references HangSX(MaHangSX)
)

create table PNhap(
	SoHDN nchar(10) not null primary key,
	NgayNhap date,
	MaNV nchar(10) not null,
	constraint fk_pn_nv foreign key(MaNV)
		references NhanVien(MaNV)
)

create table Nhap(
	SoHDN nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongNhap int,
	DonGiaNhap money,
	constraint pk_nhap primary key(SoHDN, MaSP),
	constraint fk_n_pn foreign key(SoHDN)
		references PNhap(SoHDN),
	constraint fk_n_sp foreign key(MaSP)
		references SanPham(MaSP)
)

create table PXuat(
	SoHDX nchar(10) not null primary key,
	NgayXuat date,
	MaNV nchar(10) not null,
	constraint fk_px_nv foreign key(MaNV)
		references NhanVien(MaNV)
)

create table Xuat(
	SoHDX nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongXuat int,
	constraint pk_xuat primary key(SoHDX, MaSP),
	constraint fk_x_px foreign key(SoHDX)
		references PXuat(SoHDX),
	constraint fk_x_sp foreign key(MaSP)
		references SanPham(MaSP)
)
go

insert into HangSX
values('H01', 'Samsung', N'Korea', '011-08271717', 'ss@gmail.com.kr'),
('H02', 'OPPO', N'China', '081-08626262', 'oppo@gmail.com.cn'),
('H03', 'Vinfone', N'Việt Nam', ' 084-098262626', 'vf@gmail.com.vn')

insert into NhanVien 
values('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kế toán'),
('NV02', N'Lê Văn Nam', N'Nam', N'Bắc Ninh', '0972525252', 'nam@gmail.com', N'Vật tư'),
('NV03', N'Trần Hòa Bình', N'Nữ', N'Hà Nội', '0328388388', 'hb@gmail.com', N'Kế toán')

insert into SanPham 
values('SP01', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
('SP02', 'H01', 'Galaxy Note 11', 50, N'Đỏ', 19000000, N'Chiếc', N'Hàng cao cấp'),
('SP03', 'H02', 'F3 Lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông'),
('SP04', 'H03', 'Vjoy 3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông'),
('SP05', 'H01', 'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp')

insert into PNhap 
values('N01', '02-05-2019', 'NV01'),
	  ('N02', '04-07-2020', 'NV02'),
	  ('N03', '05-17-2020', 'NV02'),
	  ('N04', '03-22-2020', 'NV03'),
	  ('N05', '07-07-2020', 'NV01')

insert into Nhap 
values('N01', 'SP02', 10, 17000000),
('N02', 'SP01', 30, 6000000),
('N03', 'SP04', 20, 1200000),
('N04', 'SP01', 10, 6200000),
('N05', 'SP05', 20, 7000000)

insert into PXuat 
values('X01', '06-14-2020', 'NV02'),
	  ('X02', '03-05-2019', 'NV03'),
	  ('X03', '12-12-2020', 'NV01'),
	  ('X04', '06-02-2020', 'NV02'),
	  ('X05', '05-18-2020', 'NV01')

insert into Xuat 
values('X01', 'SP03', 5),
	  ('X02', 'SP01', 3),
	  ('X03', 'SP02', 1),
	  ('X04', 'SP03', 2),
	  ('X05', 'SP05', 1)

go

-- Hien thi thong tin tren cac bang du lieu
select * from SanPham
select * from HangSX
select * from NhanVien
select * from Nhap
select * from PNhap
select * from Xuat
select * from PXuat

/* Dua ra thong tin MaSP, TenSP, TenHang, SoLuong, MauSac, 
GiaBan, DonViTinh, MoTa cac san pham theo chieu giam dan gia ban */
select MaSP, TenSP, TenHang, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
order by GiaBan desc

-- Dua ra thong tin cac san pham co trong cua hang do cong ty co ten hang la Samsung san xuat
select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
from SanPham inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
Where TenHang='Samsung'

-- Dua ra thong tin cac nhan vien nu o phong 'ke toan'
select * 
from NhanVien 
where GioiTinh=N'Nữ' and TenPhong=N'Kế toán'

/* Dua ra thong tin phieu nhap gom: SoHDN, MaSP, TenSP, TenHang, SoLuongN, DonGiaN, TienNhap=SoLuongN*DonGiaN, 
MauSac, DonViTinh, NgayNhap, TenNV, TenPhong sap xep theo chieu tang dan SoHDN  */
select PNhap.SoHDN, SanPham.MaSP, TenSP, TenHang, SoLuongNhap, DonGiaNhap, SoLuongNhap*DonGiaNhap as N'TienNhap', MauSac, DonViTinh, NgayNhap, TenNV, TenPhong  
from Nhap inner join SanPham on Nhap.MaSP=SanPham.MaSP
inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
inner join NhanVien on NhanVien.MaNV=PNhap.MaNV
inner join HangSX on HangSX.MaHangSX=SanPham.MaHangSX
order by SoHDN asc 


/* Dua ra thong tin phieu nhap gom: SoHDX, MaSP, TenSP, TenHang, SoLuongX, GiaBan, TienXuat=SoLuongX*GiaBan, 
MauSac, DonViTinh, NgayXuat, TenNV, TenPhong trong thang 6/2020,  sap xep theo chieu tang dan SoHDX  */ 
select Xuat.SoHDX, SanPham.MaSP, TenSP, TenHang, SoLuongXuat, GiaBan, SoLuongXuat*GiaBan as N'TienXuat', MauSac, DonViTinh, NgayXuat, TenNV, TenPhong
from Xuat inner join SanPham on Xuat.MaSP=SanPham.MaSP
inner join PXuat on Xuat.SoHDX=PXuat.SoHDX
inner join NhanVien on PXuat.MaNV=NhanVien.MaNV
inner join HangSX on HangSX.MaHangSX=SanPham.MaHangSX
where YEAR(NgayXuat)=2020 and MONTH(NgayXuat)=06
order by SoHDX asc