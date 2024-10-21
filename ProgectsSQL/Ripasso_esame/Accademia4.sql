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


--Quali sono i cognomi distinti di tutti gli strutturati?
select distinct cognome
from Persona;

--Quali sono i Ricercatori (con nome e cognome)?
select nome,cognome
from Persona
where posizione='Ricercatore'

--Quali sono i Professori Associati il cui cognome comincia con la lettera ‘V’?
select cognome
from Persona
where  posizione = 'Professore Associato'
and UPPER(cognome) like 'V%';

--Quali sono i Professori (sia Associati che Ordinari) il cui cognome comincia con la lettera ‘V’ 
select cognome
from Persona
where (posizione = 'Professore Associato' OR posizione='Professore Ordinario')
and upper(cognome) like 'V%';

--Quali sono i Progetti già terminati alla data odierna?
select nome
from Progetto
where fine <= now();

--Quali sono i nomi di tutti i Progetti ordinati in ordine crescente di data di inizio?
select nome
from progetto
order by inizio asc;

--Quali sono i nomi dei WP ordinati in ordine crescente (per nome)?
select nome
from WP
order by nome asc;

--Quali sono (distinte) le cause di assenza di tutti gli strutturati?
select distinct tipo
from Assenza;

--Quali sono (distinte) le tipologie di attività di progetto di tutti gli strutturati?
select distinct tipo
from AttivitaProgetto;

--Quali sono i giorni distinti nei quali del personale ha effettuato attività non progettuali di tipo ‘Didattica’ ? Dare il risultato in ordine crescente.
select distinct giorno
from AttivitaNonProgettuale
where tipo='Didattica'
order by giorno asc;