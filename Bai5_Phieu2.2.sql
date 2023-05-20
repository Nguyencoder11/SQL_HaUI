use master
create database QLSV
on primary(
	name='qlsv_dat',
	filename='F:\MyDataBase\qlSV.mdf',
	size=5MB,
	maxsize=30MB,
	filegrowth=5MB
)
log on(
	name='qlsv_log',
	filename='F:\MyDataBase\qlSV.ldf',
	size=2MB,
	maxsize=20MB,
	filegrowth=2%
)

use QLSV

create table Lop(
	MaLop int not null primary key,
	TenLop nchar(10),
	Phong int
)

create table SV(
	MaSV int not null primary key,
	TenSV nchar(10),
	MaLop int not null,
	constraint fk_sv_lop foreign key(MaLop)
		references Lop(MaLop),
)

insert into Lop
values(1, 'CD', 1),
(2, 'DH', 2),
(3, 'LT', 2),
(4, 'CH', 4)

insert into SV
values(1, 'A', 1),
(2, 'B', 2),
(3, 'C', 1),
(4, 'D', 3)

/* Viet ham thong ke moi lop co bao nhieu sinh vien voi malop la tham so nhap tu ban phim thong ke tra ve bang */
create function fn_tk1(@ml int)
returns @bang1 table(
	MaLop int,
	TenLop nchar(10),
	SoLuongSV int
)
as  
begin
	insert into @bang1
		select Lop.MaLop, TenLop, count(*)
		from Lop inner join SV on Lop.MaLop=SV.MaLop
		group by Lop.MaLop, TenLop
	return
end
select * from fn_tk1(1)


-- thong ke tra ve gia tri
create function thongke1(@malop int)
returns int
as
begin 
	declare @sl int
	select @sl=count(SV.MaSV)
	from SV,Lop
	where SV.MaLop = Lop.MaLop and lop.malop = @malop
	group by Lop.TenLop
	return @sl
end
select dbo.thongke1(1) as 'So SV'


/* dua ra danh sach sinh vien(masv, tensv) hoc lop voi tenlop nhap tu ban phim */
create function dssv(@tenlop nchar(10))
returns @list table(
	Masv int,
	Tensv nchar(10),
	Lophoc nchar(10)
)
as 
begin
	insert into @list
	select MaSV, TenSV, TenLop
	from SV inner join Lop on Lop.MaLop=SV.MaLop
	where TenLop=@tenlop
	return
end
select * from dssv('CD')



/* Dua ra ham thong ke sinh vien: malop, tenlop, soluong sinh vien lop, voi ten lop nhap tu ban phim
 neu lop khong ton tai thi thong ke tat ca cac lop, nguoc lai neu lop da ton tai thi chi thong ke moi lop do  */
create function tksv(@tenlop nchar(10))
returns @thongkeSV table(
	malop int,
	tenlop nchar(10),
	soluong int
)
as
begin
	if(not exists(select MaLop from Lop where TenLop=@tenlop))
		insert into @thongkeSV
		select Lop.MaLop, Lop.TenLop, count(SV.MaSV)
		from Lop inner join SV on Lop.MaLop=SV.MaLop
		group by Lop.MaLop, Lop.TenLop
	else
		insert into @thongkeSV
		select Lop.MaLop, Lop.TenLop, count(SV.MaSV)
		from Lop inner join SV on Lop.MaLop=SV.MaLop
		where Lop.TenLop=@tenlop
		group by Lop.MaLop, Lop.TenLop
	return
end
select * from tksv('CD')



/* Dua ra phong hoc cua sinh vien co ten nhap tu ban phim  */
create function phong(@tensv nchar(10))
returns int 
as 
begin 
	declare @ph int
	return (
		select Phong
		from Lop inner join SV on Lop.MaLop=SV.MaLop
		where TenSV=@tensv
	) 
end
select dbo.phong('D') as 'Phong hoc'



/* Thong ke masv, tensv, tenlop voi tham bien nhap tu ban phim la phong. 
 Neu khong ton tai phong thi dua ra tat ca cac sinh vien va cac phong. Neu phong ton tai thi dua ra cac sinh vien cua cac lop hoc phong do */
 create function tksv2(@phong int)
 returns @table2 table(
	masv int,
	tensv nchar(10),
	tenlop nchar(10),
	phong int
 )
 as 
 begin
	if(not exists(select Phong from Lop where Phong=@phong))
		insert into @table2
		select MaSV, TenSV, TenLop, Phong
		from SV inner join Lop on SV.MaLop=Lop.MaLop
	else
		insert into @table2
		select MaSV, TenSV, TenLop, Phong
		from SV inner join Lop on SV.MaLop=Lop.MaLop
		where Phong=@phong
	return 
 end
 select * from tksv2(2)



/* Viet ham thong ke xem moi phong co bao nhieu lop hoc. neu phong khong ton tai tra ve 0  */
create function thongkelop(@phong int)
returns int
as
begin
	declare @dem int
	select @dem=COUNT(*) from Lop where Phong=@phong
	if @dem is null 
	set @dem=0
	return @dem
end
select dbo.thongkelop('4') as 'So lop'




