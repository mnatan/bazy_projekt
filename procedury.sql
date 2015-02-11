-------------------------------------------------------------------------------------------------------------
---------------------------------------- Procedury i widoki -------------------------------------------------
-------------------------------------------------------------------------------------------------------------

use Samorzad;

/* dodawanie do bazy */
DROP PROCEDURE IF EXISTS Dodaj_Czlonka;
DELIMITER $$
CREATE PROCEDURE Dodaj_Czlonka
(
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
	INSERT INTO Samorzad.Czlonkowie (Imie,Nazwisko,Urodziny,Telefon,Email,Wydzial,Kierunek,Aktywny,Dzial)
	VALUES (
		AtImie,
		AtNazwisko,
		AtUrodziny,
		AtTelefon,
		AtEmail,
		AtWydzial,
		AtKierunek,
		1,
		AtDzial) ;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS Dodaj_Dzial;
DELIMITER $$
CREATE PROCEDURE Dodaj_Dzial
(
	IN AtNazwa varchar(15),
	IN AtOpis varchar(1000)
)
BEGIN
	INSERT INTO Samorzad.Dzialy (Nazwa,Opis,Przewodniczacy)
	VALUES (
		AtNazwa,
		AtOpis,
		NULL
	);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS Przewodniczacy_Dzialu;
DELIMITER $$
CREATE PROCEDURE Przewodniczacy_Dzialu
(
	IN AtIDDzial int,
	IN AtIDCzlonka int
)
BEGIN
	UPDATE Dzialy D 
	SET Przewodniczacy = AtIDCzlonka 
	WHERE D.ID=AtIDDzial;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS Dodaj_Stanowisko;
DELIMITER $$
CREATE PROCEDURE Dodaj_Stanowisko
(
	IN AtNazwa varchar(15),
	IN AtOpis varchar(1000)
)
BEGIN
	INSERT INTO Samorzad.Stanowiska (Nazwa,Opis)
	VALUES (
		AtNazwa,
		AtOpis
	);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS Zmien_Stanowisko;
DELIMITER $$
CREATE PROCEDURE Zmien_Stanowisko
(
	IN AtIDCzlonka int,
	IN AtIDStanowiska int
)
BEGIN
	INSERT INTO HistoriaStanowiska (Czlonek,Stanowisko,Data) VALUES 
	(AtIDCzlonka, AtIDStanowiska, NOW());
END$$
DELIMITER ;


------------------------------------------------------------------------------
------------------------------- FIRMY ----------------------------------------
------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS Dodaj_Firme;
DELIMITER $$
CREATE PROCEDURE Dodaj_Firme
(
	IN AtNazwa varchar(15),
	IN AtAdres varchar(50),
	IN AtEmail varchar(50),
	IN AtTelefon varchar(50),
	IN AtStrona varchar(50),
	IN AtOpis varchar(1000)
)
BEGIN
	INSERT INTO Firmy (Nazwa,Adres,Email,Telefon,Strona,Opis) VALUES 
	(AtNazwa,AtAdres,AtEmail,AtTelefon,AtStrona,AtOpis);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS Dodaj_Zlecenie;
DELIMITER $$
CREATE PROCEDURE Dodaj_Zlecenie
(
	IN AtZleceniobiorca int,
	IN AtZleceniodawca int,
	IN AtOpis varchar(1000)
)
BEGIN
	INSERT INTO Zlecenia (Zleceniobiorca,Zleceniodawca,Opis) VALUES 
	(AtZleceniobiorca,AtZleceniodawca,AtOpis);
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS Dodaj_Kontakt;
DELIMITER $$
CREATE PROCEDURE Dodaj_Kontakt
(
	IN AtCzlonek int,
	IN AtFirma int,
	IN AtRodzaj varchar(20),
	IN AtOpis varchar(1000)
)
BEGIN
	INSERT INTO Kontakty (Czlonek,Data,Firma,Rodzaj,Opis) VALUES 
	(AtCzlonek,NOW(),AtFirma,AtRodzaj,AtOpis);
END$$
DELIMITER ;

------------------------------------------------------------------------------
--------------------------- Selecty i widoki ---------------------------------
------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS Wypisz_Dzial;
DELIMITER $$
CREATE PROCEDURE Wypisz_Dzial
(
	IN AtID int
)
BEGIN
	SELECT C.Imie, C.Nazwisko
	FROM Dzialy D JOIN Czlonkowie C on C.Dzial = D.ID
	WHERE D.ID = AtID;
END$$
DELIMITER ;

CREATE OR REPLACE VIEW Czlonkowie_Stanowiska AS
SELECT C.Imie, C.Nazwisko, D.Nazwa Dzial, S.Nazwa Stanowisko
FROM Czlonkowie C JOIN HistoriaStanowiska H on C.ID = H.Czlonek 
JOIN Stanowiska S on H.Stanowisko=S.ID 
JOIN Dzialy D on C.Dzial=D.ID
WHERE H.Data = (SELECT MAX(Data) FROM HistoriaStanowiska S WHERE S.Czlonek=C.ID);
