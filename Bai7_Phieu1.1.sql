use master
go
create database QLBanH
on primary (
	name = 'QLBanHang_dat',
	filename = 'F:\DataBase_Temp\QLBanHang.mdf',
	size=10MB,
	maxsize=50MB,
	filegrowth=10MB
)

log on(
	name = 'QLBanHang_log',
	filename = 'F:\DataBase_Temp\QLBanHang.ldf',
	size=1MB,
	maxsize=5MB,
	filegrowth=20%
)
go 
use QLBanH
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
insert into NhanVien
values('NV04', N'Nguyễn Văn Cảnh', N'Nam', N'Hà Nội', '0328388388', 'hb@gmail.com', N'Kế toán'),
('NV05', N'Nguyễn Bình Minh', N'Nam', N'Hà Nam', '0328388364', 'bm@gmail.com', N'Kế toán'),
('NV06', N'Trần Văn Bình', N'Nam', N'Nghệ An', '0328756386', 'tvb@gmail.com', N'Vật tư')

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
-- a. Hãy xây dựng hàm Đưa ra tổng giá trị xuất của hãng tên hãng là A, trong năm tài khóa x, với A, x được nhập từ bàn phím.
create function tke1(@A nvarchar(20), @x int)
returns int
as
begin
	declare @tongxuat int
	set @tongxuat = (
		select SUM(SoLuongXuat*GiaBan)
		from Xuat inner join SanPham on Xuat.MaSP=SanPham.MaSP
		inner join HangSX on HangSX.MaHangSX=SanPham.MaHangSX
		inner join PXuat on PXuat.SoHDX=Xuat.SoHDX
		where TenHang=@A and YEAR(NgayXuat)=@x
	)
	return @tongxuat
end
select dbo.tke1('OPPO', 2019) as 'Gia tri Xuat'


-- b. Hãy xây dựng hàm thống kê số lượng nhân viên mỗi phòng với tên phòng nhập từ bàn phím.
create function tke2(@tenphong nvarchar(30))
returns int
as
begin
	declare @dem int
	set @dem = (
		select COUNT(*)
		from NhanVien
		where TenPhong=@tenphong
	)
	return @dem
end
select dbo.tke2(N'Vật tư') as N'Số NV'


-- c. Hãy viết hàm thống kê xem tên sản phẩm x đã xuất được bao nhiêu sản phẩm trong ngày y, với x,y nhập từ bản phím.
create function tke3(@x nvarchar(20), @y date)
returns int
as 
begin
	declare @soxuat int
	set @soxuat = (
		select count(*)
		from SanPham inner join Xuat on SanPham.MaSP=Xuat.MaSP
		inner join PXuat on PXuat.SoHDX=Xuat.SoHDX
		where TenSP=@x and NgayXuat=@y
	)
	return @soxuat
end
select dbo.tke3('F3 Lite', '06-02-2020') as 'So SP Xuat'


-- d. Hãy viết hàm trả về số diện thoại của nhân viên đã xuất số hóa đơn x, với x nhập từ bàn phím.
create function tke4(@SoHD nchar(10))
returns nvarchar(20)
as
begin
	declare @sodt nvarchar(20)
	set @sodt = (
		select SoDT
		from NhanVien inner join PXuat on NhanVien.MaNV=PXuat.MaNV
		inner join Xuat on Xuat.SoHDX=PXuat.SoHDX
		where Xuat.SoHDX=@SoHD
	)
	return @sodt
end
select dbo.tke4('X02') as 'Phone Number'


-- e. Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong năm y, với x,y nhập từ bàn phím.
create function tke5(@x nvarchar(20), @y int)
returns int
as 
begin
	declare @tongnhap int
	declare @tongxuat int
	declare @thaydoi int
	set @tongnhap = (
		select SUM(SoLuongNhap)
		from Nhap inner join SanPham on SanPham.MaSP=Nhap.MaSP
		inner join PNhap on PNhap.SoHDN=Nhap.SoHDN
		where TenSP=@x and YEAR(NgayNhap)=@y
	)
	set @tongxuat = (
		select SUM(SoLuongXuat)
		from Xuat inner join SanPham on SanPham.MaSP=Xuat.MaSP
		inner join PXuat on Xuat.SoHDX=PXuat.SoHDX
		where TenSP=@x and YEAR(NgayXuat)=@y
	)
	set @thaydoi = @tongnhap - @tongxuat
	return @thaydoi
end
select dbo.tke5('Galaxy V21', 2020)


-- f. Hãy viết hàm thống kê tổng số lượng sản phầm của hãng x, với tên hãng nhập từ bàn phím
create function tke6(@x nvarchar(20))
returns int
as
begin
	declare @tongsp int
	set @tongsp = (
		select COUNT(*)
		from SanPham inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
		where TenHang=@x
	)
	return @tongsp
end
select dbo.tke6('Vinfone') as 'So SP'