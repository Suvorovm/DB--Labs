
CREATE TABLE Bill
( 
	id_bill              integer  NOT NULL ,
	Ammount              money  NOT NULL 
)
go



ALTER TABLE Bill
	ADD CONSTRAINT XPKBill PRIMARY KEY  CLUSTERED (id_bill ASC)
go



CREATE TABLE Bilt_position
( 
	Id_bilt_position     integer IDENTITY ( 1,1 ) ,
	id_bill              integer  NOT NULL ,
	id_disscount         integer  NOT NULL ,
	id_option_service    integer  NOT NULL ,
	Without_VAT          money  NOT NULL ,
	Without_disscount    money  NOT NULL 
)
go



ALTER TABLE Bilt_position
	ADD CONSTRAINT XPKBilt_position PRIMARY KEY  CLUSTERED (Id_bilt_position ASC)
go



CREATE TABLE Booking
( 
	id_booking           integer IDENTITY ( 1,1 ) ,
	Id_contract          integer  NOT NULL ,
	Id_status            integer  NOT NULL ,
	Settlement_time      datetime  NOT NULL ,
	Departure_time       datetime  NOT NULL ,
	Booking_time         datetime  NOT NULL ,
	id_room              integer  NOT NULL 
)
go



ALTER TABLE Booking
	ADD CONSTRAINT XPKBooking PRIMARY KEY  CLUSTERED (id_booking ASC)
go



CREATE TABLE Build
( 
	id_Build             integer IDENTITY ( 1,1 ) ,
	Build_adress         varchar(max)  NOT NULL ,
	Prestige             integer  NOT NULL ,
	Build_number         integer  NOT NULL 
)
go



ALTER TABLE Build
	ADD CONSTRAINT XPKBuild PRIMARY KEY  CLUSTERED (id_Build ASC)
go



CREATE TABLE Client
( 
	id_client            integer IDENTITY ( 1,1 ) ,
	Adress               varchar(20)  NOT NULL ,
	Phone_number         varchar(20)  NOT NULL 
)
go



ALTER TABLE Client
	ADD CONSTRAINT XPKClient PRIMARY KEY  CLUSTERED (id_client ASC)
go



CREATE TABLE Contract
( 
	Id_contract          integer IDENTITY ( 1,1 ) ,
	Contract_number      integer  NOT NULL ,
	Start_date           datetime  NOT NULL ,
	End_date             datetime  NOT NULL ,
	id_client            integer  NOT NULL ,
	id_bill              integer  NOT NULL 
)
go



ALTER TABLE Contract
	ADD CONSTRAINT XPKContract PRIMARY KEY  CLUSTERED (Id_contract ASC)
go



CREATE TABLE Disscount
( 
	id_disscount         integer IDENTITY ( 1,1 ) ,
	Disscount_name       varchar(20)  NOT NULL ,
	Diss_person          decimal  NULL ,
	Diss_legal           decimal  NULL 
)
go



ALTER TABLE Disscount
	ADD CONSTRAINT XPKDisscount PRIMARY KEY  CLUSTERED (id_disscount ASC)
go



CREATE TABLE FeedBack
( 
	id_feed_back         integer IDENTITY ( 1,1 ) ,
	id_client            integer  NULL ,
	Mark                 integer  NULL ,
	Descroption          varchar(20)  NULL 
)
go



ALTER TABLE FeedBack
	ADD CONSTRAINT XPKFeedBack PRIMARY KEY  CLUSTERED (id_feed_back ASC)
go



CREATE TABLE Fiz_person
( 
	id_client            integer IDENTITY ( 1,1 ) ,
	Surname              varchar(20)  NOT NULL ,
	Name                 varchar(20)  NOT NULL ,
	LastName             varchar(20)  NOT NULL ,
	Birth_date           datetime  NOT NULL ,
	Passport             varchar(20)  NOT NULL 
)
go



ALTER TABLE Fiz_person
	ADD CONSTRAINT XPKFiz_person PRIMARY KEY  CLUSTERED (id_client ASC)
go



CREATE TABLE Include_service
( 
	id_service           integer IDENTITY ( 1,1 ) ,
	Service_name         varchar(20)  NOT NULL ,
	Cost                 money  NOT NULL 
)
go



ALTER TABLE Include_service
	ADD CONSTRAINT XPKInclude_service PRIMARY KEY  CLUSTERED (id_service ASC)
go



CREATE TABLE Include_service_number
( 
	id_service           integer  NOT NULL ,
	id_room              integer  NOT NULL 
)
go



ALTER TABLE Include_service_number
	ADD CONSTRAINT XPKInclude_service_number PRIMARY KEY  CLUSTERED (id_service ASC,id_room ASC)
go



CREATE TABLE Optional_service
( 
	id_option_service    integer IDENTITY ( 1,1 ) ,
	option_service_name  varchar(20)  NOT NULL ,
	Option_cost          money  NOT NULL 
)
go



ALTER TABLE Optional_service
	ADD CONSTRAINT XPKOptional_service PRIMARY KEY  CLUSTERED (id_option_service ASC)
go



CREATE TABLE Room
( 
	id_room              integer  NOT NULL ,
	Beds_count           integer  NOT NULL ,
	Floor                integer  NOT NULL ,
	Room_number          integer  NOT NULL ,
	Room_cost            money  NOT NULL ,
	id_Build             integer  NOT NULL 
)
go



ALTER TABLE Room
	ADD CONSTRAINT XPKRoom PRIMARY KEY  CLUSTERED (id_room ASC)
go



CREATE TABLE Status_booking
( 
	Id_status            integer IDENTITY ( 1,1 ) ,
	Name_status          varchar(20)  NOT NULL 
)
go



ALTER TABLE Status_booking
	ADD CONSTRAINT XPKStatus_booking PRIMARY KEY  CLUSTERED (Id_status ASC)
go



CREATE TABLE UR_Person
( 
	id_client            integer  NOT NULL ,
	Personal__account    varchar(20)  NULL ,
	ITN                  varchar(20)  NOT NULL ,
	Copy_UPRLP           int  NOT NULL ,
	UPRLP                varchar(20)  NOT NULL ,
	Name_organization    varchar(20)  NOT NULL 
)
go



ALTER TABLE UR_Person
	ADD CONSTRAINT XPKUR_Person PRIMARY KEY  CLUSTERED (id_client ASC)
go



CREATE TABLE Worker
( 
	id_worker            integer IDENTITY ( 1,1 ) ,
	Surname              varchar(20)  NOT NULL ,
	Name                 varchar(20)  NOT NULL ,
	Lastname             varchar(max)  NULL ,
	id_parent            integer  NOT NULL ,
	Employment_number    integer  NOT NULL ,
	Birth_date           datetime  NOT NULL ,
	Sallary              money  NOT NULL ,
	Passport             varchar(20)  NOT NULL ,
	Address              varchar(20)  NOT NULL ,
	ITN                  varchar(20)  NOT NULL 
)
go



ALTER TABLE Worker
	ADD CONSTRAINT XPKWorker PRIMARY KEY  CLUSTERED (id_worker ASC)
go




ALTER TABLE Bilt_position
	ADD CONSTRAINT R_4 FOREIGN KEY (id_disscount) REFERENCES Disscount(id_disscount)

go




ALTER TABLE Bilt_position
	ADD CONSTRAINT R_5 FOREIGN KEY (id_option_service) REFERENCES Optional_service(id_option_service)
go




ALTER TABLE Bilt_position
	ADD CONSTRAINT R_7 FOREIGN KEY (id_bill) REFERENCES Bill(id_bill)
go




ALTER TABLE Booking
	ADD CONSTRAINT R_18 FOREIGN KEY (Id_contract) REFERENCES Contract(Id_contract)
go




ALTER TABLE Booking
	ADD CONSTRAINT R_24 FOREIGN KEY (Id_status) REFERENCES Status_booking(Id_status)
go




ALTER TABLE Booking
	ADD CONSTRAINT R_26 FOREIGN KEY (id_room) REFERENCES Room(id_room)
go




ALTER TABLE Contract WITH CHECK 
	ADD CONSTRAINT R_10 FOREIGN KEY (id_client) REFERENCES Client(id_client)
go




ALTER TABLE Contract
	ADD CONSTRAINT R_33 FOREIGN KEY (id_bill) REFERENCES Bill(id_bill)
go




ALTER TABLE FeedBack
	ADD CONSTRAINT R_16 FOREIGN KEY (id_client) REFERENCES Client(id_client)

go




ALTER TABLE Fiz_person
	ADD CONSTRAINT is_a FOREIGN KEY (id_client) REFERENCES Client(id_client)
go




ALTER TABLE Include_service_number
	ADD CONSTRAINT R_28 FOREIGN KEY (id_service) REFERENCES Include_service(id_service)
go




ALTER TABLE Include_service_number
	ADD CONSTRAINT R_18_9 FOREIGN KEY (id_room) REFERENCES Room(id_room)
go




ALTER TABLE Room
	ADD CONSTRAINT R_29 FOREIGN KEY (id_Build) REFERENCES Build(id_Build)
go


go

ALTER TABLE UR_Person
	ADD CONSTRAINT R_20_1 FOREIGN KEY (id_client) REFERENCES Client(id_client)
	go


ALTER TABLE Worker
	ADD CONSTRAINT R_30 FOREIGN KEY (id_worker) REFERENCES Worker(id_worker)

go

