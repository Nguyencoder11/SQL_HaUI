create database QLBH
on primary(
	name='qlbh_dat',
	filename='F:\MyDataBase\qlbh.mdf',
	size=2MB,
	maxsize=8MB,
	filegrowth=20%
)

log on(
	name='qlbh_log',
	filename='F:\MyDataBase\qlbh.ldf',
	size=1MB,
	maxsize=5MB,
	filegrowth=2%
)
use QLBH
create table MatHang(
	mahang int primary key,
	tenhang nvarchar(15),
	soluong int
)
create table NhatKyHang(
	stt int primary key,
	ngay date,
	nguoimua nchar(10),
	mahang int,
	constraint fk_nkh_mh foreign key(mahang)
		references MatHang(mahang),
	soluong int,
	giaban money
)


insert into MatHang
values(1, 'Keo', 100),
(2, 'Banh', 200),
(3, 'Thuoc', 100)

insert into NhatKyHang
values(1, '1999-02-09', 'ab', 2, 230, 50)
insert into NhatKyHang
values(3, '2020-10-05', 'xy', 1, 20, 40)
insert into NhatKyHang
values(5, '2021-08-21', 'Nam', 3, 10, 70)

select * from MatHang
select * from NhatKyHang

/* a. trg_nhatkybanhang_insert. Trigger này có chức năng tự động giảm số lượng 
hàng hiện có (Trong bảng MATHANG) khi một mặt hàng nào đó được bán (tức 
là khi câu lệnh INSERT được thực thi trên bảng NHATKYBANHANG). 
*/
create trigger trg_nhatkybanhang_insert 
on NhatKyHang
for insert
as
begin
	update MatHang
	set MatHang.soluong = MatHang.soluong - inserted.soluong
	from MatHang inner join inserted
	on MatHang.mahang = inserted.mahang
end
-- Test
select * from MatHang
select * from NhatKyHang
insert into NhatKyHang(stt, ngay, nguoimua, mahang, soluong, giaban) 
values(2,'1999-02-09', 'ab', 2, 30, 50)
select * from MatHang
select * from NhatKyHang


/* b. trg_nhatkybanhang_update_soluong được kích hoạt khi ta tiến hành cập nhật 
cột SOLUONG cho một bản ghi của bảng NHATKYBANHANG (lưu ý là chỉ cập nhật đúng một bản ghi).
*/
create trigger trg_nhatkybanhang_update_soluong
on NhatKyHang
for update
as
begin
	declare @sltruoc int
	declare @slsau int
	select @sltruoc = soluong from deleted
	select @slsau = soluong from inserted
	if(@slsau <> @sltruoc)
		begin
			update MatHang
			set MatHang.soluong = MatHang.soluong - (@slsau - @sltruoc)
			from inserted, deleted
			where deleted.mahang=MatHang.mahang
			and inserted.stt = deleted.stt
		end
end
-- Test
select * from MatHang
select * from NhatKyHang
update NhatKyHang set soluong = soluong + 20 where stt = 1
select * from MatHang
select * from NhatKyHang


/* c. Trigger dưới đây được kích hoạt khi câu lệnh INSERT được sử dụng để bổ sung 
một bản ghi mới cho bảng NHATKYBANHANG. Trong trigger này kiểm tra
điều kiện hợp lệ của dữ liệu là số lượng hàng bán ra phải nhỏ hơn hoặc bằng số
lượng hàng hiện có. Nếu điều kiện này không thoả mãn thì huỷ bỏ thao tác bổ
sung dữ liệu.
*/
create trigger trg_nhatkybanhang_kiemtra
on NhatKyHang
for insert
as
begin
	declare @sl_co int -- So luong hien co
	declare @sl_ban int -- so luong hang ban
	declare @mahang int -- ma hang duoc ban
	select @mahang = mahang,@sl_ban = soluong from inserted
	select @sl_co = soluong from MatHang where mahang = @mahang
	-- Neu so luong co nho hon sl ban thi huy bo thao tac them dl
	if @sl_co < @sl_ban
		rollback transaction
	-- Neu du lieu hop le thi giam so luong hien co
	else 
		update MatHang
		set soluong = soluong - @sl_ban
		where mahang = @mahang
end
-- Test
select * from MatHang
select * from NhatKyHang
insert into NhatKyHang values(4,'1999-12-19', 'zzz', 1, 10, 20)
select * from MatHang
select * from NhatKyHang


/* d. Trigger dưới đây nhằm để kiểm soát lỗi update bảng nhatkybanhang, nếu update 
>1 bản ghi thì thông báo lỗi(Trigger chỉ làm trên 1 bản ghi), quay trở về. Ngược 
lại thì update lại số lượng cho bảng mathang.
*/
create trigger trg_nhatkybanhang_ktra_update
on NhatKyHang
for update
as
begin
	declare @mahang int
	declare @truoc int
	declare @sau int 
	-- Neu update tren 1 ban ghi thi thong bao loi
	if(select count(*) from inserted) > 1
		begin
			raiserror('Khong duoc sua qua 1 dong lenh',16,1)
			rollback transaction
			return
		end
	else
		begin
			select @truoc = soluong from deleted
			select @sau = soluong from inserted
			select @mahang = mahang from inserted
			update MatHang
			set soluong = soluong - (@sau - @truoc)
			where mahang = @mahang
		end	
end
-- Test 
select * from MatHang
select * from NhatKyHang
update NhatKyHang set soluong = soluong - 5 where mahang = 1 
select * from MatHang
select * from NhatKyHang


/* e. Hãy tao Trigger xoa 1 ban ghi bang nhatkybanhang, neu xoa nhieu hon 1 record 
thi hay thong bao loi xoa ban ghi, nguoc lai hay update bang mathang voi cot so 
luong tang len voi ma hang da xoa o bang nhatkybanhang.
*/
create trigger trg_xoabanghi
on NhatKyHang
for delete
as
begin
	declare @mahang int
	-- neu xoa nhieu hon 1 ban ghi thi thong bao loi
	if(select count(*) from deleted) > 1
		begin
			raiserror('Khong the xoa nhieu hon 1 ban ghi', 16, 1)
			rollback transaction
			return
		end
	else
		begin
			-- Lay ma hang cua ban ghi da xoa
			select @mahang = mahang from deleted

			-- Cap nhat bang MatHang voi so luong tang len
			update MatHang set soluong = soluong + 1
			where mahang = @mahang

			-- Xoa ban ghi trong bang NhatKyHang
			delete from NhatKyHang
			where mahang = @mahang
		end
end
select * from MatHang
select * from NhatKyHang
delete from NhatKyHang where mahang = 2
select * from MatHang
select * from NhatKyHang



/* f. Tạo Trigger cập nhật bảng nhật ký bán hàng, nếu cập nhật nhiều hơn 1 bản ghi 
thông báo lỗi và phục hồi phiên giao dịch, ngược lại kiểm tra xem nếu giá trị số
lượng cập nhật <giá trị số lượng có thì thông báo lỗi sai cập nhật, ngược lại nếu nếu 
giá trị số lượng cập nhật =giá trị số lượng có thì thông báo không cần cập nhật ngược 
lại thì hãy cập nhật giá trị.
*/
create trigger trg_capnhat_nkbh
on NhatKyHang
for update
as
begin
	-- Khai bao so luong cap nhat
	declare @slcn int
	-- Khai bao so luong co
	declare @slco int
	
	-- Neu so luong ban cap nhat > 1 => thong bao loi
	if(select count(*) from inserted) > 1
		begin
			raiserror('Khong the cap nhat qua 1 ban ghi', 16, 1)
			rollback transaction
			return
		end
	else
		select @slcn = soluong from inserted
		select @slco = soluong from MatHang
		-- Kiem tra neu slcn < slco -> thong bao loi
		if @slcn < @slco
		begin
			raiserror('Loi cap nhat', 16, 1)
			rollback transaction
			return
		end
		else if @slcn = @slco
		begin
			raiserror('Khong can cap nhat',16,1)
			rollback transaction
			return
		end
		else
		begin
			update NhatKyHang
			set soluong = @slcn
			from NhatKyHang 
			inner join inserted on NhatKyHang.mahang = inserted.mahang
		end
end
-- Test
select * from MatHang
select * from NhatKyHang
update NhatKyHang set soluong = 30 where mahang = 2
select * from MatHang
select * from NhatKyHang


/* g. Viết thủ tục xóa 1 bản ghi trên bảng mathang, voi mahang được nhập từ bàn phím. 
Kiểm tra xem mahang co tồn tại hay không, nếu không đưa ra thông báo, ngược lại 
hãy xóa, có tác động đến 2 bảng.
*/
create procedure sp_xoamathang(@mahang int)
as
begin
	if(not exists(select * from MatHang where mahang = @mahang))
		print(N'Mã hàng không tồn tại')
	else
		delete from NhatKyHang where mahang = @mahang
		delete from MatHang where mahang = @mahang
end
exec sp_xoamathang 3
select * from MatHang
select * from NhatKyHang


-- h. Viết 1 hàm tính tổng tiền của 1 mặt hàng có tên hàng được nhập từ bàn phím.
create function fn_tongtien(@tenhang nvarchar(15))
returns money
as
begin
	declare @tongtien money
	set @tongtien = (
		select sum(NhatKyHang.soluong * giaban)
		from NhatKyHang inner join MatHang
		on NhatKyHang.mahang = MatHang.mahang
		where tenhang = @tenhang
		group by MatHang.mahang, tenhang
	)
	return @tongtien
end
select dbo.fn_tongtien('Banh')