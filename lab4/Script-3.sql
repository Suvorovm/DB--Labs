---1 сложнай процедура на добавление
-- 2 хранимые процедуры

--ПРедоставление итоговой суммы постояльцу
CREATE OR REPLACE FUNCTION return_bill(
first_name varchar, 
second_name varchar, 
last_name varchar)
RETURNS integer AS $body$

declare 
ammnt money;
id_contr int;
id_bil int;
begin
	select into id_contr id_contract
	from contract
	where id_client = (select id_client 
						from client 
						where id_client = (select id_client 
											from fiz_person
											where forename = first_name 
												and surname = second_name 
												and lastname = last_name
										   )
						);

select into ammnt sum(without_vat)
from bilt_position
where id_bill = (select id_bill from contract where id_contract = id_contr );

select into id_bil id_bill 
from bill
where id_bill = (select id_bill from contract where id_contract = id_contr );

update bill
set ammount = ammnt
where id_bill = id_bil;

return 1;
end
$body$ LANGUAGE 'plpgsql';

select return_bill('Халим','Хамзин','Никитич');
select  * 
from bill
inner join contract on bill.id_bill = contract.id_bill
where id_contract = 621;

-------------------------------------------------------
--Заключение договора с  юр. лицом (транзакция)--------
-------------------------------------------------------
select create_contract_with_ur(
'г.Тест, ул.Тест 404',
'40404040404',
'40040040040',
'QA inc',
'04.04.2020',
'16.04.2020',
'404',
40
);
create or replace function create_contract_with_ur(
	adrss varchar,
	phone varchar,
	itn_num varchar,
	name_org varchar,
	start_dt timestamp,
	end_dt timestamp,
	num_contract int,
	worker_id int
)
RETURNS integer AS $body$

declare
	bill_id int;
	client_id int;
	contract_id int;
begin
	insert into client(adress,phone_number) 
	values (adrss, phone) returning client.id_client into client_id;	
if(client_id is NULL) then
	rollback;
	return 0;
end if;
	insert into ur_person(id_client, itn, name_organization)
	values (client_id,itn_num, name_org);
	insert into bill(ammount) values(0) returning bill.id_bill into bill_id;

if(bill_id is NULL) then
	rollback;
	return 0;
end if;

insert into contract(contract_number,start_date,end_date,id_client, id_bill,id_worker)
values(num_contract,start_dt,end_dt,client_id,bill_id,worker_id)
returning id_contract into contract_id;
if(contract_id is NULL) then
	rollback;
	return 0;
end if;
return contract_id;

end
$body$ LANGUAGE 'plpgsql';

---------------------------------------------------------
---Проверка на свободность номера в промежуток времени---
---------------------------------------------------------
create or replace function is_avaibale_room(
start_date timestamp, 
end_date timestamp, 
room_num integer
)
returns integer as $body$
declare
is_avaibale integer;
begin
	is_avaibale = 0;
	SELECT into is_avaibale Count(Room.Room_number)		   
	FROM Booking
	JOIN Room ON Booking.id_room = Room.id_room
	JOIN Build ON Build.id_Build = Room.id_Build
	WHERE (Booking.Settlement_time BETWEEN start_date AND end_date
		  AND
		  Booking.Departure_time BETWEEN start_date AND end_date 
		   AND Room.room_number = room_num)
		  OR (Booking.Settlement_time IS NULL AND 
				Booking.Departure_time IS NULL 
					AND Room.room_number = room_num);
	
	if is_avaibale = 0 then
		SELECT into is_avaibale Count(Room.Room_number)	 
		FROM Room
		JOIN Build ON Build.id_Build = Room.id_Build
		LEFT JOIN Booking ON Booking.id_room = Room.id_room
		WHERE Booking.id_booking is NULL AND Room.room_number = room_num;
	
		if( is_avaibale = 0) then
			 raise log 'the room is unavailable';
			 return 0;
		end if;

		if(is_avaibale = 1) then
			raise log 'the room is available';
			return 1;
		end if;
	end if;
  
	if(is_avaibale = 1) then
			raise log 'the room is available';
			return 1;
	end if;
return 0;
end
$body$ LANGUAGE 'plpgsql';

select is_avaibale_room('15.05.2020','11.06.2020',407);


select booking_room('15.05.2020','11.06.2020',407,621,3);
--------------------------------------------------------------
---Бронирование номера----------------------------------------
--------------------------------------------------------------
CREATE OR REPLACE FUNCTION booking_room(
	
	start_date timestamp,
	end_date timestamp,
	room_nb int,
	id_contr int,
	id_type_book int
)
RETURNS integer AS $body$
	declare 
	now_time timestamp;
	id_stts integer;
	change_check integer;
	check_room integer;
	room_id int;
begin
	select into room_id id_room from Room where room.room_number = room_nb;
	now_time = NOW()::timestamp;
	
if(id_type_book = 1 or id_type_book = 3) then
		
			select into change_check status_booking.id_status
			from status_booking
			inner join Booking on booking.id_status = status_booking.id_status
				where Booking.id_contract = id_contr and  Booking.id_room = room_id;

			if(change_check is NULL) then

				return 0;
			end if;
			
			update status_booking
			set (id_type_booking,time_operation) = (id_type_book,now_time)
				where id_status = change_check;

			return 1;
		end if;


	check_room = is_avaibale_room(start_date, end_date, room_nb);
	if(check_room = 1) then
		if(id_type_book = 2) then
			insert into status_booking(id_type_booking,time_operation)
				values(id_type_book,now_time);
			select into id_stts id_status
			from status_booking
				where id_type_booking = 2 and time_operation = now_time;
			if(id_stts is NULL) then
				
				return 0;
			end if;	
			
			insert into booking(id_contract, id_status,settlement_time,
					departure_time, booking_time, id_room)
			values (id_contr, id_stts,start_date, end_date, now_time,room_id);		
			
			return 1;

		end if;
		
		
	end if;;
return 0;
end
$body$ LANGUAGE 'plpgsql';


