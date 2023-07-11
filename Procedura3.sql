--3. Процедура установки расценки на проведение вида ремонтной работы.
--Входные параметры: название организации, вид ремонтной работы, расценка.
create proc SetRepair_price @name varchar(255), @TypeRepair varchar(255), @price money, @result int output
as
begin 
	declare @id_build int
	declare @id_org int

	if not exists(select * from  organization O where O.name = @name)
	begin
		set @result = 1
		return
	end

	set @id_org = (select O.id_org from organization O where O.name = @name)
	set @id_build = (select B.id_build from build B where B.id_org = @id_org)

	insert into repair_build values(@id_build, @TypeRepair, NULL, NULL, NULL, NULL, @price)
	set @result = 0
end

declare @res int
exec SetRepair_price 'Stroitel', 'kapitalnyi',8000000, @res output

select case @res 
		when 0 then 'Процедура завершена успешно'
		when 1 then 'Название организации указано неверно'
		else 'Ничего не понимаю...'
	end

DROP PROCEDURE dbo.SetRepair_price