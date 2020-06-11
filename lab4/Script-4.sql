/*Не давать пользователю ввести две одинаковые услуги
При попытки изменить имя услуги на уже существующее откатывать транзакцию*/

CREATE OR REPLACE FUNCTION add_service() RETURNS TRIGGER AS $body$
DECLARE
    mstr varchar(30);
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF exists(select service_name from service where service_name = NEW.service_name) then
            RAISE EXCEPTION 'Запись уже сущесвтует';
        end if;
        INSERT INTO service( service_name, service_cost)  values (new.service_name, new.service_cost);
        return  new;
    ELSIF TG_OP = 'UPDATE' THEN
            if new.service_name <> old.service_name THEN
                IF exists(select service_name from service where service_name = NEW.service_name) then
                    RAISE EXCEPTION 'Невозмжно навазать имя услуги таким образом';
                 end if;
            end if;
            update service  set  service_name = new.service_name,
                                service_cost = new.service_cost
            where id_service = new.id_service;
            return new;
    END IF;

END;
$body$ LANGUAGE plpgsql;


CREATE TRIGGER t_service
INSTEAD OF INSERT or UPDATE  ON SERVICES_VIEW FOR EACH ROW EXECUTE PROCEDURE add_service();

create view  target audience as
SELECT
COUNT(CASE WHEN  Age(birth_date) < interval '18 years' THEN 1 END) AS "<18",
COUNT(CASE WHEN  Age(birth_date) > interval '19 years' AND Age(birth_date) < interval '25 years'  THEN 1 END) AS "19-25",
COUNT(CASE WHEN  Age(birth_date) > interval '26 years' AND Age(birth_date) < interval '39 years'  THEN 1 END) AS "26-39",
COUNT(CASE WHEN  Age(birth_date) > interval '40 years' AND Age(birth_date) < interval '65 years'  THEN 1 END) AS "40-65",
COUNT(CASE WHEN  Age(birth_date) > interval '65 years' THEN 1 END) ">65"
FROM Fiz_person


CREATE VIEW SERVICES_VIEW AS
        select * from service;


select * from SERVICES_VIEW;


INSERT INTO SERVICES_VIEW(service_name, service_cost)  values('Пин-понг', '360');

UPDATE SERVICES_VIEW set service_cost = 1000
    where id_service = 25;
--######################################################################################
/*После добавления комнаты добавить туда набор включенных услуг  10 и 6*/

CREATE OR REPLACE FUNCTION insert_room() RETURNS TRIGGER AS $body$
DECLARE
      mstr varchar(30);
BEGIN
    insert into service_for_room(id_room, id_service) VALUES (new.id_room, 6);
      insert into service_for_room(id_room, id_service)values (new.id_room, 10);
    return new;
END;
$body$ LANGUAGE plpgsql;

CREATE TRIGGER t_add_room
AFTER  INSERT  ON room FOR EACH ROW EXECUTE PROCEDURE insert_room();

select  * from service;
select * from  service_for_room;

select * from disscount;


select * from room
    order by id_room;

insert into room(beds_count, floor_lvl, room_number, room_cost, id_build) VALUES
    (2,4,513,17000,1);

select service_for_room.id_room, id_service, room.room_number from service_for_room
    inner join room on service_for_room.id_room = room.id_room
where service_for_room.id_room = 189

--########################################################################3   
--Добавление купленных номеров в счет (триггер)   

create or replace function room_in_bill() RETURNS TRIGGER AS $body$
	declare
		cost_room money;
		bill_id int;
		bilt_position_id integer;
		is_fiz_person  bool;
		is_check integer;
	begin
		
		select into bill_id id_bill
			from contract
			inner join booking on booking.id_contract = contract.id_contract
				where booking.id_contract = new.id_contract;
			
		select into is_check client.id_client from contract
			inner join bill on bill.id_bill = contract.id_bill
			inner join client on client.id_client = contract.id_client
			inner join fiz_person on fiz_person.id_client = client.id_client
			where bill.id_bill = bill_id;
		
		if( is_check is NULL) then
		  	is_fiz_person = false;
		  else
		  	is_fiz_person = true;
		  end if;
			
		select into cost_room room_cost
			from room
				where room.id_room = new.id_room;	
		insert into bilt_position(id_bill,id_disscount,without_vat,without_disscount, id_room)
			values(bill_id,7,cost_room,cost_room,new.id_room) 
		returning id_bilt_position into bilt_position_id;
	perform update_cost_bilt_position(NEW.id_room,0,7,is_fiz_person,bilt_position_id);
	return NULL;
	end
$body$ LANGUAGE plpgsql;

create trigger add_room_bill
after insert on booking for each row execute procedure room_in_bill();
---Функция для бронирования номера
select booking_room('15.05.2020','11.06.2020',513,4,2);




--########################################################################

--Не заселять в номер человека, если там не осталось спальных мест
create or replace function fullnes_room() RETURNS TRIGGER AS $body$
	declare
		count_person int;
		room_size int;
	begin
		
		select into room_size beds_count
		from client_booking
		inner join booking on booking.id_booking = client_booking.id_booking
		inner join  room on room.id_room = booking.id_booking
		where client_booking.id_booking = new.id_booking;
		
		raise log 'room_size - %', room_size;
	
		select into count_person count(id_client)
		from client_booking
		where id_booking = new.id_booking;
		
		raise log 'count_person - %', count_person;
	
		if(count_person > room_size) then
			raise log 'Номер заполнен';
		return null;
		else
		return new;
		end if;
	end
$body$ LANGUAGE plpgsql;

create trigger check_fullnes_room
before insert on client_booking for each row execute procedure fullnes_room();

insert into client_booking(id_booking, id_client)
	values(11,10);

--##########################################################################
create or replace function end_contract() RETURNS TRIGGER AS $body$
	declare
		
	begin
		if(NOW() > (select end_date limit 1
					from bilt_position
					inner join bill on bill.id_bill = bilt_position.id_bill
					inner join contract on contract.id_bill = bill.id_bill
					where contract.id_bill = new.id_bill)) then
			raise log 'Договор расторгнут';
			return null;
		else
			return new;
		end if;
	end
$body$ LANGUAGE plpgsql;

create trigger check_end_contract
before insert on bilt_position for each row execute procedure end_contract();



--##########################################

create or replace function update_cost_bilt() RETURNS TRIGGER 
AS $body$
	declare
		is_fiz_pers bool;
	begin
		
	
		raise log 'fiz_person - %', is_fiz_pers;
		
		if(new.id_room is NOT NULL) then
			
				perform update_cost_bilt_position(new.id_room,0,new.id_disscount,true,new.id_bilt_position);

		else

				perform update_cost_bilt_position(0,new.id_service,new.id_disscount,true,new.id_bilt_position);

			end if;
		end if;
		return null;
	end
$body$ LANGUAGE plpgsql;


create trigger recalculate_cost
after insert on bilt_position for each row 
execute procedure update_cost_bilt();

insert into bilt_position(id_bill,without_vat,without_disscount,id_room)
values(7,1,1,2);

select * from bilt_position where id_bill = 7;
   