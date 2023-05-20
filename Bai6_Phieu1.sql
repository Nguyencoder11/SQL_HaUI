USE master
CREATE DATABASE QuanLyBH
on primary(
    name='quanly_dat',
    filename='F:\MyDataBase\quanly.mdf',
    size=5MB,
    maxsize=50MB,
    filegrowth=5%
)
log on(
    name='quanly_log',
    filename='F:\MyDataBase\quanly.ldf',
    size=2MB,
    maxsize=20MB,
    filegrowth=2MB
)


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



create table HangSX
(
    MaHangSX nchar(10) not null primary key,
    TenHang nvarchar(20),
    DiaChi nvarchar(30),
    SoDT nvarchar(20),
    Email nvarchar(30) not null
)

create table NhanVien
(
    MaNV nchar(10) not null primary key,
    TenNV nvarchar(20),
    GioiTinh nchar(10) not null,
    DiaChi nvarchar(30),
    SoDT nvarchar(20),
    Email nvarchar(30) not null,
    TenPhong nvarchar(30)
)

create table SanPham
(
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

create table PNhap
(
    SoHDN nchar(10) not null primary key,
    NgayNhap date,
    MaNV nchar(10) not null,
    constraint fk_pn_nv foreign key(MaNV)
		references NhanVien(MaNV)
)

create table Nhap
(
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

create table PXuat
(
    SoHDX nchar(10) not null primary key,
    NgayXuat date,
    MaNV nchar(10) not null,
    constraint fk_px_nv foreign key(MaNV)
		references NhanVien(MaNV)
)

create table Xuat
(
    SoHDX nchar(10) not null,
    MaSP nchar(10) not null,
    SoLuongXuat int,
    constraint pk_xuat primary key(SoHDX, MaSP),
    constraint fk_x_px foreign key(SoHDX)
		references PXuat(SoHDX),
    constraint fk_x_sp foreign key(MaSP)
		references SanPham(MaSP)
)



-- Đưa ra các thông tin về các hóa đơn mà hãng Samsung đã nhập trong năm 2020, gồm: SoHDN, MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong. 
create view cau1 as 
select Nhap.SoHDN, SanPham.MaSP, TenSP, SoLuongNhap, DonGiaNhap, NgayNhap, TenNV, TenPhong
from Nhap inner join SanPham on Nhap.MaSP=SanPham.MaSP
inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
inner join NhanVien on PNhap.MaNV=NhanVien.MaNV
inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
where TenHang='Samsung' and YEAR(NgayNhap)=2020


-- Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng Samsung. 
create view cau2 as
select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
from SanPham inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
where TenHang='Samsung' and GiaBan between 100000 and 500000 


-- Tính tổng tiền đã nhập trong năm 2020 của hãng Samsung.
create view cau3 as
select SUM(SoLuongNhap*DonGiaNhap) as 'Tong tien nhap'
from Nhap inner join SanPham on Nhap.MaSP=SanPham.MaSP
inner join HangSX on HangSX.MaHangSX=SanPham.MaHangSX
inner join PNhap on PNhap.SoHDN=Nhap.SoHDN
where YEAR(NgayNhap)=2020 and TenHang='Samsung'


-- Thống kê tổng tiền đã xuất trong ngày 14/06/2020. 
create view cau4 as
select SUM(SoLuongXuat*GiaBan) as 'Tong tien xuat'
from Xuat inner join SanPham on Xuat.MaSP=SanPham.MaSP
inner join PXuat on Xuat.SoHDX=PXuat.SoHDX
where NgayXuat='06/14/2020'


-- Đưa ra SoHDN, NgayNhap có tiền nhập phải trả cao nhất trong năm 2020. 
create view cau5 as
select Nhap.SoHDN, NgayNhap
from Nhap inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
where year(NgayNhap)=2020 and SoLuongNhap*DonGiaNhap = (
	select max(SoLuongNhap*DonGiaNhap)
	from Nhap inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
	where year(NgayNhap)=2020
)


-- Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm 
create view cau6
as
select HangSX.MaHangSX, TenHang, count(*) as 'So luong SP'
from HangSX inner join SanPham on HangSX.MaHangSX=SanPham.MaHangSX
group by HangSX.MaHangSX, TenHang


-- Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020. 
create view cau7 as
select SanPham.MaSP, TenSP, sum(SoLuongNhap*DonGiaNhap) as 'Tong tien nhap'
from SanPham inner join Nhap on Nhap.MaSP=SanPham.MaSP
inner join PNhap on PNhap.SoHDN=Nhap.SoHDN
where year(NgayNhap)=2020
group by SanPham.MaSP, TenSP


-- Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn 10.000 sản phẩm của hãng Samsung.
create view cau8 as
select SanPham.MaSP, TenSP, Sum(SoLuongXuat*GiaBan) as 'Tong xuat'
from SanPham inner join Xuat on Xuat.MaSP=SanPham.MaSP
inner join PXuat on PXuat.SoHDX=Xuat.SoHDX
inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
where year(NgayXuat)=2020 and TenHang='Samsung'
group by SanPham.MaSP, TenSP
having sum(SoLuongXuat)>=10000


-- Thống kê số lượng nhân viên Nam của mỗi phòng ban.
create view cau9 as
select TenPhong, count(MaNV) as 'So nhan vien'
from NhanVien
where GioiTinh=N'Nam'
group by TenPhong


-- Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
create view cau10 as
select HangSX.MaHangSX, TenHang, sum(SoLuongNhap) as 'Tong nhap'
from Nhap inner join PNhap on Nhap.SoHDN=PNhap.SoHDN
inner join SanPham on Nhap.MaSP=SanPham.MaSP
inner join HangSX on SanPham.MaHangSX=HangSX.MaHangSX
where YEAR(NgayNhap)=2018
group by HangSX.MaHangSX, TenHang



-- Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu.
create view cau11
as
select TenNV, sum(SoLuongXuat*GiaBan) as 'Tong tien xuat'
from NhanVien inner join PXuat on PXuat.MaNV=NhanVien.MaNV
inner join Xuat on Xuat.SoHDX=PXuat.SoHDX
inner join SanPham on Xuat.MaSP=SanPham.MaSP
where year(NgayXuat)=2018
group by TenNV

