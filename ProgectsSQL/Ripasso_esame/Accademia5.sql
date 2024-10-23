create type Strutturato as enum ('Ricercatore', 'Professore Associato', 'Professore Ordinario');
create type LavoroProgetto as enum ('Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');
create type LavoroNonProgettuale as enum ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro Accademico', 'Altro');
create type CauseAssenze as enum  ('Chiusura Universitaria', 'Maternita', 'Malattia');

create domain PosInteger as integer default 0 check (value >= 0);
create domain StringaM as varchar(100) default'';
create domain NumeroOre as integer default 0 check (value>=0 and value<=8);
create domain Denaro as real default 0 check (value>=0);

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
);

-- Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome ‘Pegasus’ ?
select wp.nome, wp.inizio,wp.fine
from WP as wp, Progetto as p
where p.nome = 'Pegasus'
    and wp.progetto = p.id;

-- Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?
select p.nome, p.cognome, p.posizione 
from AttivitaProgetto A, Persona p, progetto pr
where pr.nome='Pegasus' and A.persona=p.id
and pr.id=A.LavoroProgetto
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
    and a.tipo = 'Malattia';

--Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno fatto più di una assenza per malattia?
select p.nome, p.cognome, p.posizione
from Persona p, Assenza a1, Assenza a2
where p.posizione = 'Professore Ordinario'
    and p.id = a1.persona
    and p.id = a2.persona
    and a1.assenza = 'Malattia'
    and a2.assenza = 'Malattia'
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
    and a1.id<>a2.id;

--Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia attività progettuali che attività non progettuali?
select  p.nome, p.cognome
from Persona p, AttivitaNonProgettuale att, AttivitaProgetto a 
where att.persona=p.id
    and a.persona = p.id
    and att.giorno = a.giorno;


--Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
--attività progettuali che attività non progettuali? Si richiede anche di proiettare il
-- giorno, il nome del progetto, il tipo di attività non progettuali e la durata in ore di
-- entrambe le attività.

select  p.nome, p.cognome, pr.nome, a.giorno, att.tipo, a.oreDurata, att.oreDurata
from Persona p, AttivitaNonProgettuale att, AttivitaProgetto a, Progetto pr
where att.persona=p.id
    and a.persona = p.id
    and att.giorno = a.giorno
    and pr.id=a.progetto;


--Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
--assenti e hanno attività progettuali?

select p.nome, p.cognome
from Persona p, Assenza a, AttivitaProgetto att
where att.giorno=a.giorno
    and p.id=att.persona
    and a.persona=p.id;

--Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
--assenti e hanno attività progettuali? Si richiede anche di proiettare il giorno, il
--nome del progetto, la causa di assenza e la durata in ore della attività progettuale.
select p.nome, p.cognome, att.giorno, pr.nome, a.tipo, att.oreDurata
where Persone p, Assenza a,AttivitaProgetto att, Progetto pr
where att.giorno=a.giorno
    and p.id=att.persona
    and a.persona=p.id
    and pr.id=att.progetto;

--Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi?
select wp1.nome
from Wp wp1, Wp wp2
where wp1.nome=wp2.nome
    and wp1.progetto<>wp2.progetto