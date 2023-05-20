use master
create database QLNV
on primary(
	name='qlnv_dat',
	filename='F:\MyDataBase\qlnv.mdf',
	size=5MB,
	maxsize=30MB,
	filegrowth=5%
)

log on(
	name='qlnv_log',
	filename='F:\MyDataBase\qlnv.ldf',
	size=2MB,
	maxsize=20MB,
	filegrowth=1MB
)
use QLNV
create table Chucvu(
	MaCV nvarchar(2) not null primary key,
	TenCV nvarchar(30)
)

create table Nhanvien(
	MaNV nvarchar(4) not null primary key,
	MaCV nvarchar(2),
	constraint fk_nv_cv foreign key(MaCV)
		references Chucvu(MaCV),
	TenNV nvarchar(30),
	NgaySinh datetime,
	LuongCanBan float,
	NgayCong int,
	PhuCap float
)
insert into Chucvu 
values('BV', N'Bảo Vệ'),
('GD', N'Giám Đốc'),
('HC', N'Hành Chính'),
('KT', N'Kế Toán'),
('TQ', N'Thủ Quỹ'),
('VS', N'Vệ Sinh')

insert into Nhanvien
values('NV01', 'GD', N'Nguyễn Văn An', '1977-12-12', 700000, 25, 500000),
('NV02', 'BV', N'Bùi Văn Tí', '1978-10-10', 400000, 24, 100000),
('NV03', 'KT', N'Trần Thanh Nhật', '1977-09-09', 600000, 26, 400000),
('NV04', 'VS', N'Nguyễn Thị Út', '1980-10-10', 300000, 26, 300000),
('NV05', 'HC', N'Lê Thị Hà', '1979-10-10', 500000, 27, 200000)



----------------- Phieu 2.2 -----------------
-- Cau1:
create proc sp_chen_ban_ghi_moi(
	@manv nvarchar(4),
    @macv nvarchar(2),
    @tennv nvarchar(30),
    @ns datetime,
    @luongcb float,
    @ngay int,
    @phucap float,
	@trave int output
)
as
begin
	if(not exists(select * from Chucvu where MaCV=@macv))
		set @trave=0
	else
		insert into Nhanvien
		values(
			@manv,
			@macv,
			@tennv,
			@ns,
			@luongcb,
			@ngay,
			@phucap
		)
end
declare @kq int
exec sp_chen_ban_ghi_moi 'NV07', 'KT', N'Phạm Minh Đức', '1977-02-14', 300000, 25, 200000, @kq output
select @kq
select * from Nhanvien



-- Cau2:
create proc sp_sua_thu_tuc(@manv nvarchar(4),
    @macv nvarchar(2),
    @tennv nvarchar(30),
    @ns datetime,
    @luongcb float,
    @ngay int,
    @phucap float,
	@kq int output)
as
begin 
	if(not exists(select * from Chucvu where MaCV=@macv))
		set @kq=1
	else
		if(exists(select * from Nhanvien where MaNV=@manv))
			set @kq=0
		else
			begin
				insert into Nhanvien 
				values(
					@manv,
					@macv,
					@tennv,
					@ns,
					@luongcb,
					@ngay,
					@phucap
				)
			end
end
declare @output int
exec sp_sua_thu_tuc 'NV08', 'BV', N'Lê Phương Thảo', '2003-03-04', 200000, 23, 150000, @output output
select @output
select * from Nhanvien


-- Cau3:
create proc sp_cap_nhat(@manv nvarchar(4), @ngaysinh datetime, @result int output)
as
begin
	if(not exists(select * from Nhanvien where MaNV=@manv))
		set @result=0
	else
		update Nhanvien
		set NgaySinh=@ngaysinh
		where MaNV=@manv
end
declare @bien int
exec sp_cap_nhat 'NV04', '1996-11-25', @bien output
select @bien
select * from Nhanvien
