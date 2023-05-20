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

-- Cac yeu cau phieu bai tap 2
/* 
1. Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
2. Cho biết tên đề tài không có sinh viên nào thực tập
3. Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
4. Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
5. Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
6. Đưa ra mã số, họ tên và điểm của các sinh viên khoa ‘DIALY và QLTN’
7. Đưa ra tên khoa, số lượng sinh viên của mỗi khoa
8. Cho biết thông tin về các sinh viên thực tập tại quê nhà
9. Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập
10. Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
*/

-- Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
select DeTai.madt, DeTai.tendt
from DeTai
inner join HuongDan on DeTai.madt=HuongDan.madt
inner join GiangVien on HuongDan.magv=GiangVien.magv
where GiangVien.hotengv='Tran Son'


-- Cho biết tên đề tài không có sinh viên nào thực tập
select tendt 
from DeTai 
where madt not in(
	select distinct madt
	from HuongDan
)


-- Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
select GiangVien.magv, GiangVien.hotengv, Khoa.tenkhoa
from GiangVien
inner join HuongDan on GiangVien.magv = HuongDan.magv
inner join SinhVien ON SinhVien.masv = HuongDan.masv
inner join Khoa ON GiangVien.makhoa = Khoa.makhoa
GROUP BY GiangVien.magv, GiangVien.hotengv, Khoa.tenkhoa
HAVING COUNT(SinhVien.masv) >= 3;


-- Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
select madt, tendt
from DeTai
where kinhphi = (
	select MAX(kinhphi)
	from DeTai
)


-- Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
select DeTai.madt, DeTai.tendt
from DeTai 
inner join HuongDan on DeTai.madt=HuongDan.madt
inner join SinhVien on SinhVien.masv=HuongDan.masv
group by DeTai.madt, DeTai.tendt
having count(SinhVien.masv) > 2;


-- Đưa ra mã số, họ tên và điểm của các sinh viên khoa ‘DIALY và QLTN’
select SinhVien.masv, hotensv, ketqua
from SinhVien 
inner join HuongDan on SinhVien.masv=HuongDan.masv
inner join Khoa on SinhVien.makhoa=Khoa.makhoa
where Khoa.tenkhoa=('DIALY va QLTN')


-- Đưa ra tên khoa, số lượng sinh viên của mỗi khoa
select Khoa.tenkhoa, count(SinhVien.masv) as SoLuongSV
from SinhVien 
inner join Khoa on SinhVien.makhoa=Khoa.makhoa
group by Khoa.makhoa, Khoa.tenkhoa


-- Cho biết thông tin về các sinh viên thực tập tại quê nhà
select *
from SinhVien
inner join HuongDan on SinhVien.masv=HuongDan.masv 
inner join DeTai on DeTai.madt=HuongDan.madt
where SinhVien.quequan=DeTai.NoiThucTap


-- Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập
select * from SinhVien
inner join HuongDan on SinhVien.masv=HuongDan.masv
where HuongDan.ketqua is null


-- Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
select SinhVien.masv, hotensv
from SinhVien
inner join HuongDan on SinhVien.masv=HuongDan.masv
where ketqua=0;