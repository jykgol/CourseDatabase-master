--1. Нельзя планировать ремонтные работы на более ранний срок, чем требуемый срок капремонта.
create trigger tr1
on repair_build 
for update, insert 
	as
		if exists (select RB.PlanStart, B.year_build, B.Srok
					from repair_build RB, build B
					where RB.id_build = B.id_build
					and RB.PlanStart < B.year_build + B.Srok)
rollback tran

drop trigger tr1

INSERT INTO repair_build values(1,'kapitalnyi', '18.01.3000', '31.05.1998', '27.12.2003', '07.03.2010', 4294856450)

--2. Плановая дата окончания работы – более ранняя, чем плановая дата начала.
create trigger tr2
on repair_build 
for update, insert 
	as
		if exists(select RB.PlanStart, RB.PlanEnd
					from repair_build RB
					where RB.PlanStart > RB.PlanEnd)
rollback tran

drop trigger tr2

INSERT INTO repair_build values(1,'kapitalnyi', '18.01.3000', '31.05.1998', '27.12.2003', '07.03.2010', 4294856450)

--3. Фактическая дата окончания работы – более ранняя, чем фактическая дата начала работы.
create trigger tr3
on repair_build 
for update, insert 
	as
		if exists(select RB.StartDo, RB.EndDo
					from repair_build RB
					where RB.EndDo < RB.StartDo)
rollback tran

INSERT INTO repair_build values(1,'kapitalnyi', '18.01.1900', '31.05.1998', '27.12.2003', '07.03.2000', 4294856450)

drop trigger tr3

--4. Суммарная стоимость ремонтных работ должна находиться в некоторых пределах (выбираются студентом самостоятельно).
create trigger tr4
on repair_build 
for update, insert 
	as
		declare @totalprice money
		set @totalprice = (select sum(RB.price) from repair_build RB)
		if @totalprice > 1000000000000 or @totalprice < 1000000
rollback tran 

drop trigger tr4

--5. При добавлении новой ремонтной работы фактические сроки начала и окончания неизвестны.
create trigger tr5
on repair_build 
for update, insert 
	as
		if exists(select RB.StartDo, RB.EndDo
					from repair_build RB
					where RB.StartDo is null
					and RB.EndDo is null)
rollback tran

INSERT INTO repair_build values(1,'kapitalnyi', '18.01.3000', '31.05.1998', NULL, NULL, 4294856450)

drop trigger tr5