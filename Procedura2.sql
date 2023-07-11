--2. ��������� �������� ����� ���������� ��������� ������.
--������� ���������: �������� �����������, ����� ������, ��� ��������� ������, ����������� ���� ������, ����������� ���� ���������� 
--(�� ��������� � ������� ����).
create proc fixDorepair_build @name varchar(255), @address_build varchar(255), @TypeRepair varchar(255), @StartDo datetime,
	@EndDo datetime, @result int output
as
begin 
	declare @id_build int

	set @id_build = (select B.id_build from build B, organization O 
						where O.name = @name
						and B.id_org = O.id_org
						and B.address_build = @address_build)

	if not exists(select * from  organization O where O.name = @name)
	begin
		set @result = 1
		return
	end

	if not exists(select * from build B where B.address_build = @address_build)
	begin
		set @result = 2
		return
	end

	if not exists(select * from repair_build RB where RB.id_build = @id_build and RB.TypeRepair = @TypeRepair)
	begin
		set @result = 3
		return
	end

	if exists(select * from repair_build RB 
					where RB.id_build = @id_build
					and RB.TypeRepair = @TypeRepair
					and RB.StartDo = @StartDo
					and RB.EndDo = @EndDo)
	begin
		set @result = 0
		return
	end
end

declare @res int
exec fixDorepair_build 'Monolit', 'Ulica Admirala Tribuca, 10', 'kosmeticheskyi', '29.07.2012', '13.12.2019', @res output

select case @res 
		when 0 then '��������� ��������� �������'
		when 1 then '�������� ����������� ������� �������'
		when 2 then '�������� ����� ������'
		when 3 then '���������� ������� ���� ������ ��� ������� �� �������������'
		else '������ �� �������...'
	end

DROP PROCEDURE dbo.fixDorepair_build