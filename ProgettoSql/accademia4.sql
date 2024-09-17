CREATE TYPE Strutturato AS ENUM ('Ricercatore', 'Professore Associato', 'Professore Ordinario');
CREATE TYPE LavoroProgetto AS ENUM ('Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');
CREATE TYPE LavoroNonProgettuale AS ENUM ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro Accademico', 'Altro');
CREATE TYPE CausaAssenza AS ENUM ('Chiusura Universitaria', 'Maternita', 'Malattia');

CREATE DOMAIN PosInteger AS INTEGER DEFAULT 0 CHECK (VALUE >= 0);
CREATE DOMAIN StringaM AS VARCHAR(100) DEFAULT '';
CREATE DOMAIN NumeroOre AS INTEGER DEFAULT 0 CHECK (VALUE >= 0 AND VALUE <= 8);
CREATE DOMAIN Denaro AS REAL DEFAULT 0 CHECK (VALUE >= 0);

CREATE TABLE Persona(
    id PosInteger NOT NULL,
    nome StringaM NOT NULL,
    cognome StringaM NOT NULL,
    posizione Strutturato NOT NULL,
    stipendio Denaro NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Progetto(
    id PosInteger NOT NULL,
    nome StringaM NOT NULL,
    inizio DATE NOT NULL,
    fine DATE NOT NULL,
    budget Denaro NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (nome),
    CHECK (inizio < fine)
);

CREATE TABLE WP(
    progetto PosInteger NOT NULL,
    id PosInteger NOT NULL,
    nome StringaM NOT NULL,
    inizio DATE NOT NULL,
    fine DATE NOT NULL,
    PRIMARY KEY (progetto, id),
    UNIQUE (progetto, nome),
    CHECK (inizio < fine),
    FOREIGN KEY (progetto) REFERENCES Progetto(id)
);

CREATE TABLE AttivitaProgetto(
    id PosInteger NOT NULL,
    persona PosInteger NOT NULL,
    progetto PosInteger NOT NULL,  
    wp PosInteger NOT NULL,
    giorno DATE NOT NULL,
    tipo LavoroProgetto NOT NULL,
    oreDurata NumeroOre NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (persona) REFERENCES Persona(id),
    FOREIGN KEY (progetto, wp) REFERENCES WP(progetto, id)
);

CREATE TABLE AttivitaNonProgettuale (
    id PosInteger NOT NULL,
    persona PosInteger NOT NULL,
    tipo LavoroNonProgettuale NOT NULL,
    giorno DATE NOT NULL,
    oreDurata NumeroOre NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (persona) REFERENCES Persona(id)
);

CREATE TABLE Assenza (
    id PosInteger NOT NULL,
    persona PosInteger NOT NULL,
    tipo CausaAssenza NOT NULL,
    giorno DATE NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (persona, giorno),
    FOREIGN KEY (persona) REFERENCES Persona(id)
);

SELECT DISTINCT cognome
FROM Persona;

SELECT nome, cognome
FROM Persona
WHERE posizione = 'Ricercatore';

SELECT cognome
FROM Persona
WHERE posizione= 'Professore Associato' AND UPPER(cognome) LIKE 'V%';

SELECT cognome
FROM Persona
WHERE (posizione = 'Professore Associato' OR posizione='Professore Ordinario') AND UPPER(cognome) LIKE 'V%';

SELECT nome
FROM Progetto
WHERE fine <= NOW();

SELECT nome
FROM Progetto
ORDER BY inizio ASC;


SELECT nome
FROM WP
ORDER BY nome ASC;


SELECT DISTINCT tipo
FROM Assenza;

SELECT DISTINCT tipo
FROM AttivitaProgetto;


SELECT DISTINCT giorno
FROM AttivitaNonProgettuale
WHERE tipo = 'Didattica'
ORDER BY giorno ASC;
