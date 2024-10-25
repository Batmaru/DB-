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


-- 1. Qual è media e deviazione standard degli stipendi per ogni categoria di strutturati?
select posizione as strutturato, avg(stipendio) as media, stddev(stipendio) as deviazione_standard,
from Persona
group by posizione;

-- 2. Quali sono i ricercatori (tutti gli attributi) con uno stipendio superiore alla media
-- della loro categoria?
with Mediastipendio as (
    select avg(stipendio)as media
    from Persona
    where posizione = 'Ricercatore'
)

select *
from , Mediastipendio
where posizione = 'Ricercatore'
and stipendio > (Select media from Mediastipendio);

-- 3. Per ogni categoria di strutturati quante sono le persone con uno stipendio che
-- differisce di al massimo una deviazione standard dalla media della loro categoria?

with DeviazioneS as(
    select posizione, 
    avg(stipendio) as media, 
    stddev(stipendio) as dv
    from persona
    group by posizione
)

select p.posizione 
from Persona p, DeviazioneS s
where p.posizione=s.posizione
and p.stipendio between(s.media-s.dv)and(s.media+s.dv)
group by s.posizione

-- 4. Chi sono gli strutturati che hanno lavorato almeno 20 ore complessive in attività
-- progettuali? Restituire tutti i loro dati e il numero di ore lavorate.
with Ore as(
    select p.*
    sum(a.oreDurata) ad somma,
    from AttivitaProgetto a, Persona p
    where p.id=a.persona
    group by p.id, p.nome, p.cognome, p.posizione, p.stipendio
)

select *
from Ore
where somma>=20 and posizione in ('Ricercatore', 'Professore Associato', 'Professore Ordinario');

-- 5. Quali sono i progetti la cui durata è superiore alla media delle durate di tutti i
-- progetti? Restituire nome dei progetti e loro durata in giorni.
with Duratam as (
    select (total) as media
    from(
        select sum(oreDurata)as total
        from AttivitaProgetto
        group by progetto
    )as subquery
)

select p.nome, sum(att.oreDurata)/24.0 as durata_in_giorni
from Progetto p,  AttivitaProgetto att
where p.id=att.progetto
group by p.nome
having sum(att.oredurata)/24 > (select media from Duratam);


-- 6. Quali sono i progetti terminati in data odierna che hanno avuto attività di tipo
-- “Dimostrazione”? Restituire nome di ogni progetto e il numero complessivo delle
-- ore dedicate a tali attività nel progetto.

-- Step 1: Define the Common Table Expression (CTE)
with Durata as (
    select att.progetto, 
           sum(att.oreDurata) as oretotali
    from AttivitaProgetto att
    where att.tipo = 'Dimostrazione'
    group by att.progetto
)
select p.nome, d.oretotali
from Progetto p, Durata d
where p.id = d.progetto 
  and p.fine = CURRENT_DATE;


-- 7. Quali sono i professori ordinari che hanno fatto più assenze per malattia del nu-
-- mero di assenze medio per malattia dei professori associati? Restituire id, nome e
-- cognome del professore e il numero di giorni di assenza per malattia.

WITH MediaAssenze AS (
    SELECT AVG(total_assenze) AS media
    FROM (
        SELECT COUNT(*) AS total_assenze
        FROM Assenza
        WHERE persona IN (
            SELECT id FROM Persona WHERE posizione = 'Professore Associato'
        ) AND tipo = 'Malattia'
        GROUP BY persona
    ) a
),
with ProfessoriOrdinarie AS (
    SELECT 
        p.id, 
        p.nome, 
        p.cognome,
        COUNT(a.id) AS giorni_assenza  -- Count sick days for each ordinary professor
    FROM 
        Persona p, Assenza a  -- Using a cross product approach
    WHERE 
        p.posizione = 'Professore Ordinario' AND
        a.persona = p.id AND 
        a.tipo = 'Malattia'  -- Only sick days
    GROUP BY 
        p.id, p.nome, p.cognome
)

SELECT 
    id, 
    nome, 
    cognome, 
    giorni_assenza
FROM 
    ProfessoriOrdinarie
WHERE 
    giorni_assenza > (SELECT media FROM MediaAssenze);  -- Compare with average sick days


-- Spiegazione dei Componenti della Query

--     CTE MediaAssenze:
--         Calcola il numero medio di giorni di assenza per malattia presi dai professori associati.
--         La query interna conta il totale dei giorni di assenza per ogni professore associato e raggruppa i risultati per ID del professore.

--     CTE ProfessoriOrdinarie:
--         Conta il totale dei giorni di assenza per malattia per ogni professore ordinario utilizzando un approccio di prodotto cartesiano tra Persona e Assenza.
--         La clausola WHERE filtra i risultati per includere solo i professori ordinari e i giorni di assenza per malattia.
--         I risultati vengono raggruppati per ID, nome e cognome del professore.

--     Istruzione SELECT Finale:
--         Seleziona l'ID, il nome, il cognome e il totale dei giorni di assenza dalla CTE ProfessoriOrdinarie.
--         Filtra i risultati per mostrare solo quei professori ordinari il cui totale dei giorni di assenza supera la media calcolata nella CTE MediaAssenze.bu