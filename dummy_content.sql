use Samorzad;

CALL Dodaj_Dzial("Komisja Kultury","Kulturalnie");
CALL Dodaj_Czlonka("Marcin","Natanek",NOW(),"723408934","natanek.marcin@gmail.com","WMII","Informatyka",1);
CALL Dodaj_Czlonka("Aleksandra","Dolezik",NOW(),"inny","a.dolezik@gmail.com","WZiKS","Zarządzanie",1);
CALL Dodaj_Stanowisko("Informatyk","Programmers master race");
CALL Zmien_Stanowisko(1,1);
CALL Zmien_Stanowisko(2,1);
CALL Przewodniczacy_Dzialu(1,1);

CALL Dodaj_Firme("Piekarnia","Stawowa 3, Kraków","piekarnia@stawowa.pl","723494924","bułeczki.pl","Nasza ulubiona piekarnia");
CALL Dodaj_Zlecenie(1,1,"Zamówienie na 100 drożdżówek");
CALL Dodaj_Kontakt(1,1,"Telefonicznie","Szybki telefon do naszej ulubionej piekarni, jak zwykle pozytywnie");
SELECT * FROM Czlonkowie_Stanowiska;
