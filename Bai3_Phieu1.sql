use master
go
create database ThucTap
on primary(
	name='thuctap_dat',
	filename='F:\MyDataBase\ThucTap.mdf',
	size=10MB,
	maxsize=50MB,
	filegrowth=10%
)
log on(
	name='thuctap_log',
	filename='F:\MyDataBase\ThucTap.ldf',
	size=5MB,
	maxsize=15MB,
	filegrowth=2%
)
go
use ThucTap
create table Khoa(
	makhoa char(10) not null primary key,
	tenkhoa char(30),
	dienthoai char(10)
)

create table DeTai(
	madt char(10) not null primary key,
	tendt char(30),
	kinhphi int,
	NoiThucTap char(30)
)

create table GiangVien(
	magv int not null primary key,
	hotengv char(30),
	luong decimal(5,2),
	makhoa char(10) not null,
	constraint fk_gv_khoa foreign key(makhoa)
		references Khoa(makhoa)
)

create table SinhVien(
	masv int not null primary key,
	hotensv char(30),
	makhoa char(10) not null,
	constraint fk_sv_khoa foreign key(makhoa)
		references Khoa(makhoa),
	namsinh int, 
	quequan char(30)
)

create table HuongDan(
	masv int not null,
	constraint pk_hd primary key(masv, madt),
	constraint fk_hd_sv foreign key(masv)
		references SinhVien(masv),
	madt char(10) not null,
	constraint fk_hd_dt foreign key(madt)
		references DeTai(madt),
	magv int not null,
	constraint fk_hd_gv foreign key(magv)
		references GiangVien(magv),
	ketqua decimal(5,2)
)
go
-- insert du lieu cho bang Khoa
insert into Khoa
values('CNTT', N'Khoa CNTT', '0316728923'),
	  ('QTKD', N'Khoa QTKD', '0316826125')

-- insert du lieu cho bang DeTai
insert into DeTai
values('DT01', 'De tai 1', 1000000, 'Ha Noi'),
	  ('DT02', 'De tai 2', 2000000, 'Tp.Ho Chi Minh'),
	  ('DT03', 'De tai 3', 1500000, 'Ha Noi'),
	  ('DT04', 'De tai 4', 3000000, 'Da Nang'),
	  ('DT05', 'De tai 5', 2500000, 'Ha Noi')
insert into DeTai -- insert bo sung
values('DT06', 'De tai 6', 2000000, 'Ha Noi')

-- insert du lieu cho bang GiangVien
insert into GiangVien
values(102001, 'Nguyen Van T', 500, 'CNTT'),
	  (102002, 'Do Van H', 600, 'CNTT'),
	  (102003, 'Dao Thu H', 700, 'QTKD'),
	  (102004, 'Trinh Thi P', 600, 'QTKD')

-- insert du lieu cho bang SinhVien
insert into SinhVien
values(2021001, 'Tran Van A', 'CNTT', 2003, 'Ha Noi'),
	  (2021002, 'Le Van B', 'QTKD', 2002, 'Ha Noi'),
	  (2021003, 'Le Thi C', 'CNTT', 2002, 'Hai Duong'),
	  (2021004, 'Nguyen Thi E', 'QTKD', 2004, 'Thai Nguyen')
insert into SinhVien  
values(2021006, 'Nguyen Thi P', 'QTKD', 2004, 'Thai Binh')

-- insert du lieu cho bang HuongDan
insert into HuongDan
values(2021001, 'DT01', 102001, 9.0),
	  (2021001, 'DT03', 102002, 8.5),
	  (2021002, 'DT02', 102004, 9.0),
	  (2021003, 'DT05', 102002, 8.5),
	  (2021004, 'DT04', 102003, 9.5),
	  (2021004, 'DT05', 102004, 8.0)
insert into HuongDan
values(2021006, 'DT05', 102004, 7.5)

-- Chuyen sang buoc truy van 
go
-- Cac yeu cau cua phieu bai tap 1
/*
1. Đưa ra thông tin gồm mã số, họ tên và tên khoa của tất cả các giảng viên
2. Đưa ra thông tin gồm mã số, họ tên và tên khoa của các giảng viên của khoa ‘DIA LY va QLTN’
3. Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’
4. Đưa ra danh sách gồm mã số, họ tênvà tuổi của các sinh viên khoa ‘TOAN’
5. Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC’
6. Cho biết thông tin về sinh viên không tham gia thực tập
7. Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
8. Cho biết số điện thoại của khoa mà sinh viên có tên ‘Le van son’ đang theo học
*/

-- Đưa ra thông tin gồm mã số, họ tên và tên khoa của tất cả các giảng viên
select magv, hotengv, tenkhoa
from GiangVien 
inner join Khoa on GiangVien.makhoa=Khoa.makhoa


-- Đưa ra thông tin gồm mã số, họ tên và tên khoa của các giảng viên của khoa ‘DIA LY va QLTN’
select gv.magv, gv.hotengv, k.tenkhoa
from GiangVien gv
inner join Khoa k on gv.makhoa=k.makhoa
where k.tenkhoa in ('DIA LY', 'QTTN')


-- Cho biết số sinh viên của khoa ‘CONG NGHE SINH HOC’
select count(SinhVien.masv) as soSinhVien
from SinhVien 
inner join Khoa on SinhVien.makhoa=Khoa.makhoa
where Khoa.tenkhoa = 'CONG NGHE SINH HOC'


-- Đưa ra danh sách gồm mã số, họ tên và tuổi của các sinh viên khoa ‘TOAN’
select masv, hotensv, YEAR(GETDATE())-namsinh as tuoi 
-- hoac dung YEAR(Current_timestamp) or Year(systemdatetime)
from SinhVien 
inner join Khoa on SinhVien.makhoa = Khoa.makhoa
where Khoa.tenkhoa='TOAN'


-- Cho biết số giảng viên của khoa ‘CONG NGHE SINH HOC’
select count(GiangVien.magv) as soGiangVien
from GiangVien 
inner join Khoa on GiangVien.makhoa=Khoa.makhoa
where Khoa.tenkhoa = 'CONG NGHE SINH HOC'


-- Cho biết thông tin về sinh viên không tham gia thực tập
select * 
from SinhVien
where masv not in(
	select masv 
	from HuongDan
)


-- Đưa ra mã khoa, tên khoa và số giảng viên của mỗi khoa
select Khoa.makhoa, Khoa.tenkhoa, count(GiangVien.magv) as SoGiangVien
from Khoa inner join GiangVien on Khoa.makhoa=GiangVien.makhoa
group by Khoa.makhoa, Khoa.tenkhoa


-- Cho biết số điện thoại của khoa mà sinh viên có tên ‘Le van son’ đang theo học
select dienthoai
from Khoa
inner join SinhVien on Khoa.makhoa=SinhVien.makhoa
where SinhVien.hotensv='Le Van Son'

go

