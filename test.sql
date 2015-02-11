drop database if exists test;
create database test;

use test;

create table if not exists Czlonkowie (
	ID MEDIUMINT not null AUTO_INCREMENT,

	Imie varchar(15) not null,
	Nazwisko varchar(20) not null,

	primary key (ID)
);
CREATE TABLE animals (
	id MEDIUMINT NOT NULL AUTO_INCREMENT,
	name CHAR(30) NOT NULL,
	PRIMARY KEY (id)
) ENGINE=MyISAM;

INSERT INTO animals (name) VALUES
('dog'),('cat'),('penguin'),
('lax'),('whale'),('ostrich');
