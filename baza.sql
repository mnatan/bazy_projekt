drop database if exists Samorzad;
create database if not exists Samorzad;

use Samorzad;

create table if not exists Czlonkowie (
	ID int not null AUTO_INCREMENT,

	Imie varchar(15) not null,
	Nazwisko varchar(20) not null,
	Urodziny date null,

	Telefon varchar(12) not null,
	Email varchar(50) not null,

	Wydzial varchar(20) not null,
	Kierunek varchar(20) not null,

	Aktywny int default 1,

	Dzial int not null,

	primary key (ID)
);
create table if not exists Stanowiska (
	ID int primary key not null AUTO_INCREMENT,

	Nazwa varchar(15) not null,
	Opis varchar(1000) not null
);
create table if not exists HistoriaStanowiska (
	ID int primary key not null AUTO_INCREMENT,

	Czlonek int not null,
	Stanowisko int not null,
	Data datetime not null
);
alter table HistoriaStanowiska add constraint foreign key(`Czlonek`) references Czlonkowie(`ID`);
alter table HistoriaStanowiska add constraint foreign key(`Stanowisko`) references Stanowiska(`ID`);

create table if not exists Dzialy (
	ID int primary key not null AUTO_INCREMENT,

	Nazwa varchar(15) not null,
	Opis varchar(1000) not null,

	Przewodniczacy int,
	foreign key (`Przewodniczacy`) references `Czlonkowie` (`ID`)
);

alter table Czlonkowie add constraint foreign key(`Dzial`) references Dzialy(`ID`);

-------------------------------------------------------------- Firmy zewnętrzne
create table if not exists Firmy (
	ID int primary key not null AUTO_INCREMENT,

	Nazwa varchar(15) not null,
	Adres varchar(50) not null,
	Email varchar(50) not null,
	Telefon varchar(50),
	Strona varchar(50),

	Opis varchar(1000) not null
);
create table if not exists Zlecenia (		-- FIXME TODO
	ID int primary key not null AUTO_INCREMENT,

	Zleceniobiorca int not null,
	Zleceniodawca int not null,

	Opis varchar(1000) not null
);
alter table Zlecenia add constraint foreign key(`Zleceniobiorca`) references Firmy(`ID`);
alter table Zlecenia add constraint foreign key(`Zleceniodawca`) references Czlonkowie(`ID`);

create table if not exists Kontakty (
	ID int primary key not null AUTO_INCREMENT,

	Czlonek int not null,
	Data datetime not null,
	Firma int not null,
	Rodzaj varchar(20) not null,
	Opis varchar(1000) not null
);
alter table Kontakty add constraint foreign key(`Firma`) references Firmy(`ID`);
alter table Kontakty add constraint foreign key(`Czlonek`) references Czlonkowie(`ID`);

------------------------------------------------------------------ Wydarzenia

create table if not exists Spotkania (
	ID int primary key not null AUTO_INCREMENT,
	Odpowiedzialny int not null,

	Data date not null,
	Cel varchar(1000) not null,
	Opis varchar(1000) not null
);
alter table Spotkania add constraint foreign key(`Odpowiedzialny`) references Czlonkowie(`ID`);

create table if not exists Wydarzenia (
	ID int primary key not null AUTO_INCREMENT,
	Odpowiedzialny int not null,

	DataStart datetime not null,
	DataEnd datetime not null,
	Opis varchar(1000) not null,
	Odwiedzajacy int not null,
	Kapial numeric(15,2) not null
);
alter table Wydarzenia add constraint foreign key(`Odpowiedzialny`) references Czlonkowie(`ID`);

create table if not exists Zdjecia (
	ID int primary key not null AUTO_INCREMENT,
	Filepath varchar(1000) not null,
	Wydarzenie int not null
);
alter table Zdjecia add constraint foreign key(`Wydarzenie`) references Wydarzenia(`ID`);
