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

-- Bai 1:
-- a. Tạo thủ tục nhập dữ liệu cho bảng sản phẩm với các tham biến truyền vào MaSP, TenHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa. 
-- Hãy kiểm tra xem nếu MaSP đã tồn tại thì cập nhật thông tin sản phẩm theo mã, ngược lại thêm mới sản phẩm vào bảng SanPham. 
CREATE PROC Bai1_a(@masp nchar(10),
    @tenhsx nvarchar(20),
    @tensp nvarchar(20),
    @sl int,
    @mausac nvarchar(20),
    @gia money,
    @dvt nchar(10),
    @mota ntext)
AS
BEGIN
    IF(NOT EXISTS(SELECT * FROM HangSX WHERE TenHang = @tenhsx))
        print(N'Tên hàng không tồn tại')
    ELSE
        BEGIN
            DECLARE @mahangsx NVARCHAR(10)
            SELECT @mahangsx = MaHangSX FROM HangSX WHERE TenHang = @tenhsx
            IF(EXISTS(SELECT * FROM SanPham WHERE MaSP = @masp))
                UPDATE SanPham
                SET MaHangSX = @mahangsx,
                    TenSP = @tensp,
                    SoLuong = @sl,
                    MauSac = @mausac,
                    GiaBan = @gia,
                    DonViTinh = @dvt,
                    MoTa = @mota
                WHERE MaSP = @masp
            ELSE
                INSERT INTO SanPham VALUES(@masp, @mahangsx, @tensp, @sl, @mausac, @gia, @dvt, @mota)
        END
END
-- Trường hợp đúng: Cập nhật
Exec Bai1_a 'SP01',N'Nokia','a11100',5,N'xanh',2000000,N'Chiếc',N'Sản phẩm phổ
thông'
-- Trường hợp đúng: Thêm mới 
Exec Bai1_a 'SP06',N'Vinfone','Read Mi',5,N'Tím', 50000000, N'Chiếc', N'Sản phẩm 
cao cấp'
-- Trường hợp sai:”Không có sản phẩm Noki”
Exec Bai1_a 'SP01',N'Noki','a11100',5,N'xanh',2000000,N'Chiếc',N'Sản phẩm phổ
thông'
SELECT * FROM SanPham



-- b. Viết thủ tục xóa dữ liệu bảng HangSX với tham biến là TenHang. 
-- Nếu TenHang chưa có thì thông báo, ngược lại xóa HangSX với hãng bị xóa là TenHang. (Lưu ý: xóa HangSX thì phải xóa các sản phẩm mà HangSX này cung ứng). 
CREATE PROCEDURE Bai1_b(@TenHang NVARCHAR(20))
AS
BEGIN
    -- Kiểm tra xem Hãng SX có tồn tại trong bảng HangSX hay không
    IF(NOT EXISTS (SELECT * FROM HangSX WHERE TenHang = @TenHang))
        PRINT(N'Hãng SX không tồn tại')
    ELSE
        BEGIN
            -- Lấy mã hãng SX từ bảng HangSX
            DECLARE @MaHangSX NVARCHAR(10)
            SELECT @MaHangSX = MaHangSX FROM HangSX WHERE TenHang = @TenHang

            DELETE FROM Nhap WHERE MaSP IN(
                SELECT DISTINCT MaSP FROM Nhap
            )
            DELETE FROM Xuat WHERE MaSP IN(
                SELECT DISTINCT MaSP FROM Xuat
            )
            -- Xóa các sản phẩm của Hãng SX này trong bảng SanPham
            DELETE FROM SanPham WHERE MaHangSX = @MaHangSX
    
            -- Xóa Hãng SX trong bảng HangSX
            DELETE FROM HangSX WHERE MaHangSX = @MaHangSX
    
            PRINT(N'Đã xóa hãng SX thành công')
        END
END

-- Truong hop dung:
EXEC Bai1_b N'OPPO'
-- Truong hop sai:
EXEC Bai1_b N'Apple'
SELECT * FROM SanPham



-- c. Viết thủ tục nhập dữ liệu cho bảng nhân viên với các tham biến manv, TenNV, GioiTinh, DiaChi, SoDT, Email, Phong, và 1 biến cờ Flag, 
--Nếu Flag = 0 thì cập nhật dữ liệu cho bảng nhân viên theo manv, ngược lại thêm mới nhân viên này.
create proc Bai1_c(@manv nchar(10), @tennv nvarchar(20), @gt nchar(10), @diachi nvarchar(30), @sdt nvarchar(20), @email nvarchar(30), @tenp nvarchar(30), @flag int)
AS
begin 
    IF(@flag = 0)
        UPDATE NhanVien
        SET TenNV = @tennv,
        GioiTinh = @gt,
        DiaChi = @diachi,
        SoDT = @sdt,
        Email = @email,
        TenPhong = @tenp
        WHERE MaNV = @manv
    ELSE    
        insert into NhanVien 
        VALUES(@manv, @tennv, @gt, @diachi, @sdt, @email, @tenp)
end
-- Cap nhat:
EXEC Bai1_c 'NV02', N'Nguyễn Thị Phương', N'Nữ', N'Hải Phòng', '0358123902', 'ltp@gmail.outlook.vn', N'Kinh Doanh', 0
select * from NhanVien
-- Them moi:
EXEC Bai1_c 'NV11', N'Đinh Xuân Thành', N'Nam', N'Hải Dương', '0358383702', 'xth@gmail.yahoo.vn', N'Phát Triển', 1
select * from NhanVien



-- d. Viết thủ tục nhập dữ liệu cho bảng Nhap với các tham biến SoHDN, MaSP, manv, NgayNhap, SoLuongN, DonGiaN. 
-- Kiểm tra xem MaSP có tồn tại trong bảng SanPham hay không? manv có tồn tại trong bảng NhanVien hay không? 
-- Nếu không thì thông báo, ngược lại thì hãy kiểm tra: Nếu SoHDN đã tồn tại thì cập nhật bảng Nhap theo SoHDN, ngược lại thêm mới bảng Nhap.
CREATE PROC Bai1_d(@sohdn nchar(10),
    @masp nchar(10),
    @manv nchar(10),
    @ngaynhap date,
    @slnhap int,
    @dongiaN money)
AS
BEGIN
    IF(NOT EXISTS(SELECT * FROM SanPham WHERE MaSP = @masp))
        PRINT(N'Mã sản phẩm không tồn tại')
    ELSE
        IF(NOT EXISTS(SELECT * FROM NhanVien WHERE MaNV = @manv))
            PRINT(N'Mã nhân viên chưa tồn tại')
        ELSE
            IF(EXISTS(SELECT * FROM Nhap WHERE SoHDN = @sohdn))
                BEGIN
                    UPDATE Nhap
                    SET MaSP = @masp,
                    SoLuongNhap = @slnhap,
                    DonGiaNhap = @dongiaN
                    WHERE SoHDN = @sohdn

                 UPDATE PNhap
                    SET NgayNhap = @ngaynhap,
                    MaNV = @manv
                    WHERE SoHDN = @sohdn
                END
            ELSE
                BEGIN
                    INSERT INTO Nhap
                    VALUES(@sohdn, @masp, @slnhap, @dongiaN)
                    INSERT INTO PNhap
                    VALUES(@sohdn, @ngaynhap, @manv)
                END
END
select * from Nhap
SELECT * FROM PNhap
-- Cap nhat:
EXEC Bai1_d 'N01', 'SP01', 'NV03', '2021-12-16', 40, 4500000
-- Them moi: 
EXEC Bai1_d 'N010', 'SP05', 'NV01', '2021-11-23', 40, 4000000
-- Sai: Khong ton tai MaSP hoac MaNV
EXEC Bai1_d 'N01', 'SP01', 'NV11', '2021-12-12', 40, 4000000
EXEC Bai1_d 'N01', 'SP03', 'NV01', '2021-12-12', 40, 4000000




-- Bai 2:
-- a. Viết thủ tục thêm mới sản phẩm với các tham biến MaSP, TenHang, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa và 1 biến Flag. 
-- Nếu Flag=0 thì thêm mới sản phẩm, ngược lại cập nhật sản phẩm. Hãy kiểm tra:
-- Nếu TenHang không có trong bảng HangSX thì trả về mã lỗi 1
-- Nếu SoLuong <0 thì trả về mã lỗi 2
-- Ngược lại trả về mã lỗi 0.
CREATE PROC Cau2_a(@masp nchar(10), @tenhang nvarchar(20), @tensp nvarchar(20), @soluong int, @mausac nvarchar(20), @giaban money, @donvitinh nchar(10), @mota ntext, @flag int, @kq int output)
AS
BEGIN
    if(not exists(select * from HangSX where TenHang = @tenhang))
        SET @kq = 1
    ELSE IF(@soluong < 0)
        SET @kq = 2
    ELSE 
    BEGIN
        SET @kq = 0
        DECLARE @mahangsx NVARCHAR(10)
        SET @mahangsx = (select MaHangSX from HangSX where TenHang = @tenhang)
        IF(@flag = 0)
            INSERT INTO SanPham VALUES(@masp, @mahangsx, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
        ELSE
            UPDATE SanPham 
            SET MaHangSX = @mahangsx,
            TenSP = @tensp,
            SoLuong = @soluong,
            MauSac = @mausac,
            GiaBan = @giaban,
            DonViTinh = @donvitinh, 
            MoTa = @mota
            WHERE MaSP = @masp
    END
END
DECLARE @bien int 
-- Them moi 
EXEC Cau2_a 'SP07', N'Samsung', N'Galaxy A10', 25, N'Xanh', 6000000, N'Chiếc', N'Hàng cận cao cấp', 0, @bien output
-- Cap nhat
EXEC Cau2_a 'SP02', N'Samsung', N'Galaxy A10', 25, N'Xanh', 6000000, N'Chiếc', N'Hàng cận cao cấp', 1, @bien output
-- Ten hang khong co
EXEC Cau2_a 'SP07', N'Rogphone', N'Galaxy A10', 25, N'Xanh', 6000000, N'Chiếc', N'Hàng cận cao cấp', 0, @bien output
-- So luong<0
EXEC Cau2_a 'SP07', N'Rogphone', N'Galaxy A10', -10, N'Xanh', 6000000, N'Chiếc', N'Hàng cận cao cấp', 0, @bien output
SELECT  * FROM SanPham
SELECT @bien



-- b. Viết thủ tục xóa dữ liệu bảng NhanVien với tham biến là manv. 
-- Nếu manv chưa có thì trả về 1, ngược lại xóa NhanVien với NhanVien bị xóa là manv và trả về 0. 
-- (Lưu ý: xóa NhanVien thì phải xóa các bảng Nhap, Xuat mà nhân viên này tham gia).
create proc Cau2_b(@manv nchar(10), @kq int output)
as
BEGIN
    if(not exists(SELECT * from NhanVien where MaNV = @manv))
        set @kq = 1
    ELSE
    BEGIN
        DELETE FROM PNhap WHERE MaNV = @manv
        DELETE FROM PXuat WHERE MaNV = @manv
        DELETE FROM Nhap WHERE SoHDN IN(SELECT SoHDN FROM PNhap WHERE MaNV = @manv)
        DELETE FROM Xuat WHERE SoHDX IN(SELECT SoHDX FROM PXuat WHERE MaNV = @manv)
        DELETE FROM NhanVien WHERE MaNV = @manv
        set @kq = 0
    END
END
DECLARE @bien1 INT
EXEC Cau2_b 'NV02', @bien1 output
EXEC Cau2_b 'NV05', @bien1 output
SELECT @bien1
SELECT * FROM NhanVien



-- c. Viết thủ tục xóa dữ liệu bảng SanPham với tham biến là MaSP. 
-- Nếu MaSP chưa có thì trả về 1, ngược lại xóa SanPham với SanPham bị xóa là MaSP và trả về 0. 
-- (Lưu ý: xóa SanPham thì phải xóa các bảng Nhap, Xuat mà SanPham này cung ứng)
create proc Bai2_c(@masp nchar(10), @kq int output)
AS
BEGIN
    if(not exists(select * from SanPham where MaSP = @masp))
        set @kq = 1
    ELSE
    BEGIN
        DELETE FROM Nhap WHERE MaSP = @masp
        DELETE FROM Xuat WHERE MaSP = @masp
        DELETE FROM SanPham WHERE MaSP = @masp
        set @kq = 0
    END
END
DECLARE @bien2 INT
EXEC Bai2_c 'SP55', @bien2 output
EXEC Bai2_c 'SP01', @bien2 output
SELECT @bien2
SELECT * FROM SanPham
SELECT * FROM Nhap
SELECT * FROM Xuat
