create or replace function update_cost_bilt_position(
	id_room_input integer,
	id_service_input integer,
	id_discount_input integer,
	is_fiz_person_input bool,
	bilt_position_id integer
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
	   select into persent_discount_person disscount.diss_person from disscount
	            where id_disscount = id_discount_input;

	    if (is_fiz_person_input) then
            target_discount = persent_discount_person;
        else
            select into target_discount  disscount.diss_legal
            from disscount
                    where id_disscount = id_discount_input;
	    end if;
    end if;

	if(id_room_input = 0) then

	    if( not exists(select * from service where service.id_service = id_service_input)) then
	        raise log 'there is no service';
            rollback;
	        return 0;
        end if;
         select into service_cost_find  service.service_cost  from service
	        where service.id_service = id_service_input;

        cost_with_discount := service_cost_find - (service_cost_find / 100) * target_discount;
	    cost_with_out_nds := service_cost_find - (service_cost_find /100) * 18;
	    update bilt_position set 
		    without_vat=cost_with_out_nds,
		    without_disscount=service_cost_find,
		    with_discount=cost_with_discount
	    where bilt_position.id_bilt_position = bilt_position_id;
	    return 1;
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
	    update bilt_position set
		    without_vat=cost_with_out_nds,
		    without_disscount=room_cost,
		    with_discount=cost_with_discount
	    where bilt_position.id_bilt_position = bilt_position_id;
	    return 1;
	end if;

	return 0;
end
$body$
    LANGUAGE PLpgSQL;

select update_cost_bilt_position(0,5,6,true,1);
select test
select  * from disscount;
select * from service;

select * from bilt_position;


