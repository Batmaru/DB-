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



-- 1. Quanti sono gli strutturati di ogni fascia?
select posizione, count(*) as numero
    from persona
    group by posizione;


-- 2. Quanti sono gli strutturati con stipendio ≥ 40000?
select count(*) as numero
    from persona
    where stipendio>=40000;
    
-- 3. Quanti sono i progetti già finiti che superano il budget di 50000?
select count(*) as numero
    from Progetto
    where budget>=50000;


-- 4. Qual è la media, il massimo e il minimo delle ore delle attività relative al progetto
-- ‘Pegasus’ ?
select avg(oreDurata) as media, max(oreDurata) as massimo, min(oreDurata)
from Progetto p, AttivitaProgetto att
    where att.progetto=p.id
    and p.nome='Pegasus';


-- 5. Quali sono le medie, i massimi e i minimi delle ore giornaliere dedicate al progetto
-- ‘Pegasus’ da ogni singolo docente?
select pe.nome, pe.cognome, avg(oreDurata) as media, max(oreDurata) as massimo, min(oreDurata)
    from Progetto p, AttivitaProgetto att, persona pe
    where att.progetto=p.id
    and p.nome='Pegasus'
    and att.persona = pe.id
    group by pe.nome, pe.cognome;

-- 6. Qual è il numero totale di ore dedicate alla didattica da ogni docente?
select pe.nome, pe.cognome, sum(*) as ore_totali
    from AttivitaNonProgettuale att, pe.persona
    where pe.id=att.id
    and att.tipo='Didattica'
    group by pe.nome, p.cognome;

-- 7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?
select avg(stipendio) as media, max(stipendio) as massimo, min(stipendio) as minimo
    from Persona p
    where p.posizione='Ricercatore';
    
-- 8. Quali sono le medie, i massimi e i minimi degli stipendi dei ricercatori, dei professori
-- associati e dei professori ordinari?
select posizione, avg(stipendio) as media, max(stipendio) as massimo, min(stipendio) as minimo
from persona
where posizione in ('Ricercatore', 'Professore Associato', 'Professore Ordinario')
group by posizione;

-- 9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?
select p.nome, pr.nome, sum(ore.oredurata) as totale_ore
from persona p, progetto pr, AttivitaProgetto att
where p.nome = 'Ginevra'
and p.cognome= 'Riva'
and pr.id = att.progetto
and p.id=att.persona
group by pr.nome


-- 10. Qual è il nome dei progetti su cui lavorano più di due strutturati?
select pr.nome
from Progetto pr, AttivitaProgetto att, Persona p
where att.progetto = pr.id
and att.persona = p.id
group by pr.nome
having count(distinct p.id) > 2;

-- 11. Quali sono i professori associati che hanno lavorato su più di un progetto
select p.nome
from Persona p, AttivitaProgetto att, progetto pr
where p.id= att.persona
and att.progetto= pr.id
and p.posizione='Professore Associato'
group by p.id, p.nome
having count(distinct pr.id) >1