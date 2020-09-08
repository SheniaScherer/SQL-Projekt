
/*CREATING A TABLE*/
SHOW DATABASES;
drop DATABASE Bike;
CREATE DATABASE Bike;
USE Bike;

CREATE TABLE Kunde(
	Kundnr int,
    Name varchar(40),
	Strasse varchar(40),				
	Plz varchar(10),	
	Ort varchar(40),
	Sperre binary 	
);
				/*Alter the table "kunde"*/
	ALTER TABLE Kunde ADD PRIMARY KEY (Kundnr);
	ALTER TABLE `kunde` CHANGE `Kundnr` `Kundnr` int(11) NOT NULL AUTO_INCREMENT;
    ALTER TABLE Kunde ADD UNIQUE (Kundnr);	
	
	ALTER TABLE Kunde MODIFY COLUMN Name varchar(40) NOT NULL;
    ALTER TABLE Kunde MODIFY COLUMN Strasse varchar(40) NOT NULL;
	ALTER TABLE Kunde MODIFY COLUMN Plz varchar(10) NOT NULL;
	ALTER TABLE Kunde MODIFY COLUMN Ort varchar(40)NOT NULL;
    ALTER TABLE Kunde MODIFY COLUMN Sperre binary NOT NULL;
	

CREATE TABLE Personal(
	Persnr int,
    Name varchar(40),
	Strasse varchar(40),
	Plz varchar(10),	
	Ort varchar(40),
	GebDatum date,
	Stand varchar (40),
	Vorgesetzt int,
	Gehalt int,
	Beurt int,
	Aufgabe varchar (40)	
);
	ALTER TABLE Personal ADD PRIMARY KEY (Persnr);
  	ALTER TABLE `Personal` CHANGE `Persnr` `Persnr` int(11) NOT NULL AUTO_INCREMENT; 
	ALTER TABLE Personal ADD UNIQUE (Persnr);
	
	ALTER TABLE Personal MODIFY COLUMN Name varchar(40) NOT NULL;
    ALTER TABLE Personal MODIFY COLUMN Strasse varchar(40) NOT NULL;
	ALTER TABLE Personal MODIFY COLUMN Plz varchar(10) NOT NULL;
	ALTER TABLE Personal MODIFY COLUMN Ort varchar(40)NOT NULL;
	ALTER TABLE Personal MODIFY COLUMN GebDatum date NOT NULL;
	ALTER TABLE Personal MODIFY COLUMN Stand varchar (40) NOT NULL;
    ALTER TABLE Personal MODIFY COLUMN Vorgesetzt int NOT NULL;
	ALTER TABLE Personal MODIFY COLUMN Gehalt int NOT NULL;
	ALTER TABLE Personal MODIFY COLUMN Beurt int NOT NULL;
	ALTER TABLE Personal MODIFY COLUMN Aufgabe varchar (40) NOT NULL;
	
								
						/*Creating a view called "vpers" in SQL*/
	CREATE VIEW VPers(Persnr, Name, Strasse, PLZ, Ort, GebDatum, Stand, Vorgesetzt, Aufgabe) 
	AS SELECT Persnr, Name, Strasse, PLZ, Ort, GebDatum, Stand, Vorgesetzt, Aufgabe
	FROM Personal
	WHERE Vorgesetzt IS NOT NULL; 
	
							/*Grant  privileges*/
	GRANT Select, 
	Update (Gehalt, Vorgesetzt, Aufgabe, Beurt) 
	ON TABLE Personal 
	TO Personalabteilung;
	
						/*Grant and Revoke privileges*/
	REVOKE ALL PRIVILEGES ON `bike`.`personal`
	FROM 'Personalabteilung'@'%'; 
	GRANT SELECT, UPDATE (`Vorgesetzt`, `Gehalt`, `Beurt`, `Aufgabe`) 
	ON `bike`.`personal` TO 'Personalabteilung'@'%'; 
							

CREATE TABLE Artikel(
	ANr int,	
	Bezeichnung int NOT NULL,
	Netto int NOT NULL,
	Steuer int NOT NULL,
	Preis int NOT NULL,
	Farbe varchar (30) NULL,
	Mass varchar (20) NULL,
	Einheit varchar (5) NOT NULL,
	Typ varchar (5) NOT NULL 
);

	ALTER TABLE Artikel ADD PRIMARY KEY (ANr);
	ALTER TABLE `artikel` CHANGE `ANr` `ANr` INT(11) NOT NULL AUTO_INCREMENT; 
	ALTER TABLE Artikel ADD UNIQUE (ANr);	
	
	
	
CREATE TABLE Auftrag(
	Auftrnr int,
	Persnr int NOT NULL, 
	Kundnr int NOT NULL,
    Datum date NOT NULL
);
	ALTER TABLE Auftrag ADD PRIMARY KEY (Auftrnr);
	ALTER TABLE `Auftrag` CHANGE `Auftrnr` `Auftrnr` INT(11) NOT NULL AUTO_INCREMENT; 
	ALTER TABLE Auftrag ADD UNIQUE (Auftrnr);	
	
	
	ALTER TABLE Auftrag ADD FOREIGN KEY (Kundnr) References Kunde (Kundnr) ;
	ALTER TABLE Auftrag ADD FOREIGN KEY (Persnr) references Personal (Persnr);
	
  
  
CREATE TABLE Auftragsposten(
	PosNr int,
	AuftrNr int NOT NULL,
	Anzahl int NOT NULL,
	Artnr int NOT NULL,
	Gesamtpreis int NOT NULL	 
);
	ALTER TABLE Auftragsposten ADD PRIMARY KEY (PosNr);
	ALTER TABLE `Auftragsposten` CHANGE `PosNr` `PosNr` INT(11) NOT NULL AUTO_INCREMENT; 
	ALTER TABLE Auftragsposten ADD UNIQUE (PosNr);		
	ALTER TABLE Auftragsposten ADD FOREIGN KEY (Auftrnr) References Auftrag (Auftrnr) ;
								
	ALTER TABLE Auftragsposten ADD COLUMN Einzelpreis Numeric (10,2) ;
	UPDATE Auftragsposten SET Einzelpreis = Gesamtpreis / Anzahl WHERE Anzahl IS NOT NULL AND Anzahl <> 0;
								
	CREATE VIEW VAuftragsPosten( PosNr, AuftrNr, Artnr, Anzahl, Einzelpreis, Gesamtpreis) 
	AS SELECT PosNr, AuftrNr, Artnr, Anzahl, Gesamtpreis/Anzahl, Gesamtpreis
	FROM Auftragsposten ;


CREATE TABLE Reservierung(
    Posnr int,
	AuftrNr int NOT NULL,
	Anzahl int NOT NULL
);

	ALTER TABLE Reservierung ADD PRIMARY KEY (Posnr);
	ALTER TABLE `Reservierung` CHANGE `Posnr` `Posnr` INT(11) NOT NULL AUTO_INCREMENT; 
	ALTER TABLE Reservierung ADD UNIQUE (Posnr);	
	ALTER TABLE Reservierung ADD FOREIGN KEY (AuftrNr) references Auftrag (AuftrNr);
	
SHOW TABLES;
SHOW DATABASES;

/*----------------------------------------------------------------------------------------------------------------------------------------------*/

/*ALL JOINS EXERCISES*/
select kunden.kuname,ausleihe.vinr 
from kunden 
inner join ausleihe 
on kunden.kunr=ausleihe.kunr;

select kunden.kuname,ausleihe.vinr 
from kunden 
left outer join ausleihe 
on kunden.kunr=ausleihe.kunr;

select kunden.kuname,ausleihe.vinr 
from kunden 
right outer join ausleihe 
on kunden.kunr=ausleihe.kunr;

select *
from kunden as k
FULL outer join ausleihe as a
on k.kunr=a.kunr;

select kunden.kunr,videos.vititel
from ausleihe
inner join kunden
on kunden.kunr=ausleihe.kunr
inner join videos
on videos.vinr=ausleihe.vinr
where kunden.kunr="5244" And videos.vititel like "%Berlin%";

select videos.vititel,videos.vinr
from videos
inner join ausleihe
on videos.vinr=ausleihe.vinr
where ausleihe.leirueck = "0000-00-00"
order by vinr;

select * 
from ausleihe
where leirueck = "0000-00-00";

select vinr,count(vinr)

from ausleihe
group by vinr
having count(vinr)>1;

select ausleihe.vinr,videos.vititel,count(ausleihe.vinr)
from ausleihe
inner join videos
on videos.vinr=ausleihe.vinr
group by vinr
having count(vinr)>1;

select count(ausleihe.vinr),videos.vititel
from videos
inner join ausleihe
on videos.vinr=ausleihe.vinr
group by vinr
having count(vinr)>1;

select ausleihe.vinr,videos.vititel,count(*) as Beste_Titel
from ausleihe
inner join videos
on ausleihe.vinr=videos.vinr
group by videos.vinr
order by Beste_Titel desc;

select ausleihe.kunr,kunden.kuname,count(ausleihe.kunr)
from ausleihe
inner join kunden
on ausleihe.kunr=kunden.kunr
group by ausleihe.kunr
having count(ausleihe.kunr)>1
order by count(ausleihe.kunr) desc;

select ausleihe.kunr,kunden.kuname,count(*) as Beste_Kunden
from kudnen
left join ausleihe
on ausleihe.kunr=kunden.kunr
group by kunden.kunr;

select kunden.kusex, kunden.kunr, kunden.kuname, kunden.kgebdat,videos.viart,videos.vititel 
from ausleihe 
inner join videos
on ausleihe.vinr=videos.vinr
inner join kunden
on ausleihe.kunr = kunden.kunr
where kunden.kusex = "m" and videos.viart like "%Liebe%"
order by kgebdat;

select videos.viart as Beliebte_Frauen_Kategorie,count(*) as Platze
from ausleihe
inner join videos
on ausleihe.vinr=videos.vinr
inner join kunden
on ausleihe.kunr=kunden.kunr
where kunden.kusex like "w"
group by Beliebte_Frauen_Kategorie
order by count(Beliebte_Frauen_Kategorie) desc;


/*School exercises*/

/*B*/
select count(ausleihe.vinr) as Anzahl from ausleihe;

/*F*/
select ausleihe.kunr as Kunden_Nummer,kunden.kuname as Namen,count(*) as Beste_Kunden
from ausleihe
inner join kunden
on ausleihe.kunr=kunden.kunr
group by kunden.kunr
order by Beste_Kunden desc;

/*J*/
select videos.viart as Beliebte_Frauen_Kategorie,count(*) as Platze
from ausleihe
inner join videos
on ausleihe.vinr=videos.vinr
inner join kunden
on ausleihe.kunr=kunden.kunr
where kunden.kusex like "w"
group by Beliebte_Frauen_Kategorie
order by count(Beliebte_Frauen_Kategorie) desc;

/*N*/
select kunden.kunr as Kunden_Nummer, kunden.kgebdat as Geburtstag,kunden.kuname as Name,videos.viart 
as VideoArt,videos.vititel as Videotitel
from ausleihe 
inner join videos
on ausleihe.vinr=videos.vinr
inner join kunden
on ausleihe.kunr = kunden.kunr
where kunden.kusex = "m" and videos.viart like "%Liebe%"
order by kgebdat;

select ausleihe.kunr,videos.vititel
from ausleihe
inner join videos
on ausleihe.vinr=videos.vinr
where kunr like "5244";

/*K*/
select kunden.kuname,ausleihe.vinr
from kunden
left join ausleihe
on ausleihe.kunr=kunden.kunr
where ausleihe.vinr IS NULL;


/*H*/
select videos.viart,count(*) as Ausgehlent
from ausleihe
inner join videos
on ausleihe.vinr=videos.vinr
group by viart
order by Ausgehlent desc;

select kunden.kuname,videos.vititel
from ausleihe
inner join kunden
on ausleihe.kunr=kunden.kunr
inner join videos
on ausleihe.vinr=videos.vinr;

/*I*/
select kunden.kusex as Sex,count(videos.viart) as Komedien
from ausleihe
inner join kunden
on ausleihe.kunr=kunden.kunr
inner join videos
on ausleihe.vinr=videos.vinr
where videos.viart like "Kom?dien"
group by kusex;

select videos.vititel, ausleihe.leiausda 
from ausleihe
inner join videos
on ausleihe.vinr=videos.vinr;

/*K*/
select kunden.kustras,kunden.kuplz,kunden.kuort,kunden.kuname,kunden.kunr,videos.viart
from ausleihe
inner join kunden
on ausleihe.kunr=kunden.kunr
inner join videos
on ausleihe.vinr=videos.vinr
where videos.viart like "Geschichte"
order by kunden.kunr;

/*M*/
select kunden.kunr,kunden.kuname,kunden.kuort,ausleihe.leiausda
from ausleihe
inner join kunden
on ausleihe.kunr=kunden.kunr
where ausleihe.leiausda BETWEEN "2006-01-01" and "2006-12-31";

/*L*/
select vititel,kuname,leiausda,leirueck
from ausleihes
left join kunden
on ausleihe.kunr=kunden.kunr
left join videos
on ausleihe.vinr=videos.vinr
where leirueck-leiausda>2
order by leiausda;

