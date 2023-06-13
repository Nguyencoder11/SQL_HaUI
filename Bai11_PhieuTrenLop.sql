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


/* a (1đ). Tạo Trigger cho việc cập nhật lại số lượng xuất trong bảng xuất, hãy kiểm tra xem 
số lượng xuất thay đổi có nhỏ hơn SoLuong trong bảng SanPham hay ko? số bản ghi thay 
đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép Update bảng xuất và Update lại 
SoLuong trong bảng SanPham.
*/
create trigger trg_capnhatXuat
on Xuat
for update
as
begin
	if(@@ROWCOUNT > 1)
		begin 
			raiserror(N'Không cập nhật nhiều hơn 1 bản ghi cùng lúc',16,1)
			rollback transaction
		end
	else
		begin 
			declare @truoc int, @sau int, @slco int
			declare @masp nchar(10)
			select @truoc = SoLuongXuat, @masp = MaSP from deleted
			select @sau = SoLuongXuat from inserted
			select @slco = SoLuong from SanPham where MaSP = @masp
			if(@truoc<>@sau)
				begin
					if(@slco < (@sau-@truoc))
						begin
							raiserror(N'Không đủ hàng xuất',16,1)
							rollback transaction
						end
					else
						update SanPham set SoLuong = SoLuong - (@sau-@truoc)
						from SanPham
						where MaSP = @masp
				end
		end
end
-- Thuc thi:
select * from SanPham
select * from Xuat
-- Cap nhat sai
update Xuat set SoLuongXuat = SoLuongXuat + 5 where MaSP = 'SP03'

-- Cap nhat dung
update Xuat set SoLuongXuat = SoLuongXuat + 5 where MaSP = 'SP01'


/* b (1đ). Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng nhập, hãy kiểm tra các ràng buộc 
toàn vẹn: MaSP có trong bảng sản phẩm chưa? Kiểm tra các ràng buộc dữ liệu: SoLuongN
và DonGiaN>0? Sau khi nhập thì SoLuong ở bảng SanPham sẽ được cập nhật theo.
*/
create trigger trg_Nhap
on Nhap
for insert
as
begin 
	declare @masp nchar(10), @manv nchar(10)
	declare @sln int, @dgn money
	select @masp = MaSP, @sln=SoLuongNhap, @dgn=DonGiaNhap from inserted
	if(not exists(select * from SanPham where MaSP = @masp))
		begin
			raiserror(N'Không tồn tại sản phẩm trong danh mục sản phẩm',16,1)
			rollback transaction
		end
	else
		if(@sln<=0 or @dgn<=0)
			begin
				raiserror(N'Nhập sai số lượng hoặc đơn giá',16,1)
				rollback transaction
			end
		else
			update SanPham set SoLuong = SoLuong+@sln
			from SanPham where MaSP = @masp
end
-- Thuc thi
Select * From SanPham
Select * From NhanVien
Select * From Nhap
-- Nhap sai
insert into Nhap values('N04', 'SP05', 0, 350000)
-- Nhap dung
insert into Nhap values('N04', 'SP05', 30, 350000)
select * from PNhap
Select * From Nhap
Select * From SanPham


/* c (2đ). Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc 
toàn vẹn: MaSP có trong bảng sản phẩm chưa? kiểm tra các ràng buộc dữ liệu: SoLuongX
< SoLuong trong bảng SanPham? Sau khi xuất thì SoLuong ở bảng SanPham sẽ được cập 
nhật theo.
*/
create trigger trg_nhapXuat
on Xuat
for insert
as
begin
	declare @masp nchar(10)
	declare @slx int, @soluong int
	select @masp = MaSP, @slx=SoLuongXuat from inserted
	if(not exists(select * from SanPham where MaSP=@masp))
		begin
			raiserror(N'Không tồn tại sản phẩm trong danh mục sản phẩm',16,1)
			rollback transaction
		end
	else
		begin
			select @soluong = SoLuong from SanPham where MaSP = @masp
			if(@slx > @soluong)
				begin
					raiserror(N'Không đủ số lượng sản phẩm để xuất',16,1)
					rollback transaction
				end
			else
				update SanPham set SoLuong=SoLuong-@slx
				from SanPham where MaSP=@masp
		end
end
-- Thuc thi:
Select * From SanPham
Select * From NhanVien
Select * From Xuat
-- Sai so luong
insert into Xuat values('X01', 'SP01', 1000)
-- Dung
insert into Xuat values('X01', 'SP01', 10)
Select * From SanPham
Select * From Xuat


/* d (2đ). Tạo Trigger kiểm soát việc xóa phiếu xuất, khi phiếu xuất xóa thì số lượng hàng 
trong bảng SanPham sẽ được cập nhật tăng lên.
*/
create trigger trg_xoaXuat
on Xuat
for delete
as
begin
	declare @masp nchar(10)
	declare @slx int
	select @masp=MaSP, @slx=SoLuongXuat from deleted
	if(not exists(select * from SanPham where MaSP=@masp))
		begin
			raiserror(N'Không tồn tại sản phẩm trong danh mục sản phẩm',16,1)
			rollback transaction
		end
	else
		update SanPham set SoLuong = SoLuong + @slx
		from SanPham where MaSP=@masp
end
-- Thuc thi:
select * from SanPham
select * from Xuat
-- Sai
delete from Xuat where MaSP = 'SP06'
-- Dung
delete from Xuat where MaSP = 'SP02'
select * from SanPham
select * from Xuat


/* e (2đ). Tạo Trigger cho việc cập nhật lại số lượng Nhập trong bảng Nhập, Hãy kiểm tra 
xem số bản ghi thay đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép Update bảng 
Nhập và Update lại SoLuong trong bảng SanPham.
*/
create trigger trg_capnhatSoluong
on Nhap
for update
as
begin 
	if(@@ROWCOUNT > 1)
	begin
		update Nhap
		set SoLuongNhap = inserted.SoLuongNhap
		from Nhap inner join inserted
		on Nhap.MaSP = inserted.MaSP 

		update SanPham
		set SoLuong = SoLuong + inserted.SoLuongNhap
		from SanPham inner join inserted
		on SanPham.MaSP=inserted.MaSP
	end
end
-- Thuc thi:
select * from SanPham
select * from Nhap
update Nhap set SoLuongNhap = 5 where MaSP = 'SP01'
select * from Nhap
select * from SanPham


/* f (2đ). Tạo Trigger kiểm soát việc xóa phiếu nhập, khi phiếu nhập xóa thì số lượng hàng 
trong bảng SanPham sẽ được cập nhật giảm xuống
*/
CREATE TRIGGER trg_xoaPNhap
ON PNhap
FOR DELETE
AS
BEGIN	
	DELETE FROM Nhap
	WHERE SoHDN IN (SELECT SoHDN FROM deleted)

	UPDATE SanPham
	SET SoLuong = SoLuong - (SELECT SUM(SoLuongNhap) FROM deleted INNER JOIN Nhap ON Nhap.SoHDN = deleted.SoHDN WHERE Nhap.MaSP = SanPham.MaSP)
	WHERE MaSP IN (SELECT MaSP FROM deleted)
END

-- Thuc thi:
select * from SanPham
select * from PNhap
select * from Nhap
delete from PNhap where SoHDN = 'N05'
select * from SanPham
select * from PNhap
select * from Nhap