use master
go 
create database QuanLyDonHang
on primary (
	name='QL_dat',
	filename='F:\MyDataBase\QL.mdf',
	size=10MB,
	maxsize=50MB,
	filegrowth=5MB
)
log on(
	name='QLDH_log',
	filename='F:\MyDataBase\QL.ldf',
	size=2MB,
	maxsize=20MB,
	filegrowth=2%
)

go

use QuanLyDonHang

create table KHACHHANG(
	MaKH nchar(10) not null primary key,
	Hoten nvarchar(20), 
	Ngaysinh date,
	Quequan nvarchar(20),
	Gioitinh nchar(10)
)

create table NHANVIEN(
	MaNV nchar(10) not null primary key,
	HotenNV nvarchar(20),
	Namlamviec int,
	Luong money
)
create table DONDATHANG(
	SoHD nchar(10) not null primary key,
	MaKH nchar(10) not null,
	MaNV nchar(10) not null, 
	constraint fk_ddh_kh foreign key(MaKH)
		references KHACHHANG(MaKH),
	constraint fk_ddh_nv foreign key(MaNV)
		references NHANVIEN(MaNV),
	Sanpham nvarchar(30)
)

 go
 
 insert into KHACHHANG
 values('KH1', N'Trần Bình Minh', '1979-05-01', N'Hà Nội', N'Nam'),
('KH2', N'Khổng Tước', '2000-03-08', N'Hà Tĩnh', N'Nam'),
('KH3', N'Đặng Nga', '1997-01-05', N'Hà Nội', N'Nữ')


insert into NHANVIEN
values('N1', N'Trần An Nhiên', 2013, 60000000),
('N2', N'Lê Bình An', 2018, 90000000),
('N3', N'Phạm Huy Văn', 2020, 50000000)


insert into DONDATHANG
values
('H001', 'KH1', 'N1', N'Son Môi'),
('H002', 'KH2', 'N2', N'Kem Dưỡng'),
('H003', 'KH3', 'N2', N'Túi')


insert into NHANVIEN
values('N4', N'Lê Văn An', 1999, 4000000)

/* Thuc hien cac truy van	*/
-- Cau 2
select nv.MaNV, HotenNV, Luong
from  NHANVIEN nv inner join DONDATHANG ddh on nv.MaNV=ddh.MaNV
inner join KHACHHANG kh on kh.MaKH=ddh.MaKH
where Hoten=N'Khổng Tước'


-- Cau 3
select MaNV, HotenNV, Luong
from NHANVIEN 
where Namlamviec>2012 and HotenNV=N'Trần An Nhiên'


-- Cau 4
select MaNV, HotenNV, Luong
from NHANVIEN
where Luong = (
	select MAX(Luong)
	from NHANVIEN
)


-- Cau 5
select top 2 MaKH, Hoten, YEAR(GETDATE())-YEAR(Ngaysinh) as N'Tuổi'
from KHACHHANG
where Quequan=N'Hà Nội'
order by Hoten desc

-- Cau 6
insert into DONDATHANG values('H004', 'KH2', 'N3', N'Ô TÔ')


-- Cau 7
select KHACHHANG.MaKH, Hoten, YEAR(GETDATE())-YEAR(Ngaysinh) as N'Tuổi', Sanpham
from KHACHHANG inner join DONDATHANG on KHACHHANG.MaKH=DONDATHANG.MaKH
inner join NHANVIEN nv on nv.MaNV=DONDATHANG.MaNV
where HotenNV=N'Lê Bình An'


-- Cau 8
select KHACHHANG.MaKH, Hoten, COUNT(*) as N'Số lượng SP'
from KHACHHANG inner join DONDATHANG on KHACHHANG.MaKH=DONDATHANG.MaKH
group by KHACHHANG.MaKH, Hoten


-- Cau 9
select nv.MaNV, HotenNV
from NHANVIEN nv inner join DONDATHANG dh on nv.MaNV=dh.MaNV
where Sanpham=N'Son môi'


-- Cau 10
select top 2 MaNV, HotenNV, Luong
from NHANVIEN
order by Luong asc


-- CAu 11
select KHACHHANG.MaKH, Hoten, YEAR(GETDATE())-YEAR(Ngaysinh) as 'Tuổi'
from KHACHHANG inner join DONDATHANG on KHACHHANG.MaKH=DONDATHANG.MaKH
inner join NHANVIEN on DONDATHANG.MaNV=NHANVIEN.MaNV
where HotenNV=N'Lê Bình An' and Sanpham=N'Son môi' and Quequan=N'Hà Nội'


-- Cau 12
select NHANVIEN.MaNV, HotenNV, count(*) as N'SL hàng bán'
from NHANVIEN inner join DONDATHANG
on NHANVIEN.MaNV = DONDATHANG.MaNV
group by NHANVIEN.MaNV, HotenNV


-- Cau 13
select Quequan, count(*) N'Số KH'
from KHACHHANG
group by Quequan


-- Cau 14
select HotenNV
from NHANVIEN
where MaNV not in (
	select MaNV
	from DONDATHANG
)

-- Cau 15
select *
from KHACHHANG 
where MaKH not in(
	select distinct MaKH
	from DONDATHANG
)

-- Cau 16
select distinct *
from KHACHHANG
where MaKH in(
	select distinct MaKH
	from DONDATHANG
)

-- Cau 17
select NHANVIEN.MaNV, HotenNV, Luong, Sanpham
from NHANVIEN inner join DONDATHANG on NHANVIEN.MaNV=DONDATHANG.MaNV
inner join KHACHHANG on KHACHHANG.MaKH=DONDATHANG.MaKH
where Hoten like '%Nga'

-- Xoa cac nhan vien chua ban mat hang nao ca
delete from NHANVIEN
where MaNV not in(
	select distinct MaNV 
	from DONDATHANG
)

-- Cap nhat Luong tang 500.000 cho cac nhan vien da ban duoc hang
update NHANVIEN
set Luong = Luong + 500000
where MaNV in(
	select distinct MaNV 
	from DONDATHANG
)

-- Xoa cac hoa don ma khach hang 'Khong Tuoc' da mua
delete from DONDATHANG
where MaKH in(
	select MaKH
	from KHACHHANG
	where Hoten = N'Khổng Tước'
)

-- Xoa cac khach hang co que Ha Tinh
delete from DONDATHANG
where MaKH in(
	select MaKH
	from KHACHHANG
	where Quequan=N'Hà Tĩnh'
)
DELETE FROM KHACHHANG
WHERE Quequan = N'Hà Tĩnh'

-- Them moi 2 khach hang, 2 nhan vien va 3 don dat hang thoa man rang buoc
insert into KHACHHANG
values('KH5', N'Nguyễn Ngọc', '1980-04-12', N'Hà Tây', N'Nữ'),
('KH6', N'Trần Nam', '1999-02-14', N'Hải Dương', N'Nam')

insert into NHANVIEN
values('N5', N'Đặng Huyền', 2015, 30000000),
('N6', N'Trịnh Thảo', 2017, 10000000)

insert into DONDATHANG
values('H004', 'KH5', 'N3', N'Mặt nạ dưỡng da'),
('H005', 'KH6', 'N5', N'Kem nền'),
('H006', 'KH3', 'N6', N'Sữa rửa mặt')
--insert into KHACHHANG values('KH10', N'Nguyễn Hải Nam', '2010-03-15', N'Thái Bình', N'Nam')
--insert into DONDATHANG values('H010', 'KH10', 'N6', N'Kính mắt')

-- Xoa cac khach hang <18 tuoi
delete from DONDATHANG
where MaKH in(
	select MaKH 
	from KHACHHANG
	where YEAR(getdate())-YEAR(Ngaysinh)<18
)
delete from KHACHHANG
where YEAR(getdate())-YEAR(Ngaysinh)<18 


-- Tru luong cac nhan vien chua ban duoc hang nao ca 100000
update NHANVIEN
set Luong = Luong - 100000
where MaNV not in(
	select distinct MaNV
	from DONDATHANG
)


-- Xoa cac khach hang ten Nga que Ha Noi
delete from DONDATHANG
where MaKH in(
	select MaKH from KHACHHANG
	where Hoten like '%Nga' and Quequan=N'Hà Nội'
)
delete from KHACHHANG
where Hoten like '%Nga' and Quequan=N'Hà Nội'

-- Cap nhat nam lam viec tang len 1 cho tat ca cac nhan vien
update NHANVIEN
set Namlamviec = Namlamviec+1


-- Tang luong cho cac nhan vien co luong <5000000 them 200000
update NHANVIEN
set Luong=Luong+200000
where Luong<5000000