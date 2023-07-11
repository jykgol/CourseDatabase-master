CREATE TABLE organization(
	id_org int identity primary key,
	name varchar(255) NOT NULL UNIQUE,
	address_org varchar(255) UNIQUE,
	TaxNumber sql_variant UNIQUE,
	number sql_variant UNIQUE,
	fax sql_variant UNIQUE,
	E_mail varchar(255) UNIQUE,
	DirectorName varchar(255))

CREATE TABLE build(
	id_build int identity primary key,
	id_org int foreign key references organization(id_org),
	address_build varchar(255) UNIQUE,
	type_build varchar(255),
	year_build int NOT NULL,
	Srok int CHECK(Srok > 0))

CREATE TABLE repair_build(
	id_repair int identity primary key,
	id_build int foreign key references build(id_build),
	TypeRepair varchar(255),
	PlanStart datetime,
	PlanEnd datetime,
	StartDo datetime,
	EndDo datetime,
	price money CHECK(price > 0))

CREATE TABLE Users(
	id_org int foreign key references organization(id_org),
	UserName varchar(255))_

INSERT INTO Users values(1, 'usrBob')
INSERT INTO Users values(2, 'usrAlice')
INSERT INTO Users values(3, 'usrAlice')
INSERT INTO Users values(4, 'usrBob')
INSERT INTO Users values(3, 'usrBob')
INSERT INTO Users values(5, 'usrAlice')

INSERT INTO organization values('Stroitel', 'Irinovskyi prospect, 2', 2353859402, 786-90-45, 2365, 'stroitel@mail.ru', 'Aleksandr Vladimirovich Ivanov')
INSERT INTO organization values('GlavStroi', 'Geleznovodskay ulica, 10', 3483763801, 905-34-81, 8093, 'glavstroi@yandex.ru', 'Vasiliy Ivanovich Sobolev')
INSERT INTO organization values('Monolit', 'Naberegnay reki Moiki, 76', 8106815903, 764-90-35, 9270, 'monolit@rambler.ru', 'Aleksei Leonidovich Petrov')
INSERT INTO organization values('Shef Remont', 'Kondratievskyi prospect, 7', 7543018657, 513-64-19, 5149, 'remont@mail.ru', 'Evgeniy Victorovich Sokolov')
INSERT INTO organization values('Glav Svai', 'Naberegnay obvodnogo kanala, 70', 1962073842, 305-19-76, 1078, 'svai@yahoo.ru', 'Denis Olegovich Fedotov')

INSERT INTO build values(2,'Leninskiy prospect, 69', 'Obshestvenya', 1989, 10) 
INSERT INTO build values(4,'Ulica Zukovskogo, 27', 'Proizvodstvenya', 1975, 39)
INSERT INTO build values(1,'Krasnoarmeiskay ulica, 25', 'Administrativnya', 2001, 30) 
INSERT INTO build values(2,'Kamenoostrovskiy prospect, 37', 'Obshestvennya', 1961, 24) 
INSERT INTO build values(5,'Malay Kashtanovay alley, 9', 'Giloya', 2009, 20) 
INSERT INTO build values(3,'Ulica Admirala Tribuca, 10', 'Giloya', 2010, 30) 
INSERT INTO build values(3,'Dachnyy prospect, 56', 'Administrativnya', 1967, 53)
INSERT INTO build values(4,'Dachnyy prospect, 1', 'Giloya', 2000, 20) 
INSERT INTO build values(NULL,'Krasnoarmeiskay ulica, 14', 'Administrativnya', 1980, 40) 

INSERT INTO repair_build values(5,'kapitalnyi', '24.03.2000', '24.03.2001', '21.11.2005', '23.12.2006', 32985645)
INSERT INTO repair_build values(1,'kapitalnyi', '18.01.1995', '31.05.1998', '27.12.2003', '07.03.2010', 4294856450)
INSERT INTO repair_build values(4,'kosmeticheskyi', '08.11.2010', '30.12.2010', '11.11.2010', '02.09.2011', 11728602)
INSERT INTO repair_build values(5,'kapitalnyi', '24.03.1981', '15.06.1985', '16.10.1980', '21.09.1983', 99980732)
INSERT INTO repair_build values(3,'kosmeticheskyi', '14.08.2011', '18.10.2011', '29.07.2012', '13.12.2012', 12625010)
INSERT INTO repair_build values(7,'kosmeticheskyi', '21.10.2013', '17.11.2014', '22.12.2013', NULL, 212625010)
INSERT INTO repair_build values(2,'kapitalnyi', '05.11.1967', '02.10.1980', '30.11.2000', '25.10.2001', 892621011)
INSERT INTO repair_build values(2,'kapitalnyi', '05.11.2002', '02.10.2006', '30.11.2002', '25.10.2006', 621011)
INSERT INTO repair_build values(3,'kosmeticheskyi', '14.08.2021', '18.10.2021', '29.07.2022', '13.12.2022', 96305010)
INSERT INTO repair_build values(6,'kosmeticheskyi', '14.08.2010', '18.10.2011', '29.07.2012', '13.12.2019', 96305010)
INSERT INTO repair_build values(7,'kosmeticheskyi', '21.10.2013', '17.11.2014', '22.12.2013', '20.11.2019', 212625010)

DROP table dbo.repair_build, dbo.build, dbo.organization