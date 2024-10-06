create domain indirizzodomain as varchar(100)
    check (value ~ '^[A-Za-z\s]+,\s*\d+,\s*\d{5}\s*[A-Za-z\s]+.*\([A-Za-z]{2}\)$');

create domain codicef as varchar(16)
    check (value ~ '^[A-Za-z]{6}\d{2}[A-EHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$');

create domain ntel as varchar(20) default ''
    check (value ~ '^\+?\d{1,3}\s?\d{1,4}\s?\d{4,10}$');
    
create domain stringa as varchar(100);


create table Nazione (
    nome stringa not null,
    primary key (nome)
);


create table Regione (
    nome stringa not null,
    nazione stringa not null,
    primary key (nome, nazione),
    foreign key (nazione) references Nazione(nome)
);


create table Citta (
    nome stringa not null,
    regione stringa not null,
    nazione stringa not null,
    primary key (nome, regione, nazione),
    foreign key (regione, nazione) references Regione(nome, nazione)
);

 
create table Persona (
    cf codicef not null,
    nome stringa not null,
    indirizzo indirizzodomain not null,
    telefono ntel not null,
    citta stringa not null,
    regione stringa not null,
    nazione stringa not null,
    primary key (cf),
    foreign key (citta, regione, nazione) references Citta(nome, regione, nazione)
);


create table Staff (
    persona codicef not null,
    foreign key (persona) references Persona(cf)
);

create table Direttore (
    nascita date not null,
    staff codicef not null,
    foreign key (staff) references Staff(persona)
);


create table Officina (
    nome stringa not null,
    indirizzo indirizzodomain not null,
    id integer not null,
    citta stringa not null,
    direttore codicef not null,
    primary key (id),
    foreign key (citta) references Citta(nome),
    foreign key (direttore) references Direttore(staff)
);

create table Riparazione (
    riconsegna timestamp not null,
    inizio timestamp not null,
    fine timestamp not null,
    codice integer not null,
    officina integer not null,
    primary key (codice),
    foreign key (officina) references Officina(id)
);


create table Dipendente (
    staff codicef not null,
    assunzione date not null,
    foreign key (staff) references Staff(persona)
);

 
create table Cliente (
    persona codicef not null,
    foreign key (persona) references Persona(cf)
);

create table Marca (
    nome stringa not null,
    primary key (nome)
);

create table Tipoveicolo (
    nome stringa not null,
    primary key (nome)
);

create table Modello (
    nome stringa not null,
    marca_nome stringa not null,
    tipo_veicolo stringa not null,
    primary key (nome, marca_nome, tipo_veicolo),
    foreign key (marca_nome) references Marca(nome),
    foreign key (tipo_veicolo) references Tipoveicolo(nome)
);


create table Veicolo (
    targa stringa not null,
    immatricolazione int not null,
    modello_nome stringa not null,
    tipo_veicolo stringa not null,
    marca stringa not null,
    primary key (targa, modello_nome, tipo_veicolo, marca),
    foreign key (modello_nome, tipo_veicolo, marca) references Modello(nome, marca_nome, tipo_veicolo)
);
