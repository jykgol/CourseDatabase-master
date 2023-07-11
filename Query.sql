--������� � ��, ����������� � ���� �������������
--1. �������� �������� ������, ���������� ����������.
CREATE VIEW one 
as select * from build where year_build + srok = 2020

select * from one
drop view one

--2. �������� �������� ����� �����, ���������� ����������, �� �������� �� ������ ������ �� ���������� �����������, �������������� ���������.
CREATE VIEW two 
as select * from build
		where year_build + srok = 2020
		and  build.id_org IS NULL

select * from two
drop view two


--3. �������� �������� ������, ������ ������� �� ������ ������ �� �������.
CREATE VIEW three 
as select * from build B
		where EXISTS (SELECT 1 FROM repair_build WHERE ID_BUILD = B.ID_BUILD AND StartDo < getdate() and EndDo is null)

select * from three
drop view three

--4. �������� ����� ��������� ��������� ����� �� ������� ������, ����������� ����������. 
CREATE VIEW four 
as select B.id_build, min(address_build) address_build,min(type_build) type_build,min(year_build) year_build,min(Srok) Srok,min(name) name,sum(price) total_price
		from build B, repair_build RB, organization O
		where B.id_build = RB.id_build
		and B.id_org = O.id_org group by B.id_build
	
select * from four
drop view four

select sum(price) from repair_build where id_build = 2 

--5. �������� ������� ���� ������� ���� ��������� ����� �� �����-����������. 
CREATE VIEW five 
as select TypeRepair,avg(price) as average_price from repair_build RB group by TypeRepair

select * from five
drop view five