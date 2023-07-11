CREATE LOGIN Alex with password = '12345'
CREATE LOGIN Jyk with password = 'qwerty'
CREATE LOGIN Bob with password = 'password'
CREATE LOGIN Alice with password = 'asd'

create user usrAlex for login Alex
create user usrJyk for login Jyk
create user usrBob for login Bob
create user usrAlice for login Alice

create role UseOrg
create role UseBuild
create role UseRepair
create role Director


exec sp_addrolemember 'UseOrg', 'usrAlex'
exec sp_addrolemember 'UseBuild', 'usrJyk'
exec sp_addrolemember 'UseRepair', 'usrBob'
exec sp_addrolemember 'Director', 'usrAlice'

exec sp_droprolemember 'UseOrg', 'usrAlex'
exec sp_droprolemember 'UseBuild', 'usrJyk'
exec sp_droprolemember 'UseRepair', 'usrBob'
exec sp_droprolemember 'Director', 'usrAlice'

revert

drop role UseOrg
drop role UseBuild
drop role UseRepair
drop role Director

drop user usrAlex
drop user usrJyk
drop user usrBob
drop user usrAlice

drop login Alex
drop login Jyk
drop login Bob
drop login Alice

--����� ������� ��� ����: UseOrg
--�������� � �������������� �������� �� ������������ � �� ���������� (������� ���������� � �������� ��������).
grant select, update, delete, insert on vwOrganization to UseOrg

--�������� �������� � ������� � ��������� �������.
create view vwBuild_Repair
as select B.address_build, B.Srok, B.type_build, B.year_build, RB.PlanEnd, RB.PlanStart, RB.StartDo, RB.EndDo, RB.price
from build B, repair_build RB where RB.id_build = B.id_build 

revert

grant select on vwBuild_Repair to UseOrg

drop view vwBuild_Repair

--------------------------------------------------
--����� ������� ��� ����: UseBuild
--�������� �������� �� ������������ � �� ���������.
create view vwOrganization
as
	select id_org, name, address_org, TaxNumber, number, fax, E_mail, DirectorName from organization 

--�������� � �������������� �������� � ������� (������� ���������� � �������� ��������).
create view vwBuild
as
	select id_build, id_org, address_build, type_build, year_build, Srok from build

--�������� �������� � ��������� �������.
create view vwRepair_Build
as
	select * from repair_build

grant select on  vwOrganization to UseBuild
grant select, update, delete, insert on vwBuild to UseBuild
grant select on  vwRepair_Build to UseBuild


--------------------------------------------------
--����� ������� ��� ����: Director
--�������� � �������������� (� �. �. ���������� � ��������) �������� � ��������� ������� ����� �����������.
create view vwMyOrgRepair
as
	select RB.id_repair,RB.id_build,RB.TypeRepair,RB.PlanStart,RB.PlanEnd,RB.StartDo,RB.EndDo,RB.price from organization O, repair_build RB, build B
	where B.id_org = O.id_org
	and RB.id_build = B.id_build 
	and B.id_build = RB.id_build 
	and session_user = 'usrAlice' or session_user = 'usrBob'

select * from vwMyOrgRepair
drop view vwMyOrgRepair

revert

--�������� �������� � ��������� ������� ����� �����������, � ����� � �������, ������������.
create view vwOtherRB_O_B
as
	select O.*, B.address_build, B.Srok, B.type_build, B.year_build, RB.PlanEnd, RB.PlanStart, RB.StartDo, RB.EndDo, RB.price
	from organization O, repair_build RB, build B
	where B.id_org = O.id_org
	and RB.id_build = B.id_build

--�������������� �������� � ����� �����������.
create view vwMyOrg
as
	select * from organization
	where session_user = 'usrAlice' or session_user = 'usrBob'

drop view vwMyOrg

--������������ �������� � ��������� ������� ����� �����������.


grant select, update, delete, insert on vwMyOrgRepair to Director
grant select on vwOtherRB_O_B to Director
grant select, update, delete, insert on vwMyOrg to Director

--------------------------------------------------
--����� ������� ��� ����: UseRepair
--�������� � �������������� (� �. �. ���������� � ��������) �������� � ��������� ������� ����� �����������.
grant select, update, delete, insert on vwMyOrgRepair to UseRepair

--�������� �������� � ��������� ������� ����� �����������, � ����� � �������, ������������
grant select on vwOtherRB_O_B to UseRepair

--�������������� �������� � ����� �����������.
grant select, update, delete, insert on vwMyOrg to UseRepair

revert

--��������
--������������ usrAlex � ����� '������������, �������������� �������� �� ������������'(UseOrg)
execute as user = 'usrAlex'
select * from vwOrganization
insert into vwOrganization values('qqq','Grushevay ulica',23451244332,100,5415,'qqq@mail.ru',NULL)
update vwOrganization set name = 'aaa' where name = 'qqq'
delete from vwOrganization where name = 'aaa'
select * from vwBuild_Repair

select SESSION_USER

revert

/*create view vwOrganization
as
	select id_org, name, address_org, TaxNumber, number, fax, E_mail, DirectorName from organization*/


--������������ usrJyk � ����� '������������, �������������� �������� � �������'(UseBuild)
execute as user = 'usrJyk'
select * from vwOrganization
select * from vwBuild
insert into vwBuild values(3,'Grushevay ulica','qqq',2019,20)
update vwBuild set type_build = 'aaa' where address_build = 'Grushevay ulica'
delete from vwBuild where type_build = 'aaa'
select * from vwRepair_Build

select SESSION_USER

revert

/*create view vwBuild
as
	select id_build, id_org, address_build, type_build, year_build, Srok from build*/

--������������ usrBob � ����� '������������, �������������� �������� � ��������� �������'(UseRepair)
execute as user = 'usrBob'
select * from vwMyOrgRepair
insert into vwMyOrgRepair values(1,'qqq','01.01.1900','12.12.1900','01.01.1901','12.12.1901',12345678)
update vwMyOrgRepair set TypeRepair = 'aaa' where price = 12345678
select * from vwOtherRB_O_B
select * from vwMyOrg
insert into vwMyOrg values('sss', 'Irinovskyi prospect, 11', 2353858402, 786-90-42, 4561, 'qqq@mail.ru', 'www')
update vwMyOrg set name = 'aaa' where E_mail = 'qqq@mail.ru'
delete from vwMyOrg where name = 'aaa'

select SESSION_USER

revert

/*create view vwMyOrg
as
	select * from organization
	where session_user = 'usrAlice' or session_user = 'usrBob'*/

/*create view vwMyOrgRepair
as
	select id_repair,RB.id_build,TypeRepair,PlanStart,PlanEnd,StartDo,EndDo,price from organization O, repair_build RB, build B
	where B.id_org = O.id_org
	and RB.id_build = B.id_build 
	and session_user = 'usrAlice' or session_user = 'usrBob'*/

--������������ usrAlice � ����� '��������� �����������'(Director)
execute as user = 'usrAlice'
insert into vwMyOrgRepair values(1,'qqq','01.01.1900','12.12.1900','01.01.1901','12.12.1901',12345678)
update vwMyOrgRepair set TypeRepair = 'aaa' where price = 12345678
select * from vwOtherRB_O_B
select * from vwMyOrg
insert into vwMyOrg values('sss', 'Irinovskyi prospect, 11', 2353858402, 786-90-42, 4561, 'qqq@mail.ru', 'www')
update vwMyOrg set name = 'aaa' where E_mail = 'qqq@mail.ru'
delete from vwMyOrg where name = 'aaa'

revert