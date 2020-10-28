

CREATE TABLE "Booking"

(



"booking_id"          serial primary key,

"time_booking"        DATE ,

"quarter_id"          CHAR(18) ,

"id_status_booking"   INTEGER ,

"room_id"             INTEGER

).







CREATE TABLE "Build"

(



"build_id"            serial primary key,

"prestige"            INTEGER

).







CREATE TABLE "Category"

(



"category_id"         serial primary key,

"name"                CHARACTER(20) ,

"bed_count"           INTEGER

).







CREATE TABLE "client"

(



"client_id"           serial primary key,

"name"                CHARACTER(20) ,

"last_name"           CHARACTER(20) ,

"patronymic"          CHARACTER(20) ,

"entity_id"           INTEGER

).







CREATE TABLE "Entity"

(



"name_entity"         CHARACTER(20) ,

"entity_id"           serial primary key

).







CREATE TABLE "HalfYear"

(



"half_year_id"        serial primary key,

"half_year"           CHARACTER(20) ,

"year_id"             INTEGER

).







CREATE TABLE "Quarter"

(



"half_year_id"        INTEGER ,

"quarter_id"          serial primary key,

"quarter_name"        CHARACTER(20)

).







CREATE TABLE "Room"

(



"room_id"             serial primary key,

"cost"                INTEGER ,

"name_room"           CHARACTER(20)

).







CREATE TABLE "Sale_fact"

(



"sale_id"             serial primary key,

"sum"                 INTEGER ,

"date"                DATE NOT NULL ,

"sum_with_out_nds"    INTEGER ,

"build_id"            CHAR(18) ,

"category_id"         INTEGER ,

"staff_id"            CHARACTER(20) ,

"quarter_id"          CHAR(18) ,

"room_id"             INTEGER ,

"client_id"           INTEGER

).







CREATE TABLE "Service_fact"

(

"service_fact_id"    serial primary key,

"quarter_id"          CHAR(18) ,

"sum_cost"            INTEGER NOT NULL ,

"cost_with_out_nds"   CHAR(18) ,

"date_buy"            DATE ,

"type_service_id"     INTEGER ,

"client_id"           INTEGER

).







CREATE TABLE "Staff"

(



"staff_id"            serial primary key,

"name"                CHARACTER(20) ,

"last_name"           CHARACTER(20) ,

"patronymic"          CHARACTER(20)

).







CREATE TABLE "Status_booking"

(



"id_status_booking"   serial primary key,

"name_booking"        CHARACTER(20)

).







CREATE TABLE "Type_service"

(



"type_service_id"     serial primary key,

"name_service"        CHARACTER(20)

).







CREATE TABLE "Year"

(



"year_id"             serial primary key,

"year_name"           CHARACTER(20)

).