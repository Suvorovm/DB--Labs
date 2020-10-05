drop table if exists feedback;
drop table if exists Service_for_room;
drop table if exists Client_booking;
drop table if exists Bilt_position_service;
drop table if exists service_for_room;
drop table if exists service;
drop table if exists booking;
drop table if exists contract;
drop table if exists bilt_position;
drop table if exists bill;
drop table if exists fiz_person;
drop table if exists ur_person;
drop table if exists client;
drop table if exists disscount;
drop table if exists status_booking;
drop table if exists type_booking;
drop table if exists worker;
drop table if exists room;
drop table if exists build;


CREATE TABLE Bill
( 
	id_bill              serial primary key,
	ammount              money  NOT NULL 
);

CREATE TABLE Build
( 
	id_Build             serial primary key,
	build_adress         varchar(45)  NOT NULL ,
	prestige             integer  NOT NULL ,
	build_number         integer  NOT NULL 
);

CREATE TABLE Client
( 
	id_client            serial primary key,
	adress               varchar(256)  NOT NULL ,
	phone_number         varchar(11)  NOT NULL 
);

CREATE TABLE Disscount
( 
	id_disscount         serial primary key,
	disscount_name       varchar(64)  NOT NULL ,
	diss_person          decimal  NULL ,
	diss_legal           decimal  NULL 
);

CREATE TABLE FeedBack
( 
	id_feed_back         serial primary key,
	id_client            integer  references client(id_client),
	mark                 integer  NULL ,
	descroption          varchar(512)  NULL 
);


CREATE TABLE UR_Person
( 	
	id_client            integer unique  references client(id_client),
	itn                  varchar(20)  NOT NULL ,
	name_organization    varchar(64)  NOT NULL 
);


CREATE TABLE Fiz_person
( 
	id_fiz				serial primary key,
	id_client            integer references client(id_client),
	surname              varchar(20)  NOT NULL ,
	forename             varchar(20)  NOT NULL ,
	lastName             varchar(20)  NOT NULL ,
	birth_date           timestamp  NOT NULL ,
	passport             varchar(10)  NOT null,
	id_ur_person integer references Ur_person(id_client)
);





CREATE TABLE service
( 
	id_service    serial primary key,
	service_name  varchar(64)  NOT NULL ,
	service_cost          money  NOT NULL 
);

CREATE TABLE Room
( 
	id_room              serial primary key,
	beds_count           integer  NOT NULL ,
	floor_lvl            integer  NOT NULL ,
	room_number          integer  NOT NULL ,
	room_cost            money  NOT NULL ,
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


CREATE TABLE Worker
( 
	id_worker            serial primary key,
	surname              varchar(20)  NOT NULL ,
	sorename             varchar(20)  NOT NULL ,
	lastname             varchar(20)  NULL ,
	id_parent            integer  references worker(id_worker),
	employment_number    integer  NOT NULL ,
	birth_date           timestamp NOT NULL ,
	passport             varchar(10)  NOT NULL ,
	address              varchar(64)  NOT NULL ,
	itn                  varchar(64)  NOT NULL ,
	sallary				 integer not null
);

CREATE TABLE Bilt_position
( 
	id_bilt_position     serial primary key,
	id_bill              integer  references  bill(id_bill) ,
	id_disscount         integer  references disscount(id_disscount) ,
	without_VAT          money  NOT NULL ,
	id_room              integer references room(id_room),
	without_disscount    money  NOT null,
	with_discount        money not null
);

CREATE TABLE Contract
( 
	Id_contract          serial primary key,
	contract_number      integer  NOT NULL ,
	start_date           timestamp  NOT NULL ,
	end_date             timestamp  NOT NULL ,
	id_client            integer  references client(id_client) ,
	id_bill              integer  references bill(id_bill),
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

create table Client_booking(
	id_client integer references client(id_client),
	id_booking integer references booking(id_booking)
);

create table Bilt_position_service(
	id_bilt_position integer references bilt_position(id_bilt_position),
	id_service integer references service(id_service)
);

create table Service_for_room(
	id_room integer references room(id_room),
	id_service integer references service(id_service)
);

select * from status_booking;

drop table if exists feedback;
drop table if exists Service_for_room;
drop table if exists Client_booking;
drop table if exists Bilt_position_service;
drop table if exists service_for_room;
drop table if exists service;
select * from booking;
drop table if exists contract;
drop table if exists bilt_position;
drop table if exists bill;
drop table if exists fiz_person;
drop table if exists ur_person;
drop table if exists client;
drop table if exists disscount;
select * from status_booking;
drop table if exists type_booking;
select * from  worker;
drop table if exists room;
drop table if exists build;

