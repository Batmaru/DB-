CREATE DOMAIN Codfis as varchar(16)
check (value ~ '^[A-Za-z]{6}\d{2}[A-EHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$');

CREATE TYPE Direzione as enum('in', 'out')
create domain intero as integer(Check >0)

create table Socio(
cf Codfis not null,
nome Varchar(100) not null,
cognome Varchar(100) not null


primary key(cf)
);

create table Accesso(
    id integer not null,
    inizio date not null,
    direzione Direzione not null,
    socio Codfis not null,
    primary key(id),
    foreign key (socio) references Socio(cf)
);


create table Varco (
    codice integer not null,
    accesso integer not null,
    primary key (codice)
    foreign key (accesso) references Accesso(id)
);


create table Zona(
    nome varchar(100) not null,
    capienza intero not null,
    primary key (nome)
);