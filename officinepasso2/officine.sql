create domain stringa as varchar(100) ;
create domain indirizzodomain as varchar(100);
create domain codicef as varchar(100);
create domain ntel as varchar(20) default '';

create table Nazione(
    nome stringa not null,
    primary key(nome)
);

create table Regione(
    nome stringa not null,
    nazione stringa not null,
    primary key (nome, nazione),
    foreign key nazione references nazione(nome)
);

create table Città(
    nome stringa not null,
    regione stringa not null,
    nazione stringa not null,
    primary key (nome, regione, nazione)
    foreign key (regione, nazione) references  Regione(nome, nazione)
);

create table Persona(
    cf codicef not null,
    nome stringa not null;
    indirizzo indirizzodomain not null;
    telefono ntel not null,
    citta stringa not null,
    regione  stringa not null,
    nazione stringa not null,
    primary key (cf)
    foreign key (citta, regione, nazione) references Città(nome, regione, nazione)
);

create table Staff(
    persona stringa not null,
    foreign key (persona) references Persona(cf)
);

create table Direttore(
    nascita date not null,
    staff stringa not null,
    foreign key staff references Staff(persona)  
);

create table Officina(
    nome stringa not null,
    indirizzo indirizzodomain not null,
    id integer not null,
    citta stringa not null,
    direttore stringa not null,
    primary key (id),
    foreign key (citta) references Città(nome),
    foreign key (direttore) references Direttore(staff)
);

create table riparazione(
    riconsegna timestamp  not null,
    inizio timestamp  not null,
    fine timestamp not null,
    codice integer not null,
    officina stringa not null,,
    primary key (codice),
    foreign key officina references Officina(id)

)