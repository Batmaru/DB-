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

-- Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome ‘Pegasus’ ?
select WP.nome,posizione, fine
from WP as wp, Progetto as p
where p.nome = 'Pegasus'
    and wp.progetto = p.id;

-- Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?
select p.nome, p.cognome, p.posizione 
from AttivitaProgetto A, Persona p, progetto pr
where pr.nome='Pegasus' and A.persona=p.id
order by p.cognome DESC;

--  Quali sono il nome, il cognome e la posizione degli strutturati che hanno più di una attività nel progetto ‘Pegasus’ ?
select p.nome, p.cognome, p.posizione
from Progetto pr, Persona p, AttivitaProgetto a1, AttivitaProgetto a2
where pr.nome='Pegasus' 
    and a1.progetto=pr.id
    and a2.progetto=pr.id
    and a1.persona=p.id
    and a2.persona=p.id
    and a1.id<>a2.id;

--Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno fatto almeno una assenza per malattia?

select p.nome, p.cognome, p.posizione
from Persona p, Assenza a
where p.posizione = 'Professore Ordinario'
    and p.id = a.Persona
    and a.assenza = 'Malattia';

--Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno fatto più di una assenza per malattia?
select p.nome, p.cognome, p.posizione
from Persona p, Assenza a1, Assenza a2
where p.posizione = 'Professore Ordinario'
    and p.id = a1.persona
    and p.id = a1.persona
    and a.assenza = 'Malattia'
    and a1.id<>a2.id;

--Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno almeno un impegno per didattica?

select p.nome, p.cognome, p.posizione
from Persona p, AttivitaNonProgettuale a
where a.tipo='Didattica'
and a.persona  = p.id
and p.posizione = 'Ricercatore';

--Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno più di un impegno per didattica?
 select p.nome, p.cognome, p.posizione
 from Persona p, AttivitaNonProgettuale a1, AttivitaNonProgettuale a2
 where a1.tipo='Didattica'
    and a2.tipo='Didattica'
    and p.posizione = 'Ricercatore';
    and a1.persona  = p.id
    and a2.persona = p.id
    and a1.id<>a2.id

--Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia attività progettuali che attività non progettuali?
