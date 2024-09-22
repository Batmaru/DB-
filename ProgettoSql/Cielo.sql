CREATE DOMAIN PosInteger AS INTEGER CHECK (VALUE >= 0);
CREATE DOMAIN StringaM AS VARCHAR(100);
CREATE DOMAIN CodIATA AS CHAR(3);

CREATE TABLE Compagnia (
    nome StringaM PRIMARY KEY,
    annoFondaz PosInteger,
    tipo StringaM CHECK (tipo IN ('LowCost', 'Tradizionale', 'Charter'))
);

CREATE TABLE Aeroporto (
    codice CodIATA PRIMARY KEY,
    nome StringaM
);

CREATE TABLE LuogoAeroporto (
    aeroporto CodIATA,
    citta StringaM,
    nazione StringaM,
    PRIMARY KEY (aeroporto),
    FOREIGN KEY (aeroporto) REFERENCES Aeroporto(codice)
);

CREATE TABLE Volo (
    codice PosInteger,
    comp StringaM,
    durataMinuti PosInteger,
    PRIMARY KEY (codice, comp),
    FOREIGN KEY (comp) REFERENCES Compagnia(nome)
);

CREATE TABLE ArrPart (
    codice PosInteger,
    comp StringaM,
    arrivo CodIATA,
    partenza CodIATA,
    PRIMARY KEY (codice, comp),
    FOREIGN KEY (codice, comp) REFERENCES Volo(codice, comp),
    FOREIGN KEY (arrivo) REFERENCES Aeroporto(codice),
    FOREIGN KEY (partenza) REFERENCES Aeroporto(codice)
);

SELECT DISTINCT Volo.codice, Volo.comp
FROM Volo, ArrPart
WHERE Volo.codice = ArrPart.codice
  AND Volo.durataMinuti > 180;

SELECT DISTINCT Volo.comp
FROM Volo
WHERE Volo.durataMinuti > 180;

SELECT DISTINCT Volo.codice, Volo.comp
FROM Volo, ArrPart
WHERE Volo.codice = ArrPart.codice
  AND ArrPart.partenza = 'CIA';

SELECT DISTINCT Volo.comp
FROM Volo, ArrPart
WHERE Volo.codice = ArrPart.codice
  AND ArrPart.arrivo = 'FCO';

SELECT DISTINCT Volo.codice, Volo.comp
FROM Volo, ArrPart
WHERE Volo.codice = ArrPart.codice
  AND ArrPart.partenza = 'FCO' 
  AND ArrPart.arrivo = 'JFK';

SELECT DISTINCT Volo.comp
FROM Volo, ArrPart
WHERE Volo.codice = ArrPart.codice
  AND ArrPart.partenza = 'FCO' 
  AND ArrPart.arrivo = 'JFK';

SELECT DISTINCT Volo.comp
FROM Volo, ArrPart, LuogoAeroporto AS LA_Roma, LuogoAeroporto AS LA_NewYork
WHERE Volo.codice = ArrPart.codice
  AND ArrPart.partenza = LA_Roma.aeroporto
  AND ArrPart.arrivo = LA_NewYork.aeroporto
  AND LA_Roma.citta = 'Roma'
  AND LA_NewYork.citta = 'New York';

SELECT DISTINCT Aeroporto.codice, Aeroporto.nome, LuogoAeroporto.citta
FROM Aeroporto, ArrPart, Compagnia
WHERE Aeroporto.codice = ArrPart.partenza
  AND ArrPart.comp = 'MagicFly';

SELECT DISTINCT Volo.codice, Volo.comp, ArrPart.partenza, ArrPart.arrivo
FROM Volo, ArrPart, LuogoAeroporto AS LA_Roma, LuogoAeroporto AS LA_NewYork
WHERE Volo.codice = ArrPart.codice
  AND ArrPart.partenza = LA_Roma.aeroporto
  AND ArrPart.arrivo = LA_NewYork.aeroporto
  AND LA_Roma.citta = 'Roma'
  AND LA_NewYork.citta = 'New York';

SELECT Volo1.comp, Volo1.codice AS codice_volo_1, ArrPart1.partenza, ArrPart2.partenza AS scalo, Volo2.codice AS codice_volo_2, ArrPart2.arrivo
FROM Volo AS Volo1, ArrPart AS ArrPart1, Volo AS Volo2, ArrPart AS ArrPart2
WHERE Volo1.codice = ArrPart1.codice
  AND Volo2.codice = ArrPart2.codice
  AND ArrPart1.arrivo = ArrPart2.partenza
  AND ArrPart1.partenza IN (SELECT aeroporto FROM LuogoAeroporto WHERE citta = 'Roma')
  AND ArrPart2.arrivo IN (SELECT aeroporto FROM LuogoAeroporto WHERE citta = 'New York')
  AND Volo1.comp = Volo2.comp;

SELECT DISTINCT Volo.comp
FROM Volo, ArrPart, Compagnia
WHERE Volo.codice = ArrPart.codice
  AND ArrPart.partenza = 'FCO'
  AND ArrPart.arrivo = 'JFK'
  AND Compagnia.nome = Volo.comp
  AND Compagnia.annoFondaz IS NOT NULL;
