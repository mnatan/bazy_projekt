drop database if exists Samorzad;
create database if not exists Samorzad;

use Samorzad;

create table if not exists Czlonkowie (
	ID int primary key,

	Imie varchar(15) not null,
	Nazwisko varchar(20) not null,
	Urodziny date null,

	Telefon varchar(12) not null,
	Email varchar(50) not null,

	Wydzial varchar(20) not null,
	Kierunek varchar(20) not null,

	Aktywny int default 1,

	Dzial int not null
);
create table if not exists Stanowiska (
	ID int primary key not null,

	Nazwa varchar(15) not null,
	Opis varchar(1000) not null
);
create table if not exists HistoriaStanowiska (
	ID int primary key not null,

	Czlonek int not null,
	Stanowisko int not null,
	Data date not null
);
alter table HistoriaStanowiska add constraint foreign key(`Czlonek`) references Czlonkowie(`ID`);
alter table HistoriaStanowiska add constraint foreign key(`Stanowisko`) references Stanowiska(`ID`);

create table if not exists Dzialy (
	ID int primary key not null,

	Nazwa varchar(15) not null,
	Opis varchar(1000) not null,

	Przewodniczacy int not null,
	foreign key (`Przewodniczacy`) references `Czlonkowie` (`ID`)
);

alter table Czlonkowie add constraint foreign key(`Dzial`) references Dzialy(`ID`);

-------------------------------------------------------------- Firmy zewnętrzne
create table if not exists Firmy (
	ID int primary key not null,

	Nazwa varchar(15) not null,
	Adres varchar(50) not null,
	Email varchar(50) not null,
	Telefon varchar(50) not null,
	Strona varchar(50) not null,

	Opis varchar(1000) not null
);
create table if not exists Zlecenia (		-- FIXME TODO
	ID int primary key not null,

	Zleceniobiorca int not null,
	Zleceniodawca int not null
);
alter table Zlecenia add constraint foreign key(`Zleceniobiorca`) references Firmy(`ID`);
alter table Zlecenia add constraint foreign key(`Zleceniodawca`) references Czlonkowie(`ID`);

create table if not exists Kontakty (
	ID int primary key not null,

	Data date not null,
	Firma int not null,
	Rodzaj varchar(20) not null,
	Opis varchar(1000) not null
);
alter table Kontakty add constraint foreign key(`Firma`) references Firmy(`ID`);

------------------------------------------------------------------ Wydarzenia

create table if not exists Spotkania (
	ID int primary key not null,
	Odpowiedzialny int not null,

	Data date not null,
	Cel varchar(1000) not null,
	Opis varchar(1000) not null
);
alter table Spotkania add constraint foreign key(`Odpowiedzialny`) references Czlonkowie(`ID`);

create table if not exists Wydarzenia (
	ID int primary key not null,
	Odpowiedzialny int not null,

	Data date not null,
	Opis varchar(1000) not null,
	Odwiedzajacy int not null,
	Kapial numeric(15,2) not null
);
alter table Wydarzenia add constraint foreign key(`Odpowiedzialny`) references Czlonkowie(`ID`);

create table if not exists Zdjecia (
	ID int primary key not null,
	Filepath varchar(1000) not null,
	Wydarzenie int not null
);
alter table Zdjecia add constraint foreign key(`Wydarzenie`) references Wydarzenia(`ID`);



-------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- Funkcje ------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

/* dodawanie do bazy */
DROP PROCEDURE IF EXISTS Samorzad.`Dodaj_Czlonka`;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS Samorzad.`Dodaj_Czlonka`(
	IN AtImie varchar(15),
	IN AtNazwisko varchar(20),
	IN AtUrodziny date,
	IN AtTelefon varchar(12),
	IN AtEmail varchar(50),
	IN AtWydzial varchar(20),
	IN AtKierunek varchar(20),
	IN AtDzial int 
)
BEGIN
	SET @ID = '11111';
	CALL create_custID(AtCompanyName,AtContactName,@ID);

	INSERT INTO Customers 
	VALUES (@ID,
			AtCompanyName,
			AtContactName,
			AtContactTitle,
			AtAdress,
			AtCity,
			AtRegion,
			AtPostalCode,
			AtCountry,
			AtPhone,
			AtFax);

END$$

DELIMITER ;

/*tworzenie customerID*/
DROP PROCEDURE IF EXISTS Samorzad.`create_custID`;

DELIMITER $$

CREATE PROCEDURE Samorzad.`create_custID`(
	 IN AtCompanyName VARCHAR(40),
	 IN AtContactName VARCHAR(30),
	OUT id_ret VARCHAR(5)
)
BEGIN

	SELECT UPPER(CONCAT(SUBSTR(AtCompanyName, 1, 2),SUBSTR(AtContactName,1,3))) 
	INTO id_ret;

END$$

DELIMITER ;
