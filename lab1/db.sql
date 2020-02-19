
drop table if exists booking;
drop table if exists feedback;
drop table if exists include_service_number;
drop table if exists bilt_position;
drop table if exists contract;
drop table if exists bill;
drop table if exists fiz_person;
drop table if exists ur_person;
drop table if exists client;
drop table if exists room;
drop table if exists build;
drop table if exists disscount;
drop table if exists include_service;
drop table if exists optional_service;
drop table if exists status_booking;
drop table if exists worker;





CREATE TABLE Bill
( 
	id_bill              serial primary key,
	Ammount              money  NOT NULL 
);

CREATE TABLE Build
( 
	id_Build             serial primary key,
	Build_adress         varchar(45)  NOT NULL ,
	Prestige             integer  NOT NULL ,
	Build_number         integer  NOT NULL 
);

CREATE TABLE Client
( 
	id_client            serial primary key,
	Adress               varchar(45)  NOT NULL ,
	Phone_number         varchar(11)  NOT NULL 
);

CREATE TABLE Disscount
( 
	id_disscount         serial primary key,
	Disscount_name       varchar(64)  NOT NULL ,
	Diss_person          decimal  NULL ,
	Diss_legal           decimal  NULL 
);

CREATE TABLE FeedBack
( 
	id_feed_back         serial primary key,
	id_client            integer  references client(id_client),
	Mark                 integer  NULL ,
	Descroption          varchar(512)  NULL 
);

CREATE TABLE Fiz_person
( 
	id_client            integer references client(id_client),
	Surname              varchar(20)  NOT NULL ,
	Name                 varchar(20)  NOT NULL ,
	LastName             varchar(20)  NOT NULL ,
	Birth_date           timestamp  NOT NULL ,
	Passport             varchar(10)  NOT NULL 
);

CREATE TABLE Include_service
( 
	id_service           serial primary key,
	Service_name         varchar(64)  NOT NULL ,
	price                 money  NOT NULL 
);

CREATE TABLE Optional_service
( 
	id_option_service    serial primary key,
	option_service_name  varchar(64)  NOT NULL ,
	Option_cost          money  NOT NULL 
);

CREATE TABLE Room
( 
	id_room              serial primary key,
	Beds_count           integer  NOT NULL ,
	floor_lvl            integer  NOT NULL ,
	Room_number          integer  NOT NULL ,
	Room_cost            money  NOT NULL ,
	id_Build             integer  references build(id_build) 
);

CREATE TABLE Status_booking
( 
	Id_status            serial primary key,
	Name_status          varchar(64)  NOT NULL 
);

CREATE TABLE UR_Person
( 
	id_client            integer  references client(id_client),
	Personal__account    varchar(20)  NULL ,
	ITN                  varchar(20)  NOT NULL ,
	UPRLP                varchar(20)  NOT NULL ,
	Name_organization    varchar(64)  NOT NULL 
);

CREATE TABLE Worker
( 
	id_worker            serial primary key,
	Surname              varchar(20)  NOT NULL ,
	Forename             varchar(20)  NOT NULL ,
	Lastname             varchar(20)  NULL ,
	id_parent            integer  NOT NULL ,
	Employment_number    integer  NOT NULL ,
	Birth_date           timestamp NOT NULL ,
	Passport             varchar(10)  NOT NULL ,
	Address              varchar(64)  NOT NULL ,
	ITN                  varchar(64)  NOT NULL 
);

CREATE TABLE Bilt_position
( 
	Id_bilt_position     serial primary key,
	id_bill              integer  references  bill(id_bill) ,
	id_disscount         integer  references disscount(id_disscount) ,
	id_option_service    integer  references optional_service(id_option_service) ,
	Without_VAT          money  NOT NULL ,
	Without_disscount    money  NOT NULL 
);

CREATE TABLE Contract
( 
	Id_contract          serial primary key,
	Contract_number      integer  NOT NULL ,
	Start_date           timestamp  NOT NULL ,
	End_date             timestamp  NOT NULL ,
	id_client            integer  references client(id_client) ,
	id_bill              integer  references bill(id_bill),
	id_worker			 integer references worker(id_worker)
);

CREATE TABLE Include_service_number
( 
	id_service           serial references include_service(id_service),
	id_room              integer  references room(id_room) 
);

CREATE TABLE Booking
( 
	id_booking           serial primary key,
	Id_contract          integer  references contract(id_contract) ,
	Id_status            integer  references status_booking(id_status),
	Settlement_time      timestamp  NOT NULL ,
	Departure_time       timestamp  NOT NULL ,
	Booking_time         timestamp  NOT NULL ,
	id_room              integer  references room(id_room)
);

