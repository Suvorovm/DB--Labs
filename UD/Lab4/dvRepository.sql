/*Needs to create repo_hotel sheame*/


drop table if exists repo_hotel.booking cascade;

drop table if exists repo_hotel.status_booking cascade;

drop table if exists repo_hotel.sale_fact cascade;

drop table if exists repo_hotel.staff cascade;

drop table if exists repo_hotel.room cascade;

drop table if exists repo_hotel.build cascade;

drop table if exists repo_hotel.category cascade;

drop table if exists repo_hotel.service_fact cascade;

drop table if exists repo_hotel.quarter cascade;

drop table if exists repo_hotel.halfyear cascade;

drop table if exists repo_hotel.year cascade;

drop table if exists repo_hotel.client cascade;

drop table if exists repo_hotel.entity cascade;

drop table if exists repo_hotel.type_service cascade;




CREATE TABLE Year

(


    year_id   serial primary key,

    year_name CHARACTER(20)
);
CREATE TABLE Status_booking

(


    id_status_booking serial primary key,

    name_booking      CHARACTER(20)

);




CREATE TABLE HalfYear

(


    half_year_id serial primary key,

    half_year    VARCHAR(255) NOT NULL,

    year_id      INTEGER REFERENCES  Year

);



CREATE TABLE Quarter

(

    quarter_id   serial primary key,

    half_year_id INTEGER REFERENCES HalfYear,

    quarter_name VARCHAR(255) NOT NULL

);

CREATE TABLE Build

(


    build_id serial primary key,

    prestige INTEGER

);

CREATE TABLE Category

(


    category_id serial primary key,

    name        VARCHAR(255) NOT NULL,

    bed_count   INTEGER

);

CREATE TABLE Entity

(


    name_entity VARCHAR(255) NOT NULL,

    entity_id   serial primary key

);



CREATE TABLE client

(


    client_id  serial primary key,

    name       VARCHAR(255) NOT NULL,

    last_name  VARCHAR(255) NOT NULL,

    patronymic VARCHAR(255) NOT NULL,
    passport   varchar(12) NOT NULL,

    entity_id  INTEGER REFERENCES Entity

);


CREATE TABLE Room

(


    room_id     serial primary key,

    cost        INTEGER,

    name_room   VARCHAR(255) NOT NULL,

    build_id    INTEGER REFERENCES Build,

    category_id INTEGER REFERENCES Category

);




CREATE TABLE Booking

(


    booking_id        serial primary key,

    quarter_id        INTEGER REFERENCES Quarter,

    id_status_booking INTEGER REFERENCES Status_booking,

    room_id           INTEGER REFERENCES Room,

    count_booking     INTEGER,

    client_id         INTEGER REFERENCES client

);









CREATE TABLE Staff

(


    staff_id   serial primary key,

    name       VARCHAR(255) NOT NULL,

    last_name  VARCHAR(255) NOT NULL,

    patronymic VARCHAR(255) NOT NULL

);



CREATE TABLE Type_service

(


    type_service_id serial primary key,

    name_service    varchar(255)

);








CREATE TABLE Sale_fact

(


    sale_id          serial primary key,

    sum              FLOAT,

    sum_with_out_nds FLOAT,

    staff_id         INTEGER REFERENCES  Staff,

    quarter_id       INTEGER REFERENCES  Quarter,

    room_id          INTEGER REFERENCES Room,

    client_id        INTEGER REFERENCES  client

);



CREATE TABLE Service_fact

(


    quarter_id        integer REFERENCES  Quarter,

    sum_cost          FLOAT,

    cost_with_out_nds FLOAT,

    type_service_id   INTEGER REFERENCES  Type_service,

    client_id         INTEGER REFERENCES  client,

    sale_fact_id      serial primary key

);

