create database QLHD
on primary(
	name='qldh_dat',
	filename='F:\MyDataBase\qldh.mdf',
	size=2MB,
	maxsize=8MB,
	filegrowth=20%
)

log on(
	name='qldh_log',
	filename='F:\MyDataBase\qldh.ldf',
	size=1MB,
	maxsize=5MB,
	filegrowth=2%
)

use QLHD
create table Hang(
	mahang char(10) not null primary key,
	tenhang nvarchar(20),
	soluong int, 
	giaban money
)

create table Hoadon(
	mahd char(10) not null primary key,
	mahang char(10) not null,
	constraint fk_hd_h foreign key(mahang)
		references Hang(mahang),
	soluongban int,
	ngayban date
)

/* -- 
Hãy tạo 1 trigger insert HoaDon, hãy kiểm tra xem mahang cần mua có tồn 
tại trong bảng HANG không, nếu không hãy đưa ra thông báo.
 - Nếu thỏa mãn hãy kiểm tra xem: soluongban <= soluong? Nếu không hãy đưa 
ra thông báo.
 - Ngược lại cập nhật lại bảng HANG với: soluong = soluong - soluongban
 -- */
create trigger trg_insert_hoadon
on Hoadon
for insert
as
begin
	if(not exists(select * from Hang inner join inserted
		on Hang.mahang = inserted.mahang))
		begin 
			raiserror('Loi khong co hang', 16, 1)
			rollback transaction
		end
	else
		begin
			declare @soluong int
			declare @soluongban int
			select @soluong = soluong from Hang inner join inserted on Hang.mahang=inserted.mahang
			select @soluongban = inserted.soluongban
			from inserted
			if(@soluong < @soluongban)
				begin
					raiserror('Ban khong du hang', 16, 1)
					rollback transaction
				end
			else
				update Hang set soluong=soluong-@soluongban
				from Hang inner join inserted
				on Hang.mahang=inserted.mahang
		end
end
-- Goi trigger
select * from Hang
select * from Hoadon
insert into Hoadon values('PH04', 'H03', 150, '2020/12/15')
