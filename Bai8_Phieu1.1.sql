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


----------------- Phieu 1.1 -----------------
-- Cau1: 
CREATE PROCEDURE sp_Them_nhan_vien(
	@manv nvarchar(4),
    @macv nvarchar(2),
    @tennv nvarchar(30),
    @ns datetime,
    @luongcb float,
    @ngay int,
    @phucap float
)
AS
BEGIN
    IF(NOT EXISTS(select * from Chucvu where MaCV=@macv))
        PRINT(N'Chuc vu nay khong ton tai trong bang')
    ELSE
        INSERT INTO Nhanvien
        VALUES(@manv, @macv, @tennv, @ns, @luongcb, @ngay, @phucap)
END
EXEC sp_Them_nhan_vien 'NV06', 'KT', N'Nguyễn Thu Huyền', '1978-12-25', 400000, 26, 300000
select * from Nhanvien


-- Cau2:
create proc sp_Capnhat_nhan_vien(
	@manv nvarchar(4),
    @macv nvarchar(2),
    @tennv nvarchar(30),
    @ns datetime,
    @luongcb float,
    @ngay int,
    @phucap float
)
as
begin
	if(not exists(select * from Chucvu where MaCV=@macv))
		print(N'Chức vụ không tồn tại')
	else
		update Nhanvien
		set MaCV=@macv,
		TenNV=@tennv,
		NgaySinh=@ns,
		LuongCanBan=@luongcb,
		PhuCap=@phucap
		where MaNV=@manv
end
exec sp_Capnhat_nhan_vien 'NV03', 'GD', N'Nguyễn Hải Nam', '1978-12-15', 400000, 27, 300000
select * from Nhanvien


-- Cau3:
create proc sp_LuongLN
AS
BEGIN
    SELECT TenNV, LuongCanBan*NgayCong+PhuCap as N'Luong LN'
	from Nhanvien
END
exec sp_LuongLN


