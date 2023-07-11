--Скалярные функции
--1. Функция, возвращающая первичный ключ здания. Параметр: адрес здания.
create function one(@address varchar(255))
	returns int
		begin
			declare @id int
			select @id = id_build from build B
			where B.address_build = @address
	return @id
end

drop function dbo.one
select dbo.one('Leninskiy prospect, 69')

--2. Функция, возвращающая суммарную длительность выполненных ремонтных работ над указанным зданием. Параметр: первичный ключ здания. 
create function two(@id_build int)
	returns int
		begin
			declare @time int
			set @time = (select sum(datediff(day,RB.StartDo,RB.EndDo)) from repair_build RB 
			where RB.id_build = @id_build
			and RB.EndDo < getdate())
		return @time
end

drop function dbo.two
select dbo.two(1)

--3. Функция, возвращающая суммарную стоимость ремонтных работ над указанным зданием, выполненных за заданный период времени.
--Параметры: первичный ключ здания, дата начала периода, дата окончания периода.
create function three(@id_build int, @start datetime, @end datetime)
	returns int
		begin
			declare @total_price int
			set @total_price = (select sum(RB.price) as total_price from repair_build RB
			where RB.id_build = @id_build
			and RB.StartDo >= @start
			and RB.EndDo <= @end)
		return @total_price
end

drop function dbo.three
select dbo.three(2, '01.01.2000', '31.12.2006')

--4. Функция, возвращающая отклонение фактического срока окончания капремонта указанного здания от запланированного
 --(положительное отклонение – для ремонта, завершенного позже срока).Параметры: первичный ключ здания.
 create function fourr(@id_build int)
	returns int
		begin
			declare @variance int
			declare @answer int
			set @variance = (select datediff(day, RB.PlanEnd, RB.EndDo)
							from repair_build RB
							where RB.id_build = @id_build)
			set @answer = case when @variance < 0 then 1 else -1 end
			return @answer
end

drop function dbo.fourr
select dbo.fourr(6)

--Табличные функции
--1. Функция, возвращающая расценки указанной организации на проведение ремонтных работ. Параметр: название организации.
create function fun3(@name varchar(255))
	returns table
	as 
		return (select price, TypeRepair from repair_build RB, organization O, build B
		where O.name = @name 
		and B.id_org = O.id_org
		and RB.id_build = B.id_build)

select * from dbo.fun3('GlavStroi')

--2. Функция, возвращающая сведения об указанной организации (включая фамилию, имя и отчество директора). Параметр: название организации.
create function fun4(@name varchar(255))
	returns table
	as
		return (select * from organization where name = @name)

select * from dbo.fun4('Monolit')

--3. Функция, возвращающая перечень зданий, отремонтированных указанной организацией. Параметр: название организации.
create function fun11(@name varchar(255))
	returns table
	as
		return (select B.* from build B, organization O--, repair_build RB
		where O.name = @name 
		and B.id_org = O.id_org
		and year_build + srok < 2020)
		--and RB.id_build = B.id_build
		--and RB.EndDo < getdate())

select * from dbo.fun11('Shef Remont')
drop function dbo.fun11

--4. Функция, возвращающая сведения об организации, ремонтирующей (или отремонтировавшей) здание по указанному адресу. Параметр: адрес здания.
create function fun10(@address varchar(255))
	returns table
	as
		return (select O.* from build B, organization O
		where B.address_build = @address
		and O.id_org = B.id_org)

select * from dbo.fun10('Krasnoarmeiskay ulica, 25')
drop function dbo.fun10

--5. Функция, возвращающая перечень ремонтных работ, планируемых указанной организацией над указанным зданием.
--Параметры: название организации, адрес здания.
create function fun12(@name varchar(255), @address varchar(255))
	returns table
	as
		return (select RB.* from build B, organization O, repair_build RB
		where B.address_build = @address
		and O.id_org = B.id_org
		and O.name = @name
		and RB.id_build = B.id_build
		and RB.PlanStart > getdate())

select * from dbo.fun12('Stroitel', 'Krasnoarmeiskay ulica, 25')
drop function dbo.fun12

--6. Функция, возвращающая перечень просроченных ремонтных работ по указанному зданию. Параметр: адрес здания.
create function fun13(@address varchar(255))
	returns table
	as
		return (select RB.* from build B, repair_build RB
		where B.address_build = @address
		and RB.id_build = B.id_build
		and RB.EndDo > RB.PlanEnd)

select * from dbo.fun13('Krasnoarmeiskay ulica, 25')
drop function dbo.fun13

--7. Функция, возвращающая расчетное значение общей стоимости всех ремонтных работ, выполненных указанной организацией над указанным зданием.
--Параметры: название организации, адрес здания.
create function fun14(@name varchar(255), @address varchar(255))
	returns table
	as
		return (select O.name, B.address_build, (RB.price) as total_price from build B, organization O, repair_build RB
		where B.address_build = @address
		and O.id_org = B.id_org
		and O.name = @name
		and RB.id_build = B.id_build
		and RB.EndDo < getdate())

select * from dbo.fun14('Stroitel', 'Krasnoarmeiskay ulica, 25')
drop function dbo.fun14
