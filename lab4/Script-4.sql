/*Не давать пользователю ввести две одинаковые услуги
При попытки изменить имя услуги на уже существующее откатывать транзакцию*/

CREATE OR REPLACE FUNCTION add_service() RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql;


CREATE TRIGGER t_service
INSTEAD OF INSERT or UPDATE  ON SERVICES_VIEW FOR EACH ROW EXECUTE PROCEDURE add_service();


CREATE VIEW SERVICES_VIEW AS
        select * from service;


select * from SERVICES_VIEW;


INSERT INTO SERVICES_VIEW(service_name, service_cost)  values('Пин-понг', '360');

UPDATE SERVICES_VIEW set service_cost = 300
    where id_service = 27;
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
where service_for_room.id_room = 194

--########################################################################3   
--Добавление купленных номеров в счет (триггер)   

create or replace function room_in_bill() RETURNS TRIGGER AS $body$
	declare
		cost_room money;
		bill_id int;
	begin
		select into bill_id id_bill
			from contract
			inner join booking on booking.id_contract = contract.id_contract
				where booking.id_contract = new.id_contract;
		select into cost_room room_cost
			from room
				where room.id_room = new.id_room;	
		insert into bilt_position(id_bill,id_disscount,without_vat,without_disscount, id_room)
		values(bill_id,7,cost_room,cost_room,new.id_room);
	return NULL;
	end
$body$ LANGUAGE plpgsql;

create trigger add_room_bill
after insert on booking for each row execute procedure room_in_bill();
---Функция для бронирования номера
select booking_room('15.05.2020','11.06.2020',303,621,2);
--##################################################################################################3




   