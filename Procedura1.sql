--Хранимые процедуры
--1. Процедура регистрации новой ремонтной работы.
--Входные параметры: название организации, адрес здания, вид ремонтной работы, планируемые сроки выполнения.

create proc addrepair_build @name varchar(255), @TypeRepair varchar(255), @PlanStart datetime,
	@PlanEnd datetime, @address_build varchar(255), @result int output
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

	insert into repair_build values(@id_build, @TypeRepair, @PlanStart, @PlanEnd, NULL, NULL, NULL)
	set @result = 0
end

declare @res int
exec addrepair_build 'GlavStroi', 'kapitalnyi', '10.11.2002', '02.02.2003', 'Kamenoostrovskiy prospect, 37', @res output

select case @res 
		when 0 then 'Процедура завершена успешно'
		when 1 then 'Название организации указано неверно'
		when 2 then 'Неверный адрес здания'
		else 'Ничего не понимаю...'
	end

DROP PROCEDURE dbo.addrepair_build

