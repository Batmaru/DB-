create type Strutturato as enum ('Ricercatore', 'Professore Associato', 'Professore Ordinario');
create type LavoroProgetto as enum ('Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');
create type LavoroNonProgettuale as enum ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro Accademico', 'Altro');
create type CauseAssenze as enum  ('Chiusura Universitaria', 'Maternita', 'Malattia');

create domain PosInteger as integer default 0 check (value >= 0);
create domain StringaM as varchar(100) default'';
create domain NumeroOre as integer default 0 check (value>=0 and value<=0)
create domain Denaro as real default 0 check (value>=0)

create table Persona(
    id PosInteger not null,
    nome StringaM not null,
    cognome StringaM not null,
    posizione Strutturato not null,
    stipendio Denaro not null,
    primary key(id)
);

create table Progetto(
    id PosInteger not null,
    nome StringaM not null,
    inizio date not null,
    fine date not null,
    budget Denaro not null,
    primary key(id),
    unique (nome),
    check(inizio<fine)
);

create table WP(
    progetto PosInteger not null,
    id PosInteger not null,
    nome StringaM not null,
    inizio date not null,
    fine date not null,
    primary key(id),
    unique(progetto,nome),
    foreign key progetto references Progetto(id)
);

create table AttivitaProgetto(
    id PosInteger not null, 
    persona PosInteger not null, 
    progetto PosInteger not null,
    wp PosInteger not null,
    giorno date not null, 
    tipo LavoroProgetto not null, 
    oreDurata NumeroOre not null,
    primary key(id),
    foreign key (persona) references Persona(id),
    foreign key (progetto,wp) references WP(progetto,id) 
);

create table AttivitaNonProgettuale (
    id PosInteger not null,
    persona PosInteger not null, 
    tipo LavoroNonProgettuale not null, 
    giorno date not null, 
    oreDurata NumeroOre not null,
    primary key (id),
    foreign key (persona) references Persona(id)
    );

create table Assenza(
    id PosInteger not null,
    persona PosInteger not null,
    tipo CausaAssenza not null,
    giorno date not null,
    primary key (id),
    foreign key (persona) references Persona(id)
),


-- 1. Quali sono i cognomi distinti di tutti gli strutturati?
--    - Questa query seleziona solo i cognomi dalla tabella Persona, utilizzando "distinct" per ottenere solo valori unici (non ripetuti).

select distinct cognome
from Persona;


-- 2. Quali sono i Ricercatori (con nome e cognome)?
--    - Selezioniamo i campi nome e cognome dalla tabella Persona, filtrando i risultati per mostrare solo quelli in cui il campo posizione è "Ricercatore".

select nome,cognome
from Persona
where posizione='Ricercatore'

-- 3. Quali sono i Professori Associati il cui cognome comincia con la lettera ‘V’?
--    - Selezioniamo solo il cognome dalla tabella Persona, filtrando per includere solo i professori associati e per mostrare solo i cognomi che iniziano con "V", utilizzando "UPPER" per ignorare le maiuscole.

select cognome
from Persona
where  posizione = 'Professore Associato'
and UPPER(cognome) like 'V%';


-- 4. Quali sono i Professori (sia Associati che Ordinari) il cui cognome comincia con la lettera ‘V’?
--    - Selezioniamo il cognome dalla tabella Persona, filtrando per includere sia i professori associati che ordinari e per mostrare solo i cognomi che iniziano con "V".

select cognome
from Persona
where (posizione = 'Professore Associato' OR posizione='Professore Ordinario')
and upper(cognome) like 'V%';



-- 5. Quali sono i Progetti già terminati alla data odierna?
--    - Selezioniamo il nome dalla tabella Progetto, filtrando i progetti in cui la data di fine è minore o uguale alla data attuale.

select nome
from Progetto
where fine <= now();



-- 6. Quali sono i nomi di tutti i Progetti ordinati in ordine crescente di data di inizio?
--    - Selezioniamo il nome dalla tabella Progetto e ordiniamo i risultati in base alla data di inizio in ordine crescente.

select nome
from progetto
order by inizio asc;


-- 7. Quali sono i nomi dei WP ordinati in ordine crescente (per nome)?
--    - Selezioniamo il nome dalla tabella WP e ordiniamo i risultati in ordine crescente per nome.

select nome
from WP
order by nome asc;



-- 8. Quali sono (distinte) le cause di assenza di tutti gli strutturati?
--    - Selezioniamo le cause di assenza dalla tabella Assenza, utilizzando "distinct" per ottenere solo valori unici.

select distinct tipo
from Assenza;



-- 9. Quali sono (distinte) le tipologie di attività di progetto di tutti gli strutturati?
--    - Selezioniamo le tipologie di attività dalla tabella AttivitaProgetto, utilizzando "distinct" per ottenere solo valori unici.

select distinct tipo
from AttivitaProgetto;

-- 10. Quali sono i giorni distinti nei quali il personale ha effettuato attività non progettuali di tipo ‘Didattica’?
--     - Selezioniamo i giorni dalla tabella AttivitaNonProgettuale in cui il tipo è "Didattica", ordinando i risultati in ordine crescente.
select distinct giorno
from AttivitaNonProgettuale
where tipo='Didattica'
order by giorno asc;
