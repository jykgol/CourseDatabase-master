-- Создание криптографических объектов БД
-- Создание самоподписанного цифрового сертификата
create certificate SelfSignedCert
	encryption by password = 'Qd04!-}'
	with subject = 'Проверка шифрования',
	start_date = '16/05/2020'

drop certificate SelfSignedCert
select * from sys.certificates

-- Создание асимметричного ключа
create asymmetric key AsymKey
with algorithm = RSA_1024
encryption by password = 'Qd04!-}'

drop asymmetric key AsymKey
select * from sys.asymmetric_keys

-- Создание симметричного ключа
create symmetric key SymKey
with algorithm = TRIPLE_DES
encryption by password = 'Qd04!-}'

drop symmetric key SymKey
select * from sys.symmetric_keys

-- Создание копий таблиц (Данные о проведении ремонтных работ)
CREATE TABLE repair_build1(
	id_repair int identity primary key,
	TypeRepair varbinary(max),
	PlanStart varbinary(max),
	PlanEnd varbinary(max),
	StartDo varbinary(max),
	EndDo varbinary(max),
	price varbinary(max))

CREATE TABLE repair_build2(
	id_repair int identity primary key,
	TypeRepair varbinary(max),
	PlanStart varbinary(max),
	PlanEnd varbinary(max),
	StartDo varbinary(max),
	EndDo varbinary(max),
	price varbinary(max))

CREATE TABLE repair_build3(
	id_repair int identity primary key,
	TypeRepair varbinary(max),
	PlanStart varbinary(max),
	PlanEnd varbinary(max),
	StartDo varbinary(max),
	EndDo varbinary(max),
	price varbinary(max))

CREATE TABLE repair_build4(
	id_repair int identity primary key,
	TypeRepair varbinary(max),
	PlanStart varbinary(max),
	PlanEnd varbinary(max),
	StartDo varbinary(max),
	EndDo varbinary(max),
	price varbinary(max))

drop table repair_build1
drop table repair_build2
drop table repair_build3
drop table repair_build4

-- Зашифрование данных таблицы repair_build1 с использованием сертификата
insert into repair_build1 values(EncryptByCert(Cert_ID('SelfSignedCert'), 'kapitalnyi'), EncryptByCert(Cert_ID('SelfSignedCert'), '18.04.2003'), 
EncryptByCert(Cert_ID('SelfSignedCert'), '11.06.2005'), EncryptByCert(Cert_ID('SelfSignedCert'), '21.05.2004'), 
EncryptByCert(Cert_ID('SelfSignedCert'), '30.04.2005'), EncryptByCert(Cert_ID('SelfSignedCert'), '120030245'))

select * from repair_build1

-- Зашифрование данных таблицы repair_build2 с использованием асимметричного ключа
insert into repair_build2 values(EncryptByAsymKey(AsymKey_ID('AsymKey'), 'kosmeticheskyi'), EncryptByAsymKey(AsymKey_ID('AsymKey'), '12.08.1987'),
EncryptByAsymKey(AsymKey_ID('AsymKey'), '13.09.1987'), EncryptByAsymKey(AsymKey_ID('AsymKey'), '15.08.1987'),
EncryptByAsymKey(AsymKey_ID('AsymKey'), '16.10.1987'),EncryptByAsymKey(AsymKey_ID('AsymKey'), '2980765'))

select * from repair_build2

-- Зашифрование данных таблицы repair_build3 с использованием симметричного ключа
open symmetric key SymKey
decryption by password = 'Qd04!-}'
insert into repair_build3 values(EncryptByKey(Key_GUID('SymKey'), 'kosmeticheskyi'), EncryptByKey(Key_GUID('SymKey'), '05.11.1967'),
EncryptByKey(Key_GUID('SymKey'), '02.10.1980'), EncryptByKey(Key_GUID('SymKey'), '30.11.2000'), EncryptByKey(Key_GUID('SymKey'), '25.10.2001'),
EncryptByKey(Key_GUID('SymKey'), '9807652'))

select * from repair_build3
close symmetric key SymKey

-- Зашифрование данных таблицы repair_build4 с использованием парольной фразы
insert into repair_build4 values(EncryptByPassphrase('Qd04!-}', 'kapitalnyi'), EncryptByPassphrase('Qd04!-}', '18.01.1995'),
EncryptByPassphrase('Qd04!-}', '31.05.1998'), EncryptByPassphrase('Qd04!-}', '27.12.2003'), EncryptByPassphrase('Qd04!-}', '07.03.2010'),
EncryptByPassphrase('Qd04!-}','4294856450'))

select * from repair_build4

-- Создание представлений для расшифрования таблиц
-- Расшифрование с использованием сертификата
create view vwRepair_build1 with encryption 
as
	select convert(varchar(100), DecryptByCert(Cert_ID('SelfSignedCert'), TypeRepair, N'Qd04!-}')) as TypeRepair,
	convert(varchar(100), DecryptByCert(Cert_ID('SelfSignedCert'), PlanStart, N'Qd04!-}')) as PlanStart,
	convert(varchar(100), DecryptByCert(Cert_ID('SelfSignedCert'), PlanEnd, N'Qd04!-}')) as PlanEnd,
	convert(varchar(100), DecryptByCert(Cert_ID('SelfSignedCert'), StartDo, N'Qd04!-}')) as StartDo,
	convert(varchar(100), DecryptByCert(Cert_ID('SelfSignedCert'), EndDo, N'Qd04!-}')) as EndDo,
	convert(varchar(100), DecryptByCert(Cert_ID('SelfSignedCert'), price, N'Qd04!-}')) as price
from repair_build1

select * from vwRepair_build1

-- Расшифрование с использованием асимметричного ключа
create view vwRepair_build2 with encryption 
as
	select convert(varchar(100), DecryptByAsymKey(AsymKey_ID('AsymKey'), TypeRepair, N'Qd04!-}')) as TypeRepair,
	convert(varchar(100), DecryptByAsymKey(AsymKey_ID('AsymKey'), PlanStart, N'Qd04!-}')) as PlanStart,
	convert(varchar(100), DecryptByAsymKey(AsymKey_ID('AsymKey'), PlanEnd, N'Qd04!-}')) as PlanEnd,
	convert(varchar(100), DecryptByAsymKey(AsymKey_ID('AsymKey'), StartDo, N'Qd04!-}')) as StartDo,
	convert(varchar(100), DecryptByAsymKey(AsymKey_ID('AsymKey'), EndDo, N'Qd04!-}')) as EndDo,
	convert(varchar(100), DecryptByAsymKey(AsymKey_ID('AsymKey'), price, N'Qd04!-}')) as price
from repair_build2

select * from vwRepair_build2

-- Расшифрование с помощью симметричного ключа
open symmetric key SymKey
decryption by password = 'Qd04!-}'
create view vwRepair_build3 with encryption 
as
	select convert(varchar(100), DecryptByKey(TypeRepair)) as TypeRepair,
	convert(varchar(100), DecryptByKey(PlanStart)) as PlanStart,
	convert(varchar(100), DecryptByKey(PlanEnd)) as PlanEnd,
	convert(varchar(100), DecryptByKey(StartDo)) as StartDo,
	convert(varchar(100), DecryptByKey(EndDo)) as EndDo,
	convert(varchar(100), DecryptByKey(price)) as price
from repair_build3

select * from vwRepair_build3
close symmetric key SymKey

-- Расшифрование с использованием парольной фразы
create view vwRepair_build4 with encryption 
as
	select convert(varchar(100), DecryptByPassphrase('Qd04!-}', TypeRepair)) as TypeRepair,
	convert(varchar(100), DecryptByPassphrase('Qd04!-}', PlanStart)) as PlanStart,
	convert(varchar(100), DecryptByPassphrase('Qd04!-}', PlanEnd)) as PlanEnd,
	convert(varchar(100), DecryptByPassphrase('Qd04!-}', StartDo)) as StartDo,
	convert(varchar(100), DecryptByPassphrase('Qd04!-}', EndDo)) as EndDo,
	convert(varchar(100), DecryptByPassphrase('Qd04!-}', price)) as price
from repair_build4

select * from vwRepair_build4

-- Создание таблицы tblSignature для ЭЦП
create table tblSignature(
	id_repair int identity primary key,
	RepairInfo nvarchar(max),
	signature varbinary(8000))
	
drop table tblSignature	

-- Добавление в tblSignature строк и формирование для них ЭЦП
insert into tblSignature values(N'kapitalnyi',SignByAsymKey(AsymKey_Id('AsymKey'), N'kapitalnyi', N'Qd04!-}'))
insert into tblSignature values(N'24.03.2001', SignByAsymKey(AsymKey_Id('AsymKey'), N'24.03.2001', N'Qd04!-}'))


select * from tblSignature

-- Проверка
select RepairInfo,
	VerifySignedByAsymKey(AsymKey_ID('AsymKey'), RepairInfo, signature) as signature_valid
	from tblSignature
