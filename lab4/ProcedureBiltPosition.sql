create or replace function insert_into_bilt_position(
	id_room_input integer,
	id_service_input integer,
	id_discount_input integer,
	is_fiz_person_input bool

)
RETURNS integer AS $body$

declare
	service_cost_find decimal;
    room_cost decimal;
	persent_discount_person decimal;
    persent_discount_legal decimal;
    target_discount decimal;
	cost_with_discount decimal;
    cost_with_out_nds decimal;
    id_bilt_postion integer;
begin

	if (id_room_input = 0 and id_service_input = 0) then
        rollback;
	    return 0;
    end if;

	if (not exists( select * from disscount where id_disscount = id_discount_input))then
	    raise log 'there is no discount';
	    rollback;
        return 0;
    else
	   persent_discount_person= ( select disscount.diss_person from disscount
	            where id_disscount = id_discount_input);

	    if (is_fiz_person_input) then
            target_discount = persent_discount_person;
        else
            target_discount = (select  disscount.diss_legal
            from disscount
                    where id_disscount = id_discount_input);
	    end if;
    end if;

	if(id_room_input = 0) then

	    if( not exists(select * from service where service.id_service = id_service_input)) then
	        raise log 'there is no service';
            rollback;
	        return 0;
        end if;
        service_cost_find = (select  service.service_cost  from service
	        where service.id_service = id_service_input);

        cost_with_discount := service_cost_find - (service_cost_find / 100) * target_discount;
	    cost_with_out_nds := service_cost_find - (service_cost_find /100) * 18;
	    insert into bilt_position( id_disscount, without_vat, without_disscount, id_room, with_discount)
        values (id_discount_input, cost_with_out_nds,service_cost_find, null, cost_with_discount) returning id_bilt_postion;
	    commit;
	    return id_bilt_postion;
    else
	    if( not exists(select * from room where room.id_room = id_room_input)) then
	        raise log 'there is no rooms';
            rollback;
	        return 0;
        end if;
        select room.room_cost into  room_cost from room
	        where room.id_room = id_room_input;
	    cost_with_discount = room_cost - (room_cost / 100) * target_discount;
	    cost_with_out_nds = room_cost - (room_cost /100) * 18;
	    insert into bilt_position(id_disscount, without_vat, without_disscount, id_room, with_discount)
        values (id_discount_input, cost_with_out_nds,room_cost, id_room_input , cost_with_discount) returning id_bilt_postion;
	    commit;
	    return id_bilt_postion;
	end if;

	commit;
	return 0;
end
$body$
    LANGUAGE PLpgSQL;



select * from  insert_into_bilt_position(0, 5,6,true );
select  * from disscount;
select * from service;

select * from bilt_position;


