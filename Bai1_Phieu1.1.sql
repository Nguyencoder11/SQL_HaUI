use master
go
create database QLSinhVien
on primary(
	name='QLSinhVien_dat',
	filename='F:\MyDataBase\QLSinhVien.mdf',
	size=10MB,
	maxsize=50MB,
	filegrowth=10MB
)

log on(
	name = 'QLSinhVien_log',
	filename = 'F:\MyDataBase\QLSinhVien.ldf',
	size=1MB,
	maxsize=5MB,
	filegrowth=20%
)
go 
use QLSinhVien
create table SV (
	MaSV nchar(10) not null primary key,
	TenSV nvarchar(20) not null,
	Que nvarchar(30)
)

create table MON (
	MaMH nchar(10) not null primary key,
	TenMH nvarchar(20),
	SoTc int,
)

create table KQ (
	MaSV nchar(10) not null,
	MaMH nchar(10) not null,
	Diem float(2),
	constraint pk_kq primary key(MaSV, MaMH),
	constraint fk_kq_sv foreign key(MaSV)
		references SV(MaSV),
	constraint fk_kq_mon foreign key(MaMH)
		references MON(MaMH)
)

--Them rang buoc cho bang MON
-- rang buoc so tin chi
alter table MON
add constraint ck_sotc check(SoTc>=2 and SoTc<=5 or SoTc=3);

-- rang buoc TenMH duy nhat
alter table MON
add constraint uniq_tenmh unique(TenMH);


--Them rang buoc diem cho bang KQ
alter table KQ
add constraint ck_diem check(Diem>=0 and Diem<=10);


insert into SV
values ('DH001', 'Nguyen Van An', 'Ha Noi'),
       ('DH002', 'Tran Viet Hoan', 'Nghe An'),
	   ('DH003', 'Le Thi Linh', 'Thanh Hoa')

insert into MON
values ('MH101', 'SQL', '3'),
       ('MH102', 'Java', '2'),
	   ('MH103', 'OOP','3')

insert into KQ
values ('DH001', 'MH101', '9.00'),
       ('DH002', 'MH102', '6.00'),
	   ('DH003', 'MH103', '6.50'),
	   ('DH001', 'MH102', '7.00'),
       ('DH002', 'MH103', '9.00'),
	   ('DH003', 'MH101', '7.00'),
	   ('DH001', 'MH103', '5.00'),
       ('DH002', 'MH101', '8.50'),
	   ('DH003', 'MH102', '6.00')

select * from SV
select * from MON
select * from KQ


