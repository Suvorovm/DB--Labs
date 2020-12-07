
select count(*) from repo_hotel.client
    where client.entity_id <> 1;


select  * from repo_hotel.client
where client.entity_id <> 1;


update contract
    set id_status_contract = 2
    where id_status_contract = 3;




select * from contract
    inner join client c on c.id_client = contract.id_client
    inner join worker w on w.id_worker = contract.id_worker
    inner join status_contract sc on contract.id_status_contract = sc.id_status_contract
    inner join bilt_position bp on contract.id_contract = bp.id_contract
    inner join room r on r.id_room = bp.id_room
    inner join build b on r.id_build = b.id_build
    inner join category_room cr on cr.id_category_room = r.id_category_room
       WHERE sc.id_status_contract = 1 or sc.id_status_contract = 2;


select * from room
    inner join category_room cr on cr.id_category_room = room.id_category_room
    inner join build b on b.id_build = room.id_build;


select * from bilt_position
    inner join contract c on c.id_contract = bilt_position.id_contract
    inner join service s on s.id_service = bilt_position.id_service
    inner join client cli on cli.id_client = c.id_client
    where c.id_status_contract = 1 or c.id_status_contract = 2;




select * from booking
    inner join room on booking.id_room = room.id_room
    inner join status_booking sb on sb.id_status = booking.id_status
    inner join type_booking tb on tb.id_type_booking = sb.id_type_booking
    inner join contract c on c.id_contract = booking.id_contract
    inner join client cli on cli.id_client = c.id_client;


select  count(*) as count_records from booking
    inner join occupied_client oc on booking.id_booking = oc.id_booking
    inner join client c on c.id_client = oc.id_client

    inner join booking b on b.id_booking = oc.id_booking
    inner join room r on r.id_room = booking.id_room
    where c.id_client = 6 and r.id_room = 81;
