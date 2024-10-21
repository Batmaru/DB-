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

SELECT WP.nome, WP.inizio, WP.fine
FROM WP as wp, Progetto as p
WHERE p.nome = 'Pegasus'
    and wp.progetto = p.id;

SELECT DISTINCT Persona.nome, Persona.cognome, Persona.posizione
FROM Progetto as pr, AttivitaProgetto as a, Persona as p
where p.id = a.persona AND pr.nome='Pegasus' 
ORDER BY Persona.cognome DESC;

SELECT DISTINCT  Persona.nome, Persona.cognome, Persona.posizione
FROM Persona as p, AttivitaProgetto as a1, AttivitaProgetto as a2, Progetto as pr
WHERE pr.nome = 'Pegasus' 
AND a1.progetto = pr.id 
AND a2.progetto = pr.id 
AND a1.persona = p.id 
AND a2.persona = p.id
AND a1.id <> a2.id;

SELECT DISTINCT Persona.nome, Persona.cognome, Persona.posizione
FROM Persona as p, Assenza as a
WHERE p.posizione = 'Professore Ordinario'
AND p.id = a.persona
AND a.tipo = 'Malattia';


SELECT DISTINCT Persona.nome, Persona.cognome, Persona.posizione
From Persona as p, Assenza as A1, Assenza as A2
WHERE p.posizione = 'Professore Ordinario'
AND A1.Persona=p.id
AND A2.Persona=p.id
AND A1.tipo = 'Malattia'
AND A2.tipo = 'Malattia'
AND A1.id <> A2.id;

SELECT DISTINCT Persona.nome, Persona.cognome, Persona.posizione
FROM Persona, AttivitaNonProgettuale as A
Where A.persona = persona.id
AND A.tipo='Didattica'
AND Persona.posizione = 'Ricercatore';

SELECT DISTINCT p.nome, p.cognome, p.posizione
FROM Persona as p, AttivitaNonProgettuale as A1, AttivitaNonProgettuale as A2
WHERE A1.persona = p.id
AND A2.persona = p.id
AND A1.tipo = 'Didattica'
AND A2.tipo = 'Didattica'
AND A1.id <> A2.id;

SELECT DISTINCT p.nome, p.cognome
FROM Persona as p, AttivitaProgetto as ap, AttivitaNonProgettuale as anp
WHERE ap.persona = p.id
AND anp.persona = p.id
AND ap.giorno = anp.giorno;

SELECT DISTINCT p.nome, p.cognome, ap.giorno, pr.nome AS nome_progetto, anp.tipo AS tipo_attivita_non_progettuale, ap.oreDurata AS durata_attivita_progettuale, anp.oreDurata AS durata_attivita_non_progettuale
FROM Persona as p, AttivitaProgetto as ap, AttivitaNonProgettuale as anp, Progetto as pr
WHERE ap.persona = p.id
AND anp.persona = p.id
AND ap.giorno = anp.giorno
AND ap.progetto = pr.id;

SELECT DISTINCT p.nome, p.cognome
FROM Persona as p, AttivitaProgetto as ap, Assenza as a
WHERE ap.persona = p.id
AND a.persona = p.id
AND ap.giorno = a.giorno;

SELECT DISTINCT p.nome, p.cognome, ap.giorno, pr.nome AS nome_progetto, a.tipo AS causa_assenza, ap.oreDurata AS durata_attivita_progettuale
FROM Persona as p, AttivitaProgetto as ap, Assenza as a, Progetto as pr
WHERE ap.persona = p.id
AND a.persona = p.id
AND ap.giorno = a.giorno
AND ap.progetto = pr.id;

SELECT wp1.nome
FROM WP as wp1, WP as wp2
WHERE wp1.nome = wp2.nome
AND wp1.progetto <> wp2.progetto;

