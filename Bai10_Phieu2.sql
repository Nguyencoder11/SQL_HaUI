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
Câu 1 (5đ). Viết trigger kiểm soát việc Delete bảng HOADON, Hãy cập nhật lại 
soluong trong bảng HANG với: SOLUONG =SOLUONG + DELETED.SOLUONGBAN
 -- */
create trigger trg_xoaHoadon 
on Hoadon
for delete
as
begin
	update Hang set soluong = soluong + deleted.soluongban 
	from Hang inner join deleted 
	on Hang.mahang=deleted.mahang
	where Hang.mahang = deleted.mahang
end
-- Goi trigger
select * from Hang
select * from Hoadon
delete from Hoadon where mahd = 'PH04'
select * from Hang
select * from Hoadon



 /* --
Câu 2 (5đ). Hãy viết trigger kiểm soát việc Update bảng HOADON. Khi đó hãy
update lại soluong trong bảng HANG.
 -- */
create trigger trg_capnhathoadon
on Hoadon
for update
as
begin
	declare @truoc int
	declare @sau int

	select @truoc = deleted.soluongban from deleted
	select @sau = inserted.soluongban from inserted
	update Hang set soluong = soluong -(@sau - @truoc)
	from Hang inner join inserted on Hang.mahang = inserted.mahang
end
-- Goi trigger
select * from Hang
select * from Hoadon
update Hoadon set soluongban = soluongban - 5 where mahang = 'H02'
select * from Hang
select * from Hoadon