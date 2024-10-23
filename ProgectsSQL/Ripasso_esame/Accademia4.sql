
-- Creazione di tipi enum per le posizioni e le attività
create type Strutturato as enum ('Ricercatore', 'Professore Associato', 'Professore Ordinario');
-- Questo tipo enum definisce i vari ruoli accademici che una persona può avere.

create type LavoroProgetto as enum ('Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');
-- Tipo enum per le diverse tipologie di lavoro progettuale.

create type LavoroNonProgettuale as enum ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro Accademico', 'Altro');
-- Tipo enum per le diverse attività non progettuali.

create type CauseAssenze as enum ('Chiusura Universitaria', 'Maternita', 'Malattia');
-- Tipo enum per le diverse cause di assenza.

-- Creazione di domini per variabili di tipo specifico
create domain PosInteger as integer default 0 check (value >= 0);
-- Dominio che definisce un intero positivo, con valore di default 0. Il vincolo CHECK garantisce che il valore sia maggiore o uguale a 0.

create domain StringaM as varchar(100) default '';
-- Dominio per stringhe di massimo 100 caratteri, con valore di default vuoto.

create domain NumeroOre as integer default 0 check (value >= 0 and value <= 0);
-- Dominio per numeri interi che rappresentano ore, con vincolo CHECK. Attenzione: l'intervallo sembra errato (>= 0 e <= 0) significa solo 0.

create domain Denaro as real default 0 check (value >= 0);
-- Dominio per valori monetari, che deve essere maggiore o uguale a 0.

-- Creazione della tabella Persona
create table Persona(
    id PosInteger not null, -- Identificativo univoco per la persona
    nome StringaM not null, -- Nome della persona
    cognome StringaM not null, -- Cognome della persona
    posizione Strutturato not null, -- Ruolo della persona, utilizzando il tipo enum
    stipendio Denaro not null, -- Stipendio della persona
    primary key(id) -- Chiave primaria, garantisce unicità per ogni record
);
-- La tabella "Persona" memorizza i dettagli del personale accademico. Operazioni come l'inserimento, l'aggiornamento o l'eliminazione di record possono essere eseguite per gestire i dati delle persone in modo efficace.

-- Creazione della tabella Progetto
create table Progetto(
    id PosInteger not null, -- Identificativo univoco per il progetto
    nome StringaM not null, -- Nome del progetto
    inizio date not null, -- Data di inizio del progetto
    fine date not null, -- Data di fine del progetto
    budget Denaro not null, -- Budget del progetto
    primary key(id), -- Chiave primaria
    unique (nome), -- Nome del progetto deve essere unico
    check(inizio < fine) -- Verifica che la data di inizio sia prima della data di fine
);
-- La tabella "Progetto" memorizza le informazioni sui progetti. Le query possono essere utilizzate per filtrare progetti attivi, progetti terminati o per analizzare i budget.

-- Creazione della tabella WP (Work Package)
create table WP(
    progetto PosInteger not null, -- Riferimento al progetto
    id PosInteger not null, -- Identificativo univoco per il WP
    nome StringaM not null, -- Nome del WP
    inizio date not null, -- Data di inizio del WP
    fine date not null, -- Data di fine del WP
    primary key(id), -- Chiave primaria
    unique(progetto, nome), -- Combinazione unica di progetto e nome
    foreign key progetto references Progetto(id) -- Riferimento alla tabella Progetto
);
-- La tabella "WP" permette di gestire le attività specifiche di ciascun progetto. È utile per monitorare il progresso e la gestione delle risorse.

-- Creazione della tabella AttivitaProgetto
create table AttivitaProgetto(
    id PosInteger not null, 
    persona PosInteger not null, -- Riferimento alla persona che ha svolto l'attività
    progetto PosInteger not null, -- Riferimento al progetto
    wp PosInteger not null, -- Riferimento al WP
    giorno date not null, -- Data dell'attività
    tipo LavoroProgetto not null, -- Tipo di attività, utilizzando il tipo enum
    oreDurata NumeroOre not null, -- Ore di durata dell'attività
    primary key(id), -- Chiave primaria
    foreign key (persona) references Persona(id), -- Riferimento alla tabella Persona
    foreign key (progetto, wp) references WP(progetto, id) -- Riferimento alla tabella WP
);
-- La tabella "AttivitaProgetto" registra le attività svolte da ciascun membro del personale nei progetti. Analizzando queste informazioni, è possibile valutare l'impatto delle attività sui risultati del progetto.

-- Creazione della tabella AttivitaNonProgettuale
create table AttivitaNonProgettuale (
    id PosInteger not null,
    persona PosInteger not null, -- Riferimento alla persona
    tipo LavoroNonProgettuale not null, -- Tipo di attività non progettuale
    giorno date not null, -- Data dell'attività
    oreDurata NumeroOre not null, -- Ore di durata
    primary key (id), -- Chiave primaria
    foreign key (persona) references Persona(id) -- Riferimento alla tabella Persona
);
-- La tabella "AttivitaNonProgettuale" permette di registrare attività che non sono legate a progetti specifici. È utile per la pianificazione delle risorse e per comprendere il carico di lavoro complessivo.

-- Creazione della tabella Assenza
create table Assenza(
    id PosInteger not null,
    persona PosInteger not null, -- Riferimento alla persona
    tipo CauseAssenze not null, -- Tipo di assenza
    giorno date not null, -- Data dell'assenza
    primary key (id), -- Chiave primaria
    foreign key (persona) references Persona(id) -- Riferimento alla tabella Persona
);
-- La tabella "Assenza" consente di monitorare le assenze del personale. Questa informazione è fondamentale per la gestione delle risorse e per la pianificazione del lavoro.

-- 1. Quali sono i cognomi distinti di tutti gli strutturati?
--    - Questa query seleziona solo i cognomi dalla tabella Persona, utilizzando "distinct" per ottenere solo valori unici (non ripetuti).
select distinct cognome
from Persona;

-- 2. Quali sono i Ricercatori (con nome e cognome)?
--    - Selezioniamo i campi nome e cognome dalla tabella Persona, filtrando i risultati per mostrare solo quelli in cui il campo posizione è "Ricercatore".
select p.nome, cognome
from Persona
where posizione='Ricercatore';

-- 3. Quali sono i Professori Associati il cui cognome comincia con la lettera ‘V’?
--    - Selezioniamo solo il cognome dalla tabella Persona, filtrando per includere solo i professori associati e per mostrare solo i cognomi che iniziano con "V".
select cognome
from Persona
where posizione = 'Professore Associato'
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
from Progetto
order by inizio asc;

-- 7. Quali sono i nomi dei WP ordinati in ordine crescente (per nome)?
--    - Selezioniamo il nome dalla tabella WP e ordiniamo i risultati in ordine crescente per nome.
select nome
from WP
order by nome asc;

-- 8. Quali sono (distinte) le cause di assenza di tutti gli strutturati?
--    - Selezioniamo le cause di ass
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
