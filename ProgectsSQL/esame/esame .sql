--1. Qual è il numero di progetti a cui partecipa ogni
--professore ordinario. Per ogni professore ordinari restituire nome, cognome, numero di progetti nei quali è
--coinvolto

select p.nome, p.cognome, count(distinct pr.id) as numero_progetti
from Persona p, AttivitaProgetto att, progetto pr
where  p.id= att.persona
and att.progetto=pr.id
and p.posizione= 'Professore Ordinario'
group by p.nome, p.cognome;

-- --2. Qual è il numero medio di ore delle attività progettuali
-- svolte da ogni ricercatore. Per ogni ricercatore, restituire
-- nome, cognome e numero medio di ore delle sue attività
-- progettuali (in qualsivoglia progetto) 
select p.nome, p.cognome, avg(att.oreDurata) as media_ore
from Persona p, AttivitaProgetto att
where p.id=att.persona
and p.posizione = 'Ricercatore'
group by p.nome, p.cognome;

--3. Quali sono le persone con stipendio di almeno 60000 euro
select p.nome, p.cognome
    from persona p
    where p.stipendio>=60000;
    


-- --4. Qual è il budget totale dei progetti a cui lavora ogni
-- professore associato. Per ogni professore associato
-- restituire nome, cognome e budget totale dei progetti nei
-- quali è coinvolto. [3 punti]
select p.nome, p.cognome, sum(pr.budget) as totale_budget
from Persona p, Progetto pr, AttivitaProgetto att
where pr.id=att.progetto
    and att.progetto=pr.id
    and p.posizione= 'Professore Associato'
    group by p.nome, p.cognome;

-- 5 Qual è il numero totale di giorni di assenza per maternità
-- di ogni ricercatore. Per ogni ricercatore, restituire nume,
-- cognome e numero di giorni di assenza per maternità 
select p.nome, p.cognome, count(a.giorno) as giorni_assenza
from Persona p, Assenza a 
where p.id=a.persona
and p.posizione= 'Ricercatore'
and  a.tipo= 'Maternita'
group by p.nome, p.cognome;


--6. Qual è il budget medio dei progetti nel db [2 punti]

select avg(pr.budget) as budget_medio
from Progetto pr;

--7 Qual è il numero totale di ore, per ogni persona, dedicate
-- al progetto con id ‘3’. Per ogni persona che lavora al
-- progetto, restituire nome, cognome e numero di ore totali
-- dedicate ad attività progettuali relative al progetto

select p.nome, p.cognome, sum(att.oreDurata) as totale_ore
from Persona p, AttivitaProgetto att, Progetto pr
where p.id =att.persona
and att.progetto=pr.id
and pr.id=3
group by p.nome, p.cognome;


-- 8 Quali sono i professori ordinari che hanno svolto attività
-- nel WP di id ‘3’ del progetto con id ‘4’. Per ogni professore
-- ordinario, restituire il numero totale di ore svolte in
-- attività progettuali per il WP in questione [4 punti]

select p.nome, p.cognome, sum(att.oreDurata) as totale_ore
from Persona p, AttivitaProgetto att, Progetto pr
where p.id = att.persona
and att.progetto= pr.id
and pr.id=4
and att.wp=3
and p.posizione='Professore Ordinario'
group by p.nome, p.cognome;

-- 9 Quali sono i professori ordinari che lavorano ad almeno un
-- progetto e hanno uno stipendio di almeno 60000 [2 punti]
select p.nome, p.cognome
from Persona p, AttivitaProgetto att
where p.id=att.persona
and p.posizione='Professore Ordinario'
and p.stipendio>=60000
group by p.nome, p.cognome;

-- 10. Qual è la durata media in ore delle attività didattiche
-- svolte da ogni persona. Per ogni persona che ha svolto
-- attività didattica, restituire nome, cognome e numero
-- medio di ore delle sue singole attività didattiche 

select p.nome, p.cognome, avg(att.oreDurata) as media_ore
from persona p, AttivitaNonProgettuale att
where p.id= att.persona
and att.tipo= 'Didattica'
group by p.nome, p.cognome;


