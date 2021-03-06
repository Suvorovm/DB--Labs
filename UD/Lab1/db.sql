
drop table if exists feedback cascade;

drop table if exists fiz_person cascade;

drop table if exists ur_person cascade;

drop table if exists client_booking cascade;

drop table if exists booking cascade;

drop table if exists status_booking cascade;

drop table if exists type_booking cascade;

drop table if exists contract cascade;

drop table if exists client cascade;

drop table if exists worker cascade;

drop table if exists bilt_position_service cascade;

drop table if exists bilt_position cascade;

drop table if exists bill cascade;

drop table if exists disscount cascade;

drop table if exists service_for_room cascade;

drop table if exists service cascade;

drop table if exists room cascade;

drop table if exists build cascade;

drop table if exists category_room cascade;


drop table if exists status_contract cascade;

drop table if exists occupied_client cascade;




CREATE TABLE Worker
(
	id_worker            serial primary key,
	surname              varchar(20)  NOT NULL ,
	name                 varchar(20)  NOT NULL ,
	lastname             varchar(20)  NULL ,
	id_parent            integer  references worker(id_worker),
	employment_number    integer  NOT NULL ,
	birth_date           timestamp NOT NULL ,
	passport             varchar(10)  NOT NULL ,
	address              varchar(128)  NOT NULL ,
	itn                  varchar(64)  NOT NULL
);

CREATE TABLE Build
(
	id_build             serial primary key,
	build_adress         varchar(45)  NOT NULL ,
	prestige             integer  NOT NULL
);

CREATE TABLE Category_room
(
    id_category_room    serial primary key,
    name                varchar(64) not null,
    beds_count          integer not null
);

CREATE TABLE Room
(
	id_room              serial primary key,
	id_category_room     integer references  Category_room(id_category_room),
	floor_lvl            integer  NOT NULL ,
	room_number          integer  NOT NULL ,
	room_cost            float  NOT NULL ,
	id_Build             integer  references build(id_build)
);

CREATE TABLE Type_booking
(
	id_type_booking            serial primary key,
	name_type          varchar(64)  NOT NULL
);
CREATE TABLE Status_booking
(
	id_status            serial primary key,
	id_type_booking integer references type_booking(id_type_booking),
	time_operation timestamp
);

CREATE TABLE UR_Person
(
	id_ur_person         serial primary key,
	itn                  varchar(20)  NOT NULL ,
	name_organization    varchar(64)  NOT NULL
);

CREATE TABLE Client
(
	id_client            serial primary key,
	adress               varchar(256)  NOT NULL ,
	phone_number         varchar(11)  NOT NULL,
	surname              varchar(20)  NOT NULL ,
	name                varchar(20)  NOT NULL ,
	lastName             varchar(20) ,
	birth_date           timestamp  NOT NULL ,
	passport             varchar(10)  NOT null,
	itn                   varchar(20)  NOT NULL ,
	id_ur_person          integer references Ur_person(id_ur_person)
);

CREATE TABLE FeedBack
(
	id_feed_back         serial primary key,
	id_client            integer  references client(id_client),
	mark                 integer  NULL ,
	descroption          varchar(512)  NULL
);

CREATE TABLE Status_contract
(
    id_status_contract  serial primary key,
    name                varchar(64) not null
);

CREATE TABLE Contract
(
	Id_contract          serial primary key,
	contract_number      integer  NOT NULL ,
	start_date           timestamp  NOT NULL ,
	end_date             timestamp  NOT NULL ,
	amount               float default(0),
	id_status_contract   integer references  Status_contract(id_status_contract),
	id_client            integer  references client(id_client) ,
	id_worker			 integer references worker(id_worker)
);

CREATE TABLE Booking
(
	id_booking           serial primary key,
	id_contract          integer  references contract(id_contract) ,
	id_status            integer  references status_booking(id_status),
	settlement_time      timestamp  NOT NULL ,
	departure_time       timestamp  NOT NULL ,
	booking_time         timestamp  NOT NULL ,
	id_room              integer  references room(id_room)
);

CREATE TABLE Occupied_client
(
    id_client integer references Client(id_client),
    id_booking integer references Booking(id_booking)
);

CREATE TABLE Disscount
(
	id_disscount         serial primary key,
	disscount_name       varchar(64)  NOT NULL ,
	diss_person          decimal  NULL ,
	diss_legal           decimal  NULL
);


CREATE TABLE Service
(
	id_service    serial primary key,
	service_name  varchar(64)  NOT NULL ,
	service_cost   float  NOT NULL
);

create table Service_for_room(
	id_room integer references room(id_room),
	id_service integer references service(id_service)
);

CREATE TABLE Bilt_position
(
	id_bilt_position     serial primary key,
	id_contract          integer references Contract(Id_contract),
	id_disscount         integer  references disscount(id_disscount) ,
	id_room              integer references room(id_room),
	id_service           integer references service(id_service),
	with_discount        float not null
);
