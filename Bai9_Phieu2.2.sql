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


-- a (3đ). Tạo thủ tục nhập liệu cho bảng HangSX, với các tham biến truyền vào MaHangSX, TenHang, DiaChi, SoDT, Email. 
-- Hãy kiểm tra xem TenHang đã tồn tại trước đó hay chưa, nếu rồi trả về mã lỗi 1? Nếu có rồi thì không cho nhập và trả về mã lỗi 0.
CREATE PROC sp_nhapHangSX(@mahsx nchar(10),
    @tenhang nvarchar(20),
    @diachi nvarchar(30),
    @sdt nvarchar(20),
    @email nvarchar(30),
    @kq int output)
AS
BEGIN
    if(exists(select *
    from HangSX
    where TenHang = @tenhang))
        set @kq = 0
    ELSE    
        BEGIN
        INSERT into HangSX
        VALUES(@mahsx, @tenhang, @diachi, @sdt, @email)
        set @kq = 1
    END
END

DECLARE @bien1 int
-- khong nhap duoc
--EXEC sp_nhapHangSX 'H07', 'Samsung', 'Germany', '032-1892898', 'sis@gmail.ss', @bien1 output
-- Nhap du lieu moi
EXEC sp_nhapHangSX 'H07', 'Readmi', 'Germany', '032-1892898', 'sis@gmail.ss', @bien1 output
SELECT @bien1
select *
from HangSX

-- b (3đ). Viết thủ tục nhập dữ liệu cho bảng Nhap với các tham biến SoHDN, MaSP, manv, NgayNhap, SoLuongN, DonGiaN. 
-- Kiểm tra xem MaSP có tồn tại trong bảng SanPham hay không, nếu không trả về 1? manv có tồn tại trong bảng NhanVien hay không nếu không trả về 2? 
-- ngược lại thì hãy kiểm tra: Nếu SoHDN đã tồn tại thì cập nhật bảng Nhap theo SoHDN, ngược lại thêm mới bảng Nhap và trả về mã lỗi 0.
CREATE PROC sp_Nhap(@sohdn nchar(10),
    @masp nchar(10),
    @manv nchar(10),
    @ngaynhap date,
    @sln int,
    @gianhap money,
    @kq int output)
AS
BEGIN
    if(not exists(select *
    from SanPham
    where MaSP = @masp))
        SET @kq = 1
    ELSE if(not exists(select *
    from NhanVien
    where MaNV = @manv))
        set @kq = 2
    ELSE
        if(exists(select *
    from Nhap
    where SoHDN = @sohdn))
            BEGIN
        UPDATE Nhap
                SET MaSP = @masp,
                SoLuongNhap = @sln,
                DonGiaNhap = @gianhap
                WHERE SoHDN = @sohdn
    END
        ELSE
            BEGIN
        set @kq = 0
        INSERT INTO Nhap
        VALUES(@sohdn, @masp, @sln, @gianhap)

        INSERT INTO PNhap
        VALUES(@sohdn, @ngaynhap, @manv)
    END
END


-- c (4đ). Viết thủ tục nhập dữ liệu cho bảng Xuat với các tham biến SoHDX, MaSP, manv, NgayXuat, SoLuongX. 
-- Kiểm tra xem MaSP có tồn tại trong bảng SanPham hay không nếu không trả về 1? manv có tồn tại trong bảng NhanVien hay không nếu không trả về 2? SoLuongX <= SoLuong nếu không trả về 3? 
-- ngược lại thì hãy kiểm tra: Nếu SoHDX đã tồn tại thì cập nhật bảng Xuat theo SoHDX, ngược lại thêm mới bảng Xuat và trả về mã lỗi 0.
CREATE PROC sp_Xuat(@sohdx nchar(10),
    @masp nchar(10),
    @manv nchar(10),
    @ngayxuat date,
    @slx int,
    @kq int output)
as
BEGIN
    if(not exists(select *
    from SanPham
    where MaSP = @masp))
        SET @kq = 1
    ELSE if(not exists(select *
    from NhanVien
    where MaNV = @manv))
        set @kq = 2
    ELSE if(@slx > (select SoLuongXuat
    from Xuat))
        set @kq = 3
    ELSE
        IF(exists(SELECT *
    from Xuat
    where SoHDX = @sohdx))
            BEGIN
        UPDATE Xuat
                SET MaSP = @masp,
                SoLuongXuat = @slx
                WHERE SoHDX = @sohdx
    END
        ELSE
            BEGIN
        INSERT INTO Xuat
        VALUES(@sohdx, @masp, @slx)
        INSERT INTO PXuat
        VALUES(@sohdx, @ngayxuat, @manv)
    END
END