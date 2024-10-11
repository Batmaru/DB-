
create domain reale_01 as real
    check (value >= 0 and value <= 1);

create domain voto as integer
    check (value >= 0 and value <= 5);

create domain url as varchar(1000)
    check (value ~ '^https?://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$');

create type popolarita as enum 
    ('bassa', 'media', 'alta');

create domain integerGEZ as integer
    check (value >= 0);

create domain realGEZ as real
    check (value >= 0);

create domain realGZ as real
    check (value > 0);

create type cond_usato as enum
    ('ottimo', 'buono', 'discreto', 'da sistemare'); 

create table Utente (
    id integerGEZ not null,
    nome varchar(100) not null, 
    affidabilita reale_01,
    primary key (id)
);

create table Privato (
    id integerGEZ not null,
    utente_id integerGEZ not null unique,
    primary key (id),
    foreign key (utente_id) references Utente(id)
);

create table Venditore_prof (
    id integerGEZ not null,
    vetrina url,
    popolarita popolarita not null,
    utente_id integerGEZ not null unique,
    primary key (id),
    foreign key (utente_id) references Utente(id)
);

create table Categoria (
    nome varchar(100) not null,
    super_categoria varchar(100),
    primary key (nome),
    foreign key (super_categoria) references Categoria(nome)
);

create table Metodo_pagamento (
    nome varchar(100) not null,
    primary key (nome)
);

create table Valuta (
    codice varchar(100),
    nome varchar(100) not null,  
    primary key (nome)
);

create table Post (
    id integerGEZ not null,
    descrizione text,
    pubblicazione timestamp not null,
    anni_garanzia integerGEZ,
    prezzo realGEZ not null,
    ha_feedback boolean,
    voto voto,
    commento text,
    nuovo boolean,
    condizioni cond_usato,
    categoria varchar(100),
    metodopagamento varchar(100),
    valuta varchar(100) not null,
    primary key (id),
    foreign key (categoria) references Categoria(nome),
    foreign key (metodopagamento) references Metodo_pagamento(nome),
    foreign key (valuta) references Valuta(codice)
);

create table Bid (
    id integerGEZ not null,
    istante timestamp not null,
    prezzo realGEZ not null,
    acquirente integerGEZ not null,
    post_asta integerGEZ not null,
    primary key (id),
    foreign key (acquirente) references Utente(id),
    foreign key (post_asta) references PostAsta(id)
);

create table PostAsta (
    id integerGEZ not null,
    rialzo realGZ,
    scadenza timestamp not null,
    conclusa boolean,
    bid_aggiudicatario integerGEZ,
    post integerGEZ not null,
    primary key (id),
    foreign key (bid_aggiudicatario) references Bid(id),
    foreign key (post) references Post(id)
);

create table Post_compra_subito (
    id integerGEZ not null,
    post integerGEZ not null,
    primary key (id),
    foreign key (post) references Post(id)
);
