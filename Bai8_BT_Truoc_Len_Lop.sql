use master
create database QL
on primary(
	name='ql_dat',
	filename='F:\MyDataBase\quanlikhoa.mdf',
	size=5MB,
	maxsize=30MB,
	filegrowth=5%
)
log on(
	name='ql_log',
	filename='F:\MyDataBase\quanlikhoa.ldf',
	size=1MB,
	maxsize=20MB,
	filegrowth=2%
)
use QL
create table Khoa(
	Makhoa nchar(10) not null primary key,
	Tenkhoa nvarchar(20),
	Dienthoai char(12)
)

create table Lop(
	Malop nchar(8) not null primary key,
	Tenlop nvarchar(15),
	Khoa nvarchar(15),
	Hedt nvarchar(10),
	Namnhaphoc int,
	Makhoa nchar(10) not null,
	constraint fk_lop_khoa foreign key(Makhoa)
		references Khoa(Makhoa)
)


----------------------------- PHIEU 1 ------------------------------
-- Cau1: 
create proc sp_nhap_dl(@makhoa nchar(10), @tenkhoa nvarchar(20), @dienthoai char(12))
as
begin
	-- Kiem tra tenkhoa da ton tai chua?
	if(exists(select * from Khoa where Tenkhoa=@tenkhoa))
		print(N'Tên khoa đã tồn tại trong bảng')
	else
		begin 
			insert into Khoa
			values(@makhoa, @tenkhoa, @dienthoai)
		end
end
exec sp_nhap_dl 'IT', N'CNTT', '0352732983'
exec sp_nhap_dl 'KT', N'CNTT', '0356286293'
select * from Khoa



-- Cau 2:
create proc nhap_Dl_Lop(@malop nchar(8), @tenlop nvarchar(15), @khoa nvarchar(15), @hedt nvarchar(10), @namhoc int, @makhoa nchar(10))
as
begin 
	-- Kiem tra ten lop da co chua?
	if(exists(select * from Lop where Tenlop=@tenlop))
		print(N'Tên lớp đã tồn tại')
	else
		-- Kiem tra makhoa co trong bang khoa khong?
		if(not exists(select * from Khoa where Makhoa=@makhoa))
			print(N'Mã khoa chưa tồn tại')
		else
			insert into Lop
			values(@malop, @tenlop, @khoa, @hedt, @namhoc, @makhoa)
end
select * from Lop
select * from Khoa
exec nhap_Dl_Lop 'L01', N'IT-1', N'Công nghệ TT', N'Đại học', 2022, 'IT'



----------------------------- PHIEU 2 ------------------------------
-- Cau1: 
create proc sp_nhap_Khoa(@makhoa nchar(10), @tenkhoa nvarchar(20), @dienthoai char(12), @trave int output)
as
begin
	-- Kiem tra tenkhoa da ton tai chua?
	if(exists(select * from Khoa where Tenkhoa=@tenkhoa))
		set @trave = 0
	else
		begin 
			insert into Khoa
			values(@makhoa, @tenkhoa, @dienthoai)
		end
	return @trave
end
declare @bien1 int
exec sp_nhap_Khoa 'QT', N'QTKD', '0329832993', @bien1 output
select @bien1
select * from Khoa



-- Cau 2:
create proc sp_nhap_Lop(@malop nchar(8), @tenlop nvarchar(15), @khoa nvarchar(15), @hedt nvarchar(10), @namhoc int, @makhoa nchar(10), @trave int output)
as
begin 
	-- Kiem tra ten lop da co chua?
	if(exists(select * from Lop where Tenlop=@tenlop))
		set @trave = 0
	else
		-- Kiem tra makhoa co trong bang khoa khong?
		if(not exists(select * from Khoa where Makhoa=@makhoa))
			set @trave = 1
		else
			insert into Lop
			values(@malop, @tenlop, @khoa, @hedt, @namhoc, @makhoa)
			set @trave = 2
end
declare @bien2 int
exec sp_nhap_Lop 'L02', N'IT-2', N'Công nghệ TT', N'Đại học', 2021, 'IT', @bien2 output
select @bien2
select * from Lop